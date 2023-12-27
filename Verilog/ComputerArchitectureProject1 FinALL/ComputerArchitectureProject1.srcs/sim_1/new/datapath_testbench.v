`timescale 1ns / 1ps


module Datapath_testbench();

    localparam clk_period = 10;

    reg clock;

    reg clock,reset;
    reg [1:0] LEDSelect;
    reg [3:0] SSDSelect;
    wire [15:0] LED;
    wire [12:0] SSDs;

    Datapath datapath1 (.clk(clock), .rst(reset), .ledSel(LEDSelect),
        .ssdSel(SSDSelect), .LEDs(LED), .ssd(SSDs));


    initial
    begin
        clock = 1'b0;
        forever # (clk_period/2) clock =~ clock;
    end

    initial
    begin

        reset = 1;
        LEDSelect = 2'b00;
        SSDSelect = 4'b0000;
        #(clk_period);

        reset = 0;
        LEDSelect = 2'b00;
        SSDSelect = 4'b0000;
        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);
        
//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);
        
//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);
        
//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);
        
//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);
        
//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);

//        reset = 0;
//        LEDSelect = 2'b00;
//        SSDSelect = 4'b0000;
//        #(clk_period);
        #2500

        $finish;
    end

endmodule
