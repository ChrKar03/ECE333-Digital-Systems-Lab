`timescale 1ns / 1ps

module top_module (reset, clk, Rx_DATA, baud_select, Rx_EN, RxD, Rx_FERROR, Rx_PERROR, Rx_VALID);
    input reset, clk;
    input [2:0] baud_select;
    input Rx_EN;
    input RxD;
    output [7:0] Rx_DATA;
    output Rx_FERROR; // Framing Error //
    output Rx_PERROR; // Parity Error //
    output Rx_VALID; // Rx_DATA is Valid //

    wire sample_ENABLE;
    
    baud_controller bd_inst (reset, clk, baud_select, sample_ENABLE);
    uart_receiver recv_inst (reset, clk, sample_ENABLE, Rx_DATA, Rx_EN, RxD, Rx_FERROR, Rx_PERROR, Rx_VALID);
endmodule