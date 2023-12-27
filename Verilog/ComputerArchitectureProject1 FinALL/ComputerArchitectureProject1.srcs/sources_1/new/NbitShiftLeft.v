`timescale 1ns / 1ps

module NbitShiftLeft #(parameter N = 8)
(input [N-1:0] A,
output [N-1:0] Y);

assign Y = {A[N-2:0], 1'b0};

endmodule
