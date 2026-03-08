`timescale 1ns / 1ps

// Testbench for partB.
module Testbench;
    // Declarations, Instations.
    wire a, b, c, d, e, f, g, dp;
    reg clk, reset;
    wire an0, an1, an2, an3;

    top_module inst (clk, reset, a, b, c, d, e, f, g, dp, an0, an1, an2, an3);

    // Reset ciruit.
    initial begin
        reset = 1'b0;
        #10 reset = 1'b1;
        #300000 reset = 1'b0;
    end

    // Initiallize clock.
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
endmodule