`timescale 1ns / 1ps

module DataMem 
(input clk, input [2:0] MemRead, input [1:0] MemWrite,
    input [12:0] addr, input [31:0] data_in, output reg [31:0] data_out);
    //inst + data memory size 

    reg [7:0] mem [0:400];
    //divide memory into 300 for instructions and 100 for data
    wire [12:0] data_mem = 9'd300;
    //calculate offset of input data address based on new division
    wire [12:0] data_addr ;
    assign data_addr  = data_mem + addr;
    integer i;
    initial begin

        for(i=0; i<400; i=i+1)begin
            mem[i]=8'd0;
        end

        mem[data_mem + 0] = 8'd17; //first address at the starting point of data memory division
        mem[data_mem + 4] = 8'd9;
        mem[data_mem + 8] = 8'd25;

            $readmemh("C:/Users/laylamohsen/Documents/tests/test7.hex",mem);
//              for(i=0; i<200; i=i+1)begin
        //      $display("%h\n",mem[i]);

        //        end

    end

    //asynchronous load
    always@(*)
    begin
        if(!clk) begin
            if(MemRead!=0) begin
                if (MemRead == 3'b011) // lw 
                    data_out = {mem[data_addr+3], mem[data_addr+2], mem[data_addr+1], mem[data_addr]};

                else if (MemRead == 3'b010) begin // lh
                    data_out = $signed({mem[data_addr+1], mem[data_addr]});
                end

                else if (MemRead == 3'b001) begin // lb
                    data_out = $signed(mem[data_addr]);
                end

                else if (MemRead == 3'b101) // lhu
                    data_out = {mem[data_addr+1], mem[data_addr]};


                else if (MemRead == 3'b100) // lbu
                    data_out = mem[data_addr];
            end
            else
                data_out = 0;
        end
        else 
            //$display("pojfsaf");
        data_out={mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]};

    end
    //synchronous       
    always@(posedge clk)
    begin
        if (MemWrite != 0)begin
            if (MemWrite == 2'b01) // sb 
                mem[data_addr] = data_in[7:0];
            else if (MemWrite == 2'b10) // sh
                {mem[data_addr+1], mem[data_addr]} = data_in[15:0];
            else if (MemWrite == 2'b11) // sw
                {mem[data_addr+3], mem[data_addr+2], mem[data_addr+1], mem[data_addr]} = data_in;
           // else
           //     data_out = data_out;
        end
       // else
         //   data_out = data_out;
    end
endmodule

    
    
    
    
    
  
  
  
  
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    























































