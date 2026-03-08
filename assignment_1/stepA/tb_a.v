`timescale 1ns / 1ps

module Testbench;
    reg [3:0] in;
    wire [7:0] out;

    LEDdecoder Led_inst (in, out);
    
    initial begin
        // Initialize input
        in = 4'b0000;
        
        #10 in = in + 4'b0001;
        #10 in = in + 4'b0001;
        #10 in = in + 4'b0001;
        #10 in = in + 4'b0001;
        #10 in = in + 4'b0001;
        #10 in = in + 4'b0001;
        #10 in = in + 4'b0001;
        #10 in = in + 4'b0001;
        #10 in = in + 4'b0001;
        #10 in = in + 4'b0001;
        #10 in = in + 4'b0001;
        #10 in = in + 4'b0001;
        #10 in = in + 4'b0001;
        #10 in = in + 4'b0001;
        #10 in = in + 4'b0001;
        #10 in = in + 4'b0001;
    end
endmodule
