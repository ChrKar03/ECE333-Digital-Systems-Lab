`timescale 1ns / 1ps

module tb_b;
    reg reset, clk, Tx_WR, Tx_EN;
    reg [2:0] baud_select;
    reg [7:0] Tx_DATA;
    wire TxD, Tx_BUSY;
    
    top_module inst (reset, clk, Tx_DATA, baud_select, Tx_WR, Tx_EN, TxD, Tx_BUSY);
    
    initial begin
        reset <= 1'b0;
        #10 reset <= 1'b1;
        
        baud_select <= 3'b111;
        Tx_DATA <= 8'b10101010;
        Tx_WR <= 1'b1;
        Tx_EN <= 1'b1;
        
        #200 reset <= 1'b0;
        
        #10 Tx_WR <= 1'b0;
        
        #179780 $finish;
    end
    
    initial begin
        clk <= 1'b0;
        forever #5 clk <= ~clk;
    end
endmodule
