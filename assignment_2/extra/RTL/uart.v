`timescale 1ns / 1ps

module UART(reset, clk, baud_select, Tx_DATA, Tx_WR, Tx_EN, TxD, 
            Tx_BUSY, Rx_DATA, Rx_EN, RxD, Rx_FERROR, Rx_PERROR, Rx_VALID);
    input reset, clk, Rx_EN, RxD, Tx_EN, Tx_WR, Rx_EN;
    input [2:0] baud_select;
    input [7:0] Tx_DATA;

    output [7:0] Rx_DATA;
    output Rx_FERROR, Rx_PERROR, Rx_VALID;
    output TxD, Tx_BUSY;

    wire sample_ENABLE;

    baud_controller baud_inst (reset, clk, baud_select, sample_ENABLE);
    
    uart_transmitter trans (reset, clk, sample_ENABLE, Tx_DATA, Tx_WR, Tx_EN, TxD, Tx_BUSY);
    uart_receiver recv (reset, clk, sample_ENABLE, Rx_DATA, Rx_EN, RxD, Rx_FERROR, Rx_PERROR, Rx_VALID);
endmodule
