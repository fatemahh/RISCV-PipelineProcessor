`timescale 1ns / 1ps

module Nbit4MUX  #(parameter N = 32)
(input [N-1:0] A, [N-1:0] B, [N-1:0] C, [N-1:0] D, [1:0] sel,
output reg [N-1:0] Y);

always@(*)
begin
    case(sel)
        2'b00 : Y = A;
        2'b01 : Y = B;
        2'b10 : Y = C;
        2'b11 : Y = D;
        default : Y = 32'd0;
endcase
end
endmodule
