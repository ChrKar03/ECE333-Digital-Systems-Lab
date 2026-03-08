`timescale 1ns / 1ps

// Top module (only instatiations of other modules and wire assignments).
module LED_driver(clk, reset, char_in, en, a, b, c, d, e, f, g, dp, an0, an1, an2, an3, an4, an5, an6, an7);
    input clk, reset;
    input [7:0] en;
    input [31:0] char_in;

    output a, b, c, d, e, f, g, dp;
    output an0, an1, an2, an3, an4, an5, an6, an7;

    wire clk_out;
    wire [3:0] char;
    wire [7:0] LED;

    // The New modulated clock that our circuit runs at.
    MMCM clock_5M (clk, clk_out);

    // The driver for the four 7-segment displays.
    EightDigitLEDdriver driver_mod (reset, clk_out, en, char_in, an7, an6, an5, an4, an3, an2, an1, an0, char);
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
