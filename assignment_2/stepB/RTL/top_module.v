`timescale 1ns / 1ps

module top_module (reset, clk, Tx_DATA, baud_select, Tx_WR, Tx_EN, TxD, Tx_BUSY);
    input reset, clk, Tx_WR, Tx_EN;
    input [7:0] Tx_DATA;
    input [2:0] baud_select;
    output TxD, Tx_BUSY;
    
    wire sample_ENABLE;
    
    baud_controller bd_inst (reset, clk, baud_select, sample_ENABLE);
    uart_transmitter uart_trans_inst (reset, clk, sample_ENABLE, Tx_DATA, Tx_WR, Tx_EN, TxD, Tx_BUSY);
endmodule
