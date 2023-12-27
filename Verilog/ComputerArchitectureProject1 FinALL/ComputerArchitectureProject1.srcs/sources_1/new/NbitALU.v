`timescale 1ns / 1ps
`include "defines.v"

module NbitALU #(parameter N = 32)(input [4:0]sel, wire [4:0] shamt, [N-1:0]A, [N-1:0]B,
    output zf, cf, vf, sf, reg [N-1:0] ALU_out );

    wire [N-1:0] B2;
    wire [N-1:0] addout;
    wire [N*2 - 1:0] mul, mulu, mulsu;
    assign mul = $signed(A) * $signed(B);
    assign mulu = A * B;
    assign mulsu = $signed(A) * B;
    wire [N-1:0] div, divu, rem, remu;
    assign div = $signed(A) / $signed(B);
    assign divu = A / B;
    assign rem = $signed(A) % $signed(B);
    assign remu = A % B;
    assign B2 = (~B);
    assign {cf, addout} = sel[0] ? (A + B2 + 1'b1) : (A + B);

    assign zf = (addout == 0);
    assign sf = addout[31];
    assign vf = (A[31] ^ (B2[31]) ^ addout[31] ^ cf);


    assign AU = (~A) + 1'b1;
    assign BU = (~B) + 1'b1;

    wire [N-1:0] shiftout;
    Shifter shift (.A(A), .shamt(shamt),.type(sel[1:0]), .Shift_out(shiftout) );
    always@(*)
    begin

        if (sel == `ALU_ADD || sel == `ALU_SUB ) // adding or subtract
        begin
            ALU_out = addout;
        end
        
        else if (sel == `ALU_PASS) // PASS
            begin
                ALU_out = B;
            end

        else if (sel == `ALU_OR) //ORing
            begin
                ALU_out = A | B;
            end

        else if (sel == `ALU_AND) // and
            begin
                ALU_out = A & B;
            end

        else if (sel == `ALU_XOR) // xor
            begin
                ALU_out = A ^ B;
            end

        else if (sel == `ALU_SRL) // srl
            begin
                ALU_out = shiftout;
            end

        else if (sel == `ALU_SRA) // sra
            begin
                ALU_out = shiftout;
            end

        else if (sel == `ALU_SLL) // sll
            begin
                ALU_out = shiftout;
            end

        else if (sel == `ALU_SLT) // slt
            begin
                ALU_out = {31'b0,(sf != vf)};
            end

        else if (sel == `ALU_SLTU) // sltu
            begin
                ALU_out = {31'b0,(~cf)} ;
            end
        
        else if (sel == `ALU_MUL) // MUL
            begin
                ALU_out[16:0] = mul[31:0];
            end

        else if (sel == `ALU_MULH) //MULH
            begin
                ALU_out = mul[63:32];
            end

        else if (sel == `ALU_MULHS) // MULHS
            begin
                ALU_out = mulsu[63:32];
            end
            
        else if (sel == `ALU_MULHU) // MULHU
            begin
                ALU_out = mulu[63:32];
            end

        else if (sel == `ALU_DIV) // DIV
            begin
                ALU_out = div;
            end

        else if (sel == `ALU_DIVU) // DIVU
            begin
                ALU_out = divu;
            end
            
        else if (sel == `ALU_REM) // REM
            begin
                ALU_out = rem;
            end

        else if (sel == `ALU_REMU) //REMU
            begin
                ALU_out = remu;
            end

        else
            begin
                ALU_out = 0;
            end

    end

endmodule


 
 
 
 
