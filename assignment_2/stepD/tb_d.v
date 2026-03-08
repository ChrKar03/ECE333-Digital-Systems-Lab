`timescale 1ns / 1ps

module tb_d;
    reg reset, clk, Tx_WR, Tx_EN, Rx_EN;
    reg [2:0] baud_select;
    reg[7:0] Tx_DATA;

    reg [1:0] addr;
    reg [7:0] msg [3:0];

    wire [7:0] Rx_DATA;
    wire TxD, Tx_BUSY, Rx_FERROR, Rx_PERROR, Rx_VALID, RxD;

    reg Tx_WR2, Tx_EN2, Rx_EN2;
    reg[7:0] Tx_DATA2;
    wire [7:0] Rx_DATA2;
    wire TxD2, Tx_BUSY2, Rx_FERROR2, Rx_PERROR2, Rx_VALID2;
    
    UART inst (reset, clk, baud_select, Tx_DATA, Tx_WR, Tx_EN, TxD, Tx_BUSY, Rx_DATA, Rx_EN, RxD, Rx_FERROR, Rx_PERROR, Rx_VALID);
    UART inst2 (reset, clk, baud_select, Tx_DATA2, Tx_WR2, Tx_EN2, TxD2, Tx_BUSY2, Rx_DATA2, Rx_EN2, TxD, Rx_FERROR2, Rx_PERROR2, Rx_VALID2);

    initial begin
        reset = 1'b0;
        Tx_WR = 1'b0;
        #10 reset = 1'b1;
        
        baud_select = 3'b111;
        Tx_EN = 1'b1;
        Rx_EN2 = 1'b1;
    
        #200 reset = 1'b0;
        #10 Tx_WR = 1'b1;
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            addr = 2'b00;
            msg[0] = 8'haa;
            msg[1] = 8'h55;
            msg[2] = 8'hCC;
            msg[3] = 8'h89;
        end else begin
            if (!Tx_BUSY) begin
                Tx_DATA = msg[addr];
                #10 Tx_WR = ~Tx_WR;
            end
        end
    end

    always @(posedge Rx_VALID2) begin
        if (Rx_VALID2) begin
            addr = addr + 1'b1;
            #10 Tx_WR = ~Tx_WR;
            end
    end

    initial begin
        clk <= 1'b0;
        forever #5 clk <= ~clk;
    end
endmodule
