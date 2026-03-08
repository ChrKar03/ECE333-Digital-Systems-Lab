`timescale 1ns / 1ps

module tb_extra;
    reg reset, clk, Tx_WR, Tx_EN, Rx_EN;
    reg [2:0] baud_select;
    reg[7:0] Tx_DATA;

    reg [1:0] addr;
    reg [7:0] msg [3:0];

    wire Tx_BUSY, Rx_FERROR, Rx_PERROR, Rx_VALID;

    reg btn;
    wire a, b, c, d, e, f, g, dp, an0, an1, an2, an3, an4, an5, an6, an7;

    top_module inst (reset, clk, btn, baud_select,
        Tx_DATA, Tx_WR, Tx_EN, Tx_BUSY, Rx_EN, Rx_FERROR, Rx_PERROR,
            Rx_VALID, a, b, c, d, e, f, g, dp, an0, an1, an2, an3, an4, an5, an6, an7);

    initial begin
        reset = 1'b0;
        Tx_WR = 1'b0;
        #10 reset = 1'b1;
        
        btn = 1'b0;
        baud_select = 3'b111;
        Tx_EN = 1'b1;
        Rx_EN = 1'b1;
    
        #1000 reset = 1'b0;
        
        #10 btn = 1'b1;
        #1000 btn = 1'b0;
        #1000 btn = 1'b1;
        #1000 btn = 1'b0;
        #1000 btn = 1'b1;
        #1000 btn = 1'b0;

        #100000 Tx_WR = 1'b1;
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
            end
        end
    end

    always @(posedge Rx_VALID) begin
        if (Rx_VALID) begin
                addr = addr + 1'b1;
            end
    end

    initial begin
        clk <= 1'b0;
        forever #5 clk <= ~clk;
    end
endmodule
