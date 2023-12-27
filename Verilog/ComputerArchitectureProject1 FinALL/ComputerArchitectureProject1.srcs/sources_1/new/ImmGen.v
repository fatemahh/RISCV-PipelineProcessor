`timescale 1ns / 1ps


module ImmGen(input [31:0] inst,
output reg [31:0] imm
    );
    wire [6:0]test = inst[6:0];
    
always@(*) begin

	case (inst[6:0])
		7'b0010011 : imm = { {21{inst[31]}}, inst[30:25], inst[24:21], inst[20] }; // arithmetic I
		7'b0100011 : imm = { {21{inst[31]}}, inst[30:25], inst[11:8], inst[7] }; // SW
		7'b0110111 : imm = { inst[31], inst[30:20], inst[19:12], 12'b0 };  // LUI
		7'b0010111 : imm = { inst[31], inst[30:20], inst[19:12], 12'b0 }; // AUIPC
		7'b1101111 : imm = { {12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0 }; // JAL
		7'b1100111 : imm = { {21{inst[31]}}, inst[30:25], inst[24:21], inst[20] }; // JALR
		7'b1100011 : imm = { {20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0}; // Branch
		default : imm = { {21{inst[31]}}, inst[30:25], inst[24:21], inst[20] }; // IMM_I
	endcase 
end

   

endmodule
