`timescale 1ns / 1ps

// Top module (only instatiations of modules and wire assignments).
module top_module(clk, reset, a, b, c, d, e, f, g, dp, an0, an1, an2, an3);
    input clk, reset;
    output a, b, c, d, e, f, g, dp;
    output an0, an1, an2, an3;
    
    wire [3:0] char;
    wire [7:0] LED;
    wire clk_out, db_out_rst, sync_tmp_rst, sync_out_rst;

    // The New modulated clock that our circuit runs at.
    MMCM clock_5M (clk, clk_out);

    // Synchronizer and de-bounce mechanisms for reset signal.
    Synchronizer sync_mod_rst (clk_out, reset, sync_tmp_rst, sync_out_rst);
    Debounce debounce_mod_rst (clk_out, sync_out_rst, sync_tmp_rst, db_out_rst);

    // The driver for the four 7-segment displays.
    FourDigitLEDdriver driver_mod (db_out_rst, clk_out, an3, an2, an1, an0, char);

    // The decoder of the character that is selected by the driver.
    LEDdecoder decoder_mod (char, LED);
  
    // Wire assignments for the 7-segment displays.  
    assign a = LED[7];
    assign b = LED[6];
    assign c = LED[5];
    assign d = LED[4];
    assign e = LED[3];
    assign f = LED[2];
    assign g = LED[1];
    assign dp = LED[0];
endmodule
