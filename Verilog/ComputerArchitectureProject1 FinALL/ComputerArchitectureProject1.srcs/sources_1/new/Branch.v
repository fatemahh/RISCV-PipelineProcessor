`timescale 1ns / 1ps

module Branch(input zf, sf, vf, cf, [4:0] opcode, [2:0] funct3, output reg BranchOut);

    always@(*)
    begin
        if (opcode == 5'b11000) begin
            if (funct3 == 3'b000) begin // beq
                    BranchOut = zf;
            end
            else if (funct3 == 3'b001) begin // bne
     
                    BranchOut = ~zf;
            end
            else if (funct3 == 3'b100) begin // blt
                
                    BranchOut = (sf != vf);
            end
            else if (funct3 == 3'b101) begin // bge
    
                    BranchOut = (sf == vf);
            end
            else if (funct3 == 3'b110) begin // bltu
          
                    BranchOut = ~cf;
            end
            else begin // bgeu
  
                    BranchOut = cf;
            end
        end
        else if (opcode == 5'b11011)
            BranchOut = 1;
        else
            BranchOut = 0;
    end



endmodule
