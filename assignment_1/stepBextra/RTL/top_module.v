`timescale 1ns / 1ps

module top_module(clk, reset, a, b, c, d, e, f, g, dp, an0, an1, an2, an3);
    input clk, reset;
    output a, b, c, d, e, f, g, dp;
    output an0, an1, an2, an3;
    wire clk_tmp, clk_out, db_out, sync_tmp, sync_out;
    wire [3:0] char;
    wire [7:0] LED;
    
    MMCM clk_5MHz (clk, clk_out);

    // Synchronizer and de-bounce mechanisms.
    Synchronizer sync_mod (clk, reset, sync_tmp, sync_out);
    Debounce debounce_mod (clk, sync_out, sync_tmp, db_out);

    // The driver for the four 7-segment displays.
    FourDigitLEDdriver driver_mod (db_out, clk_out, an3, an2, an1, an0, char);
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