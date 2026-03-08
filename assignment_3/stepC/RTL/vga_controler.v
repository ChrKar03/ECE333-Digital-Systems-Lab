`timescale 1ns / 1ps

module vga_controller(input reset, input clk, output VGA_RED,
    output VGA_GREEN, output VGA_BLUE, output VGA_HSYNC, output VGA_VSYNC);

    wire H_RGB, V_RGB;
    wire [13:0] addr; 
    
    vram mem (reset, clk, addr, VGA_RED, VGA_GREEN, VGA_BLUE);
    hsync_fsm hcontrol (reset, clk, VGA_HSYNC, H_RGB);
    vsync_fsm vcontrol (reset, clk, VGA_VSYNC, V_RGB);
    addrManager inst (reset, clk, H_RGB, V_RGB, addr);
endmodule
