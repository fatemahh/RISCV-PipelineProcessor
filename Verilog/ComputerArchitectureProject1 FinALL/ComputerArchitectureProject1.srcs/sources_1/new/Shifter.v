`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2023 08:53:25 PM
// Design Name: 
// Module Name: Shifter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Shifter( input [31:0] A, [4:0] shamt,[1:0] type, output reg [31:0] Shift_out );

always@(*)
begin
    if (type == 2'b00) begin // srl
        Shift_out = A >> shamt;
    end
    else if (type == 2'b10) begin // sra
        Shift_out = $signed(A) >>> shamt;
    end
    else begin // sll
        Shift_out = A << shamt;
    end

end

endmodule
