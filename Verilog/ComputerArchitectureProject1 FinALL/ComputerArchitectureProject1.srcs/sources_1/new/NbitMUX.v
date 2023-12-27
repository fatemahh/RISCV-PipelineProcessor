`timescale 1ns / 1ps

module NbitMUX #(parameter N = 8)
(input [N-1:0] A, [N-1:0] B, input sel,
output [N-1:0] Y);

genvar i ;

generate 
for (i = 0; i<N; i=i+1) 
begin 
    MUX m (.A(A[i]), .B(B[i]), .sel(sel), .Y(Y[i]));
end
endgenerate

endmodule
