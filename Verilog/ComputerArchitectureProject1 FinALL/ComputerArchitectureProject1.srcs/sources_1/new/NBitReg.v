`timescale 1ns / 1ps

module NbitReg#(parameter N = 32)
(input clk, reset, load, [N-1:0]D, 
output [N-1:0] Q);

wire [N-1:0] Y;
genvar i ;

generate 
for (i = 0; i < N; i=i+1) 
begin 
    MUX m (.A(Q[i]), .B(D[i]), .sel(load), .Y(Y[i]));
    DFlipFlop d (.clk(clk), .rst(reset), .D(Y[i]), .Q(Q[i]));
end
endgenerate

endmodule
