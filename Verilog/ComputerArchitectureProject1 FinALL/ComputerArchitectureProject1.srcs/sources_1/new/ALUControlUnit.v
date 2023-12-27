`timescale 1ns / 1ps
`include "defines.v"

module ALUControlUnit(input [2:0] ALUOp, [6:0] funct7, [2:0] funct3,  output reg [4:0] ALUSel);

    always@(*)
    begin
        if (ALUOp == 3'b110) ALUSel = `ALU_PASS; // LUI 
        if (ALUOp == 3'b101) ALUSel = `ALU_ADD; // AUIPC & JAL

        if (ALUOp == 3'b001) ALUSel = `ALU_SUB; // BRANCH
        if (ALUOp == 3'b111) ALUSel = `ALU_ADD; // jalr

        if (ALUOp == 3'b000) ALUSel = `ALU_ADD; // LOAD & STORE
        if (ALUOp == 3'b100) ALUSel = `ALU_PASS; // Ebreak, ecall, fence

        if (ALUOp == 3'b011) begin // IMMEDIATE
            if (funct3 == 3'b000) ALUSel = `ALU_ADD; // addi
            if (funct3 == 3'b010) ALUSel = `ALU_SLT; // slti
            if (funct3 == 3'b011) ALUSel = `ALU_SLTU; // sltiu
            if (funct3 == 3'b100) ALUSel = `ALU_XOR; // xori
            if (funct3 == 3'b110) ALUSel = `ALU_OR; // ori
            if (funct3 == 3'b111) ALUSel = `ALU_AND; // andi
            if (funct3 == 3'b001 && funct7 == 7'b0000000) ALUSel = `ALU_SLL; // slli
            if (funct3 == 3'b101 && funct7 == 7'b0000000) ALUSel = `ALU_SRL; // srli
            if (funct3 == 3'b101 && funct7 == 7'b0100000) ALUSel = `ALU_SRA; // srai  
        end

        if (ALUOp == 3'b010) begin // R OPERATIONS
            if (funct3 == 3'b000 && funct7 == 7'b0000000) ALUSel = `ALU_ADD; // add
            if (funct3 == 3'b000 && funct7 == 7'b0100000) ALUSel = `ALU_SUB; // sub
            if (funct3 == 3'b001 && funct7 == 7'b0000000) ALUSel = `ALU_SLL; // sll
            if (funct3 == 3'b010 && funct7 == 7'b0000000) ALUSel = `ALU_SLT; // slt
            if (funct3 == 3'b011 && funct7 == 7'b0000000) ALUSel = `ALU_SLTU; // sltu
            if (funct3 == 3'b100 && funct7 == 7'b0000000) ALUSel = `ALU_XOR; // xor
            if (funct3 == 3'b101 && funct7 == 7'b0000000) ALUSel = `ALU_SRL; // srl
            if (funct3 == 3'b101 && funct7 == 7'b0100000) ALUSel = `ALU_SRA; // sra
            if (funct3 == 3'b110 && funct7 == 7'b0000000) ALUSel = `ALU_OR; // or    
            if (funct3 == 3'b111 && funct7 == 7'b0000000) ALUSel = `ALU_AND; // and
            
            if (funct3 == 3'b000 && funct7 == 7'b0000001) ALUSel = `ALU_MUL; // mul
            if (funct3 == 3'b001 && funct7 == 7'b0000001) ALUSel = `ALU_MULH; // mulh
            if (funct3 == 3'b010 && funct7 == 7'b0000001) ALUSel = `ALU_MULHS; // mulhs
            if (funct3 == 3'b011 && funct7 == 7'b0000001) ALUSel = `ALU_MULHU; // mulhu
            if (funct3 == 3'b100 && funct7 == 7'b0000001) ALUSel = `ALU_DIV; // div
            if (funct3 == 3'b101 && funct7 == 7'b0000001) ALUSel = `ALU_DIVU; // divu
            if (funct3 == 3'b110 && funct7 == 7'b0000001) ALUSel = `ALU_REM; // rem
            if (funct3 == 3'b111 && funct7 == 7'b0000001) ALUSel = `ALU_REMU; // remu    
        end



    end


endmodule
 
 
 
 
 
 
 
 
 
 
 
