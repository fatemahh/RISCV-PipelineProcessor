`timescale 1ns / 1ps

module Datapath(input clk, rst, [1:0] ledSel, [3:0]ssdSel,
    output reg [15:0] LEDs, output reg [12:0] ssd);

    // =================================== IF ================================

    wire [31:0] PC_out;
    wire [31:0] Instruction;
    wire [31:0] datain;
    wire EBreaking = ((IF_ID_Inst[6:0] == 7'b1110011) && (IF_ID_Inst[20] == 1'b1))? 1:0;

    // PC
    NbitReg #(32) PC (.clk(clk), .reset(rst), .load(~EBreaking), .D(PCnew), .Q(PC_out));

    // PC + 4
    wire [31:0]PCAdder4_Out;
    NbitRCA #(32) PCAdder (.a(4), .b(PC_out), .sum(PCAdder4_Out));

    // INSTRUCTION MEMORY
    // InstMem InstructionMemory(.addr(PC_out[11:2]), .data_out(Instruction));

    wire [31:0] IF_ID_PC, IF_ID_Inst, IF_ID_PCAdder4;
    // 1 1 1 
    wire [31:0] DataMemoryOut;

    NbitReg #(100) IF_ID (.clk(!clk), .reset(rst), .load(1'b1),
        .D({PC_out, DataMemoryOut, PCAdder4_Out}), .Q({IF_ID_PC, IF_ID_Inst, IF_ID_PCAdder4}) );

    // =================================== ID ================================

    // CONTROL UNIT
    wire Br;
    wire [2:0] MRead;
    wire MReg;
    wire [1:0] MWrite;
    wire ALUSource;
    wire RWrite;
    wire [2:0] ALUOperation;
    ControlUnit CU(.inst(IF_ID_Inst[6:2]), .funct3(IF_ID_Inst[14:12]), .branch(Br), .MemRead(MRead), .MemtoReg(MReg),
        .MemWrite(MWrite), .ALUSrc(ALUSource), .RegWrite(RWrite), .ALUOp(ALUOperation));

    // IMMEDIATE GENERATOR
    wire [31:0] Immediate;
    ImmGen immediategen (.inst(IF_ID_Inst), .imm(Immediate));

    // REGISTER MEMORY
    wire [31:0] readata1;
    wire [31:0] readata2;
    NBit32Reg Registers (.regread1(IF_ID_Inst[19:15]), .regread2(IF_ID_Inst[24:20]), .regwrite(MEM_WB_Rd),
        .clk(clk), .rst(rst), .write(MEM_WB_Ctrl[0]), .imm(writereg), .outreg2(readata2), .outreg1(readata1));

    // ID_EX_Ctrl = WB [11] memtoreg, [10] regwrite, M [9:7] memread, [6:5] memwrite, [4] branch, EX [3] Alusource, [2:0] aluop
    wire [31:0] ID_EX_Inst, ID_EX_PCAdder4;
    wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm;
    wire [11:0] ID_EX_Ctrl;
    wire [3:0] ID_EX_Func;
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
    NbitReg #(230) ID_EX (.clk(clk),.reset(rst),.load(1'b1),
        .D({IF_ID_Inst, {MReg, RWrite, MRead, MWrite, Br, ALUSource, ALUOperation}, IF_ID_PC, readata1, readata2, Immediate,
        {IF_ID_Inst[30], IF_ID_Inst[14:12]}, IF_ID_Inst[19:15], IF_ID_Inst[24:20], IF_ID_Inst[11:7], IF_ID_PCAdder4}),
        .Q({ID_EX_Inst, ID_EX_Ctrl, ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, ID_EX_Func, ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd, ID_EX_PCAdder4}) );

    // =================================== EX ================================

    //___________________________________________________________________________

    // FORWARDING
    wire [1:0]ForwardA, ForwardB;
    
    Forwarding_Unit fu(
        .IdEx_RegRs1(ID_EX_Rs1), .IdEx_RegRs2(ID_EX_Rs2), .ExMem_RegRd(EX_MEM_Rd), .MemWb_RegRd(MEM_WB_Rd),
        .ExMem_RegWrite(EX_MEM_Ctrl[10]), .MemWb_RegWrite(MEM_WB_Ctrl[0]),
        .ForwardA(ForwardA), .ForwardB(ForwardB));
    //___________________________________________________________________________

    // FORWARDING MUX
    wire [31:0] MUXForwardA;
    wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR1, EX_MEM_RegR2;

    Nbit4MUX #(32) MUXFwdA  (.A(ID_EX_RegR1), .B(writereg), .C(EX_MEM_ALU_out), .D(32'b0), .sel(ForwardA), .Y(MUXForwardA));
    wire [31:0] MUXForwardB;
    Nbit4MUX #(32) MUXFwdB (.A(ID_EX_RegR2), .B(writereg), .C(EX_MEM_ALU_out),.D(32'b0), .sel(ForwardB), .Y(MUXForwardB));

    // MUX IMMEDIATE OR REGISTER 2
    wire [31:0] Mux1Out;
    NbitMUX #(32) Mux1 (.A(MUXForwardB), .B(ID_EX_Imm), .sel(ID_EX_Ctrl[3]),.Y(Mux1Out));
    // MUX BETWEEN IMMEDIATE AND VALUE OF REGISTER 2, INPUT TO ALU
    // wire [31:0] Mux1Out;
    //NbitMUX #(32) Mux1 (.A(ID_EX_RegR2), .B(ID_EX_Imm), .sel(ID_EX_Ctrl[3]),.Y(Mux1Out));

    // ALU CONTROL UNIT
    wire [4:0] ALUSelect;
    ALUControlUnit ALUControl (.ALUOp(ID_EX_Ctrl[2:0]), .funct7(ID_EX_Inst[31:25]), .funct3(ID_EX_Inst[14:12]),  .ALUSel(ALUSelect));

    // ALU
    wire [31:0] ALUout;
    wire zf, cf, vf, sf;
    //    NbitALU #(32) ALU (.sel(ALUSelect), .shamt(Mux1Out[4:0]),
    //        .A(ID_EX_RegR1), .B(Mux1Out), .zf(zf), .cf(cf), .vf(vf), .sf(sf), .ALU_out(ALUout) );
    NbitALU #(32) ALU (.sel(ALUSelect), .shamt(Mux1Out[4:0]),
        .A(MUXForwardA), .B(Mux1Out), .zf(zf), .cf(cf), .vf(vf), .sf(sf), .ALU_out(ALUout) );

    // ADDER OF IMMEDIATE AND PC
    wire [31:0]OffsetAdder_Out;
    NbitRCA #(32) OffsetAdder (.a(ID_EX_Imm), .b(ID_EX_PC), .sum(OffsetAdder_Out));

    // EX_MEM_Ctrl = WB [7] memtoreg, [6] regwrite, M [5:3] memread, [2:1] memwrite, [0] branch
    wire [31:0] EX_MEM_Inst, EX_MEM_PCAdder4;
    wire [31:0] EX_MEM_Imm;
    //    wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR1, EX_MEM_RegR2; 
    wire [7:0] EX_MEM_Ctrl;
    wire [4:0] EX_MEM_Rd;
    wire [2:0] EX_MEM_ALUOpLUIAUIPC;
    wire EX_MEM_zf, EX_MEM_cf, EX_MEM_vf, EX_MEM_sf;
    //// ID_EX_Ctrl = WB [11] memtoreg, [10] regwrite, M [9:7] memread, [6:5] memwrite, [4] branch, EX [3] Alusource, [2:0] aluop
    //    NbitReg #(250) EX_MEM (.clk(clk), .reset(rst), .load(1'b1), .D({ID_EX_Inst, ID_EX_Imm, ID_EX_Ctrl[11:4], 
    //    OffsetAdder_Out, zf, cf, vf, sf, ALUout, ID_EX_Ctrl[2:0], ID_EX_RegR1, ID_EX_RegR2, ID_EX_Rd, ID_EX_PCAdder4}), 
    //    .Q({EX_MEM_Inst, EX_MEM_Imm, EX_MEM_Ctrl, EX_MEM_BranchAddOut, EX_MEM_zf, EX_MEM_cf, EX_MEM_vf, EX_MEM_sf, 
    //    EX_MEM_ALU_out, EX_MEM_ALUOpLUIAUIPC, EX_MEM_RegR1, EX_MEM_RegR2, EX_MEM_Rd, EX_MEM_PCAdder4}));
    NbitReg #(250) EX_MEM (.clk(!clk), .reset(rst), .load(1'b1), .D({ID_EX_Inst, ID_EX_Imm, EX_MEM_Flush,
        OffsetAdder_Out, zf, cf, vf, sf, ALUout, ID_EX_Ctrl[2:0], ID_EX_RegR1, MUXForwardB, ID_EX_Rd, ID_EX_PCAdder4}),
        .Q({EX_MEM_Inst, EX_MEM_Imm, EX_MEM_Ctrl, EX_MEM_BranchAddOut, EX_MEM_zf, EX_MEM_cf, EX_MEM_vf, EX_MEM_sf,
        EX_MEM_ALU_out, EX_MEM_ALUOpLUIAUIPC, EX_MEM_RegR1, EX_MEM_RegR2, EX_MEM_Rd, EX_MEM_PCAdder4}));
    // =================================== MEM ================================
    //SINGLE MEMORY MUX 
    NbitMUX #(32) SingleMem (.A(EX_MEM_ALU_out), .B(PC_out), .sel(clk), .Y(datain));
    // BRANCH OUTCOME 1 IF TAKE BRANCH, 0 IF NOT
    wire BranchOut;
    Branch branching (.zf(EX_MEM_zf), .sf(EX_MEM_sf), .vf(EX_MEM_vf), .cf(EX_MEM_cf), .opcode(EX_MEM_Inst[6:2]), .funct3(EX_MEM_Inst[14:12]), .BranchOut(BranchOut));

    // DATA MEMORY
    //    wire [31:0] DataMemoryOut;
    DataMem DataMemory (.clk(clk), .MemRead(EX_MEM_Ctrl[5:3]), .MemWrite(EX_MEM_Ctrl[2:1]), .addr(datain), .data_in(EX_MEM_RegR2), .data_out(DataMemoryOut));

    // MEM_WB_Ctrl = WB [1] memtoreg, [0] regwrite
    wire [31:0] MEM_WB_Inst, MEM_WB_PCAdder4, MEM_WB_RegR1;
    wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out;
    wire [31:0] MEM_WB_Imm;
    wire [1:0] MEM_WB_Ctrl;
    wire [31:0] MEM_WB_BranchAddOut;
    wire [4:0] MEM_WB_Rd;
    wire [2:0] MEM_WB_ALUOpLUIAUIPC;
    NbitReg #(240) MEM_WB (.clk(clk), .reset(rst), .load(1'b1), .D({EX_MEM_Inst, EX_MEM_Imm, EX_MEM_Ctrl[7:6], DataMemoryOut, EX_MEM_ALU_out, EX_MEM_BranchAddOut, EX_MEM_ALUOpLUIAUIPC, EX_MEM_RegR1, EX_MEM_Rd, EX_MEM_PCAdder4}),
        .Q({MEM_WB_Inst, MEM_WB_Imm, MEM_WB_Ctrl, MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_BranchAddOut, MEM_WB_ALUOpLUIAUIPC, MEM_WB_RegR1, MEM_WB_Rd, MEM_WB_PCAdder4}) );

    // =================================== WB ================================

    // PART 1, MUX BETWEEN ALU RESULT AND OUTPUT OF MEMORY TO WRITE TO REGISTER
    wire [31:0] Mux2Out;
    NbitMUX #(32) Mux2 (.A(MEM_WB_ALU_out), .B(MEM_WB_Mem_out), .sel(MEM_WB_Ctrl[1]), .Y(Mux2Out));

    // PART 2, MUX SELECTS BETWEEN AUIPC IF SEL2  = 0, AND LUI IS SEL2 = 1
    wire [31:0] Lui_Auipc_Mux;
    wire sel2 = (MEM_WB_Inst[6:2] == 5'b01101); // 1 IF INSTRUCTIO IS LUI
    NbitMUX #(32) LuiAuipcMux(.A(MEM_WB_BranchAddOut), .B(MEM_WB_Imm), .sel(sel2),.Y(Lui_Auipc_Mux));

    // PART 3, MUX, EITHER PREVIOUS RESULT OR LUI, AUIPC INSTRUCTION
    wire [31:0] DataMem_ALU_Auipc_Mux;
    wire sel = (MEM_WB_ALUOpLUIAUIPC == 3'b110); // 1 IF INSTRUCTION IS LUI OR AUIPC
    NbitMUX #(32) DataMemALUAuipc_Mux (.A(Mux2Out), .B(Lui_Auipc_Mux), .sel(sel),.Y(DataMem_ALU_Auipc_Mux));

    // PART 4, MUX BETWEEN PREVIOUS AND PC + 4 FOR JALR, INPUT TO REGISTER
    wire[31:0] writereg;
    wire seljalr = (MEM_WB_Inst[6:2] == 5'b11001);
    NbitMUX #(32) FinalMux (.A(DataMem_ALU_Auipc_Mux), .B(MEM_WB_PCAdder4), .sel(seljalr),.Y(writereg));

    // ---------------------------------- HANDLE PC ---------------

    // PART 1, MUX CHOOSES BETWEEN NEXT LINE, OR BRANCH FOR PC
    wire [31:0] Mux3Out;
    // wire selectMux3 = Br & BranchOut;
    wire selectMux3 = EX_MEM_Ctrl[0] & BranchOut;
    NbitMUX #(32) Mux3 (.A(PCAdder4_Out), .B(EX_MEM_BranchAddOut), .sel(selectMux3), .Y(Mux3Out));

    // PART 2, MUX CHOOSES BETWEEN LAST RESULT AND CHECKS IF IT IS EBREAK INSTRUCTION TO REMAIN IN SAME PC
    wire [31:0] PCnew2;
    NbitMUX #(32) EBreak (.A(Mux3Out), .B(IF_ID_PCAdder4), .sel(EBreaking), .Y(PCnew2));

    // PART 3, MUX CHOOSES BETWEEN LAST RESULT AND CHECKS IF IT IS JALR INSTRUCTION TO SET PC = RS1 + OFFSET
    wire [31:0] PCnew, JALRadderout;
    NbitRCA #(32) JALRadder (.a(MEM_WB_Imm), .b(MEM_WB_RegR1), .sum(JALRadderout));
    NbitMUX #(32) jalrmux (.A(PCnew2), .B(JALRadderout), .sel(seljalr), .Y(PCnew));

    //--------------------------------FLUSHING----------------------------

    // 10 bc we only flush out the control signals 
    wire [7:0] EX_MEM_Flush;
    NbitMUX #(12) EXMEMFlush(.A(ID_EX_Ctrl[11:4]),.B(10'd0),.sel(BranchOut || seljalr || EBreaking),.Y(EX_MEM_Flush));

    // ----------------------- NOT USED ----------------------- 
    // ----------------------- NOT USED ----------------------- 

    wire [31:0]Shift;
    NbitShiftLeft #(32) ShiftLeft (.A(Immediate), .Y(Shift));

    wire [16:0] ControlConcatenation = {2'b0, Br, MRead, MReg, MWrite, ALUSource,
    RWrite, ALUOperation [1:0], ALUSelect [3:0], zf, selectMux3}; // used for output

    //_________________________________

    always@(*)
    begin
        if (ledSel == 2'b00) begin
            LEDs = Instruction[15:0];
        end
        else if (ledSel == 2'b01) begin
            LEDs = Instruction[31:16];
        end
        else begin
            LEDs = ControlConcatenation;
        end
    end

    //_________________________________

    always@(*)
    begin
        if (ssdSel == 4'b0000) begin
            ssd = PC_out[12:0];
        end
        else if (ssdSel  == 4'b0001) begin
            ssd = PCAdder4_Out[12:0];
        end
        else if (ssdSel  == 4'b0010) begin
            ssd = OffsetAdder_Out[12:0];
        end
        else if (ssdSel  == 4'b0011) begin
            ssd = Mux3Out[12:0];
        end
        else if (ssdSel  == 4'b0100) begin
            ssd = readata1[12:0];
        end
        else if (ssdSel  == 4'b0101) begin
            ssd = readata2[12:0];
        end
        else if (ssdSel  == 4'b0110) begin
            ssd = Mux2Out[12:0];
        end
        else if (ssdSel  ==  4'b0111) begin
            ssd = Immediate[12:0];
        end
        else if (ssdSel  == 4'b1000) begin
            ssd = Shift[12:0];
        end
        else if (ssdSel  == 4'b1001) begin
            ssd = Mux2Out[12:0];
        end
        else if (ssdSel  == 4'b1010) begin
            ssd = ALUout[12:0];
        end
        else if (ssdSel  == 4'b1011) begin
            ssd = DataMemoryOut[12:0];
        end

    end


endmodule





 
 
 
 
 
 
 
 
 
