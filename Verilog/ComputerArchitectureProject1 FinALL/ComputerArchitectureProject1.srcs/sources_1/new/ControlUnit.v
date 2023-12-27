`timescale 1ns / 1ps


module ControlUnit( input [4:0] inst, input [2:0] funct3, output reg branch, reg [2:0] MemRead,
    reg MemtoReg, reg [1:0] MemWrite,  output reg ALUSrc, reg RegWrite, reg [2:0] ALUOp);

    always@(*)
    begin
        if (inst == 5'b01100) // R-Format
            begin
                branch = 0;
                MemRead= 3'b000;
                MemtoReg = 0;
                ALUOp = 3'b010;
                MemWrite = 2'b00;
                ALUSrc = 0;
                RegWrite = 1;
            end
        else if (inst == 5'b00100) // I-Format
            begin
                branch = 0;
                MemRead= 3'b000;
                MemtoReg = 0;
                ALUOp = 3'b011;
                MemWrite = 2'b00;
                ALUSrc = 1;
                RegWrite = 1;
            end
        else if (inst == 5'b00000) // Load
            begin
                if (funct3 == 3'b000) begin // lb
                    branch = 0;
                    MemRead= 3'b001;
                    MemtoReg = 1;
                    ALUOp = 3'b000;
                    MemWrite = 2'b00;
                    ALUSrc = 1;
                    RegWrite = 1;

                end
                if (funct3 == 3'b001) begin // lh
                    branch = 0;
                    MemRead= 3'b010;
                    MemtoReg = 1;
                    ALUOp = 3'b000;
                    MemWrite = 2'b00;
                    ALUSrc = 1;
                    RegWrite = 1;
                end
                if (funct3 == 3'b010) begin // lw
                    branch = 0;
                    MemRead= 3'b011;
                    MemtoReg = 1;
                    ALUOp = 3'b000;
                    MemWrite = 2'b00;
                    ALUSrc = 1;
                    RegWrite = 1;
                end
                if (funct3 == 3'b100) begin // lbu
                    branch = 0;
                    MemRead= 3'b100;
                    MemtoReg = 1;
                    ALUOp = 3'b000;
                    MemWrite = 2'b00;
                    ALUSrc = 1;
                    RegWrite = 1;
                end
                if (funct3 == 3'b101) begin // lhu
                    branch = 0;
                    MemRead= 3'b101;
                    MemtoReg = 1;
                    ALUOp = 3'b000;
                    MemWrite = 2'b00;
                    ALUSrc = 1;
                    RegWrite = 1;
                end
            end
        else if (inst == 5'b01000) // Store
            begin
                if (funct3 == 3'b000) begin // sb
                    branch = 0;
                    MemRead= 3'b000;
                    MemtoReg = 0;
                    ALUOp = 3'b000;
                    MemWrite = 2'b01;
                    ALUSrc = 1;
                    RegWrite = 0;
                end
                if (funct3 == 3'b001) begin // sh
                    branch = 0;
                    MemRead= 3'b000;
                    MemtoReg = 0;
                    ALUOp = 3'b000;
                    MemWrite = 2'b10;
                    ALUSrc = 1;
                    RegWrite = 0;
                end
                if (funct3 == 3'b010) begin // sw
                    branch = 0;
                    MemRead= 3'b000;
                    MemtoReg = 0;
                    ALUOp = 3'b000;
                    MemWrite = 2'b11;
                    ALUSrc = 1;
                    RegWrite = 0;
                end
            end
        else if (inst == 5'b11000) begin // Branch 
            branch = 1;
            MemRead= 3'b000;
            MemtoReg = 0;
            ALUOp = 3'b001;
            MemWrite = 2'b00;
            ALUSrc = 0;
            RegWrite = 0;
        end

        else if (inst == 5'b11100 || inst == 5'b00011) // Ebreak, ecall, fence
            begin
                branch = 0;
                MemRead= 3'b000;
                MemtoReg = 0;
                ALUOp = 3'b100; // don't know
                MemWrite = 2'b00;
                ALUSrc = 0;
                RegWrite = 0;
            end
        else if (inst == 5'b11011) // Jal
            begin
                branch = 1;
                MemRead= 3'b000;
                MemtoReg = 0;
                ALUOp = 3'b101; // don't know
                MemWrite = 2'b00;
                ALUSrc = 0;
                RegWrite = 0;        end
        else if (inst == 5'b11001)
            begin
                branch = 1;
                MemRead= 3'b000;
                MemtoReg = 0;
                ALUOp = 3'b111; // don't know
                MemWrite = 2'b00;
                ALUSrc = 0;
                RegWrite = 1;
            end
        else // lui auipc
            begin
                branch = 0;
                MemRead= 3'b000;
                MemtoReg = 1;
                ALUOp = 3'b110; // don't know
                MemWrite = 2'b00;
                ALUSrc = 0;
                RegWrite = 1;        end
    end


endmodule
   
    
    
    
    
    
    
    
    
    
    
    
