`timescale 1ns / 1ps

module NBit32Reg #(parameter N = 32) ( input [4:0] regread1, [4:0] regread2, [4:0] regwrite, input clk, rst, write, [N-1:0] imm,
output [N-1:0] outreg2, [N-1:0] outreg1);
    

reg [N-1:0] regfile[31:0];
integer i;

always@(negedge(clk))
begin
    if (rst == 1'b1)
        begin
            for (i = 0; i < 32; i = i+1) begin
                regfile[i] <= 0;
            end
        end
     else begin
        if (write == 1'b1) begin
            if (regwrite != 0)
            begin
            regfile[regwrite] <= imm;
            end
            end
        end
end

assign outreg1 = regfile[regread1];
assign outreg2 = regfile[regread2];

   
endmodule
