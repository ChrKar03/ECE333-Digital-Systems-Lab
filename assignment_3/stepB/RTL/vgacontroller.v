`timescale 1ns / 1ps

module vgacontroller(input reset, input clk, output VGA_RED,
    output VGA_GREEN, output VGA_BLUE, output VGA_HSYNC, output VGA_VSYNC);
    
    reg [6:0] HPIXEL, VPIXEL;
    
    wire RGB;
    wire [13:0] addr; 
    
    vram mem (reset, clk, addr, VGA_RED, VGA_GREEN, VGA_BLUE);
    hsync_fsm hcontrol (reset, clk, VGA_HSYNC, RGB);
    addrManager inst (reset, clk, RGB, addr);
endmodule
