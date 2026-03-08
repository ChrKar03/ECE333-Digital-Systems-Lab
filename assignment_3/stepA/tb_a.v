`timescale 1ns / 1ps

module tb_a;
    reg clk, reset;
    reg [13:0] addr;
    wire R, G, B;
    
    integer i;
    
    vram ram (reset, clk, addr, R, G, B);
    
    initial begin
        reset = 1'b0;
        clk = 1'b0;
        addr = {14{1'b0}};
    
        #10 reset = 1'b1;
        #200 reset = 1'b0;
        
        for (i = 0; i < 12287; i = i + 1) begin
            #20 addr = addr + 1'b1;
        end
        
        #1000 $finish;
    end
    
    always #5 clk = ~clk;
endmodule
