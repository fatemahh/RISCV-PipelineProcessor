`timescale 1ns / 1ps

module TopSSD(input clk, rst, [1:0] ledSel, [3:0]ssdSel, input ssdclk,
output  [15:0] LEDs, output  [3:0] Anode, 
output wire [6:0] LED_out);

wire [12:0] number;

SevenSegmentDisplay digitdisplay ( .clk(ssdclk), .num(number), .Anode(Anode), 
.LED_out(LED_out));

Datapath riscv (.clk(clk), .rst(rst), .ledSel(ledSel), .ssdSel(ssdSel), 
 .LEDs(LEDs), .ssd(number));
    
endmodule
