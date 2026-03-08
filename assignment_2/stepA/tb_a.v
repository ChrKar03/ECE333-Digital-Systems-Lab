`timescale 1ns / 1ps

module tb_a;
    wire s_enb;
    reg rst, clk;
    reg [2:0] bs;
    
    baud_controller inst (rst, clk, bs, s_enb);
    
    initial begin
        rst = 1'b0;
        bs = 3'b000;

        #10 rst = 1'b1;
        #10 rst = 1'b0;
        
        #208350 bs = bs + 1'b1;
        #52100 bs = bs + 1'b1;
        #13030 bs = bs + 1'b1;
        #6520 bs = bs + 1'b1;
        #3270 bs = bs + 1'b1;
        #1640 bs = bs + 1'b1;
        #1100 bs = bs + 1'b1;
        #550 bs = bs + 1'b1;
    end
    
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
endmodule
