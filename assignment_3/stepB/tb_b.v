`timescale 1ns / 1ps

module tb_b;
    reg clk, reset;
    wire VGA_RED, VGA_GREEN, VGA_BLUE, VGA_HSYNC, VGA_VSYNC;

    vgacontroller inst(reset, clk, VGA_RED, VGA_GREEN, VGA_BLUE, VGA_HSYNC, VGA_VSYNC);
    
    initial begin
        clk = 1'b0;
        reset = 1'b0;
        #10 reset = 1'b1;
        #200 reset = 1'b0;
    end
    
    always #5 clk = ~clk;
endmodule
