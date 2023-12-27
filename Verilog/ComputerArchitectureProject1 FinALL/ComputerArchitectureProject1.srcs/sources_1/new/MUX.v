`timescale 1ns / 1ps

module MUX(input A, B, sel, 
output Y);

assign Y = (sel == 1'b0)? A : B;

endmodule
