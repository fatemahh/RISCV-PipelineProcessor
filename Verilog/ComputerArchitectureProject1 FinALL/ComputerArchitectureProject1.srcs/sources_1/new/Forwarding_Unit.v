`timescale 1ns / 1ps

//module Forwarding_Unit(
//    input [4:0] ID_EX_rs1, ID_EX_rs2, EX_MEM_rd, MEM_WB_rd,
//    input EX_MEM_RegWrite, MEM_WB_RegWrite,
//    output reg [1:0] forward_A, forward_B
//);

//    always@(*) begin
   
//        forward_A = 2'b00;
//        forward_B = 2'b00;
       
//        // Execution Hazard
//        if(EX_MEM_RegWrite == 1'b1 && EX_MEM_rd != 0 && EX_MEM_rd == ID_EX_rs1) begin
//            forward_A = 2'b10;
//        end
       
//        if(EX_MEM_RegWrite == 1'b1 && EX_MEM_rd != 0 && EX_MEM_rd == ID_EX_rs2) begin
//            forward_B = 2'b10;
//        end
       
       
//        // Memory Hazard
//        if(MEM_WB_RegWrite == 1'b1 && MEM_WB_rd != 0 && MEM_WB_rd == ID_EX_rs1
//         && !(EX_MEM_RegWrite == 1'b1 && EX_MEM_rd != 0 && EX_MEM_rd == ID_EX_rs1)) begin
//            forward_A = 2'b01;
//        end
       
//        if(MEM_WB_RegWrite == 1'b1 && MEM_WB_rd != 0 && MEM_WB_rd == ID_EX_rs2
//         && !(EX_MEM_RegWrite == 1'b1 && EX_MEM_rd != 0 && EX_MEM_rd == ID_EX_rs2)) begin
//            forward_B = 2'b01;
//        end
       
       
//    end
//endmodule



module Forwarding_Unit(
    input [4:0] IdEx_RegRs1, IdEx_RegRs2, ExMem_RegRd, MemWb_RegRd,
    input ExMem_RegWrite, MemWb_RegWrite,
    output reg [1:0] ForwardA, ForwardB
);

    always@(*) begin

        if (ExMem_RegWrite && (ExMem_RegRd != 0) && (ExMem_RegRd == IdEx_RegRs1))
            ForwardA = 2'b10;
        else if ( MemWb_RegWrite && (MemWb_RegRd != 0)
        && (MemWb_RegRd == IdEx_RegRs1) )
            ForwardA = 2'b01 ;
        else ForwardA = 2'b00 ;
    end

    always @(*) begin
        if (ExMem_RegWrite && (ExMem_RegRd != 0) && (ExMem_RegRd == IdEx_RegRs2))
            ForwardB = 2'b10;
        else if ( MemWb_RegWrite && (MemWb_RegRd !=0)
        && (MemWb_RegRd == IdEx_RegRs2) )
            ForwardB = 2'b01 ;
        else ForwardB = 2'b00;
    end
endmodule