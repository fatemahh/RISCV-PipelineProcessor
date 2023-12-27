`timescale 1ns / 1ps

module  NbitRCA#(N=8)( input [N-1:0] a, [N-1:0] b, output [N:0] sum);

    wire [N:0] c;
    assign c[0] = 0;
    genvar i;

    generate
        for( i = 0; i< N; i=i+1) begin
            fulladder f(a[i], b[i], c[i], c[i+1], sum[i]);
        end
    endgenerate
    assign sum[N] = c[N];

endmodule
