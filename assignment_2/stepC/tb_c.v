`timescale 1ns / 1ps

module tb_c;
    reg reset, clk, Rx_EN, RxD;
    wire Rx_FERROR, Rx_PERROR, Rx_VALID;
    wire [7:0] Rx_DATA;
    reg [2:0] baud_select;

    reg [10:0] MSG_V, MSG_F, MSG_P;

    integer i = 10, cnt, testNum = 1;

    top_module top_inst (reset, clk, Rx_DATA, baud_select, Rx_EN, RxD, Rx_FERROR, Rx_PERROR, Rx_VALID);

    initial begin
        reset <= 1'b0;
        
        MSG_V <= 11'h2a9;
        MSG_P <= 11'h2ab;
        MSG_F <= 11'h2a9;
        #10 reset <= 1'b1;
        
        baud_select <= 3'b111;
        Rx_EN <= 1'b1;
        RxD <= 1'b0;
        
        #200 reset = 1'b0;
        cnt = 0;
        #200000 $finish;
    end
    
    always @(posedge top_module.recv_inst.sample_ENABLE) begin
        cnt = cnt + 1;
        // VALID CASE
        if (testNum == 1) begin
            if (cnt == 16) begin
                #20 RxD <= MSG_V[i - 1];
                i = i - 1;
                cnt = 0;
                if (i == 32'hFFFFFFFF) begin
                    i = 10;
                    RxD <= 1'b1;
                    #300 testNum = testNum + 1;
                end
            end
        end
        // PARITY ERROR
        else if (testNum == 2) begin
            if (cnt == 16) begin
                #20 RxD <= MSG_P[i];
                i = i - 1;
                cnt = 0;
                if (i == 32'hFFFFFFFF) begin
                    i = 10;
                    RxD <= 1'b1;
                    #300 testNum = testNum + 1;
                end
            end
        end
        // FRAME ERROR
        else begin
                RxD <= ~RxD;
        end
    end
    
    initial begin
        clk <= 1'b0;
        forever #5 clk <= ~clk;
    end
endmodule