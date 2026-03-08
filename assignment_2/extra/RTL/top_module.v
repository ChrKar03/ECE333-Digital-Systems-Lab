`timescale 1ns / 1ps

module top_module(reset, clk, btn, baud_select,
    Tx_DATA, Tx_WR, Tx_EN, Tx_BUSY, Rx_EN, UART_FERROR,
    UART_PERROR, UART_VALID, a, b, c, d, e, f, g, dp, an0, an1, an2, an3, an4, an5, an6, an7);
            
    input clk, reset, Rx_EN, Tx_EN, Tx_WR, btn;
    input [2:0] baud_select;
    input [7:0] Tx_DATA;

    output a, b, c, d, e, f, g, dp, an0, an1, an2, an3, 
        an4, an5, an6, an7, UART_VALID, UART_FERROR, UART_PERROR, Tx_BUSY;

    reg btn_prv, CHANGE_STATE_FLAG;
    reg [1:0] Cur_state, Nextstate;
    reg [7:0] anode_en;
    reg [31:0] led_chars;

    wire sample_ENABLE, Rx_FERROR, Rx_PERROR, Rx_VALID, TxD, clk_out, db_out_rst, db_out_btn, db_out_Tx_EN, db_out_Tx_WR, db_out_Rx_EN, sync_tmp_rst, sync_out_rst,
    sync_tmp_btn, sync_out_btn, sync_tmp_Tx_EN, sync_out_Tx_EN, sync_tmp_Tx_WR, sync_out_Tx_WR, sync_tmp_Rx_EN, sync_out_Rx_EN,
    sync_tmp, sync_out, sync_tmp1, sync_out1, sync_tmp2, sync_out2, sync_tmp3, sync_out3, sync_tmp4, sync_out4, sync_tmp5, sync_out5,
    sync_tmp6, sync_out6,sync_tmp7, sync_out7, sync_tmp8, sync_out8, sync_tmp9, sync_out9, sync_tmp10, sync_out10;

    wire [2:0] db_baud_select;
    wire [3:0] char;
    wire [7:0] LED, db_Tx_DATA, Rx_DATA;
    
    parameter s_IDLE = 2'b00,
              s_BS = 2'b01,
              s_MSG = 2'b10,
              s_RUN = 2'b11;
    
    // Synchronizer and de-bounce reset.
    Synchronizer sync_rst (clk, reset, sync_tmp_rst, sync_out_rst);
    Debounce db_rst (clk, sync_out_rst, sync_tmp_rst, db_out_rst);
    
    // Synchronizer and de-bounce btn.
    Synchronizer sync_btn (clk, btn, sync_tmp_btn, sync_out_btn);
    Debounce db_btn (clk, sync_out_btn, sync_tmp_btn, db_out_btn);
    
    // Synchronizer and de-bounce Tx_EN.
    Synchronizer sync_Tx_EN (clk, Tx_EN, sync_tmp_Tx_EN, sync_out_Tx_EN);
    Debounce db_Tx_EN (clk, sync_out_Tx_EN, sync_tmp_Tx_EN, db_out_Tx_EN);
    
    // Synchronizer and de-bounce Tx_WR.
    Synchronizer sync_Tx_WR (clk, Tx_WR, sync_tmp_Tx_WR, sync_out_Tx_WR);
    Debounce db_Tx_WR (clk, sync_out_Tx_WR, sync_tmp_Tx_WR, db_out_Tx_WR);
    
    // Synchronizer and de-bounce Rx_EN.
    Synchronizer sync_Rx_EN (clk, Rx_EN, sync_tmp_Rx_EN, sync_out_Rx_EN);
    Debounce db_Rx_EN (clk, sync_out_Rx_EN, sync_tmp_Rx_EN, db_out_Rx_EN);
    
    // Synchronizer and de-bounce baud_select[0].
    Synchronizer sync_bs_0 (clk, baud_select[0], sync_tmp, sync_out);
    Debounce db_bs_0 (clk, sync_out, sync_tmp, db_baud_select[0]);    
    
    // Synchronizer and de-bounce baud_select[1].
    Synchronizer sync_bs_1 (clk, baud_select[1], sync_tmp1, sync_out1);
    Debounce db_bs_1 (clk, sync_out1, sync_tmp1, db_baud_select[1]);
    
    // Synchronizer and de-bounce baud_select[2].
    Synchronizer sync_bs_2 (clk, baud_select[2], sync_tmp2, sync_out2);
    Debounce db_bs_2 (clk, sync_out2, sync_tmp2, db_baud_select[2]);

    // Synchronizer and de-bounce Tx_DATA[0].
    Synchronizer sync_TxDATA_0 (clk, Tx_DATA[0], sync_tmp3, sync_out3);
    Debounce db_TxDATA_0 (clk, sync_out3, sync_tmp3, db_Tx_DATA[0]);
    
    // Synchronizer and de-bounce Tx_DATA[1].
    Synchronizer sync_TxDATA_1 (clk, Tx_DATA[1], sync_tmp4, sync_out4);
    Debounce db_TxDATA_1 (clk, sync_out4, sync_tmp4, db_Tx_DATA[1]);
    
    // Synchronizer and de-bounce Tx_DATA[2].
    Synchronizer sync_TxDATA_2 (clk, Tx_DATA[2], sync_tmp5, sync_out5);
    Debounce db_TxDATA_2 (clk, sync_out5, sync_tmp5, db_Tx_DATA[2]);    
    
    // Synchronizer and de-bounce Tx_DATA[3].
    Synchronizer sync_TxDATA_3 (clk, Tx_DATA[3], sync_tmp6, sync_out6);
    Debounce db_TxDATA_3 (clk, sync_out6, sync_tmp6, db_Tx_DATA[3]);    
    
    // Synchronizer and de-bounce Tx_DATA[4].
    Synchronizer sync_TxDATA_4 (clk, Tx_DATA[4], sync_tmp7, sync_out7);
    Debounce db_TxDATA_4 (clk, sync_out7, sync_tmp7, db_Tx_DATA[4]);    
    
    // Synchronizer and de-bounce Tx_DATA[5].
    Synchronizer sync_TxDATA_5 (clk, Tx_DATA[5], sync_tmp8, sync_out8);
    Debounce db_TxDATA_5 (clk, sync_out8, sync_tmp8, db_Tx_DATA[5]);

    // Synchronizer and de-bounce Tx_DATA[6].
    Synchronizer sync_TxDATA_6 (clk, Tx_DATA[6], sync_tmp9, sync_out9);
    Debounce db_TxDATA_6 (clk, sync_out9, sync_tmp9, db_Tx_DATA[6]);
   
    // Synchronizer and de-bounce Tx_DATA[7].
    Synchronizer sync_TxDATA_7 (clk, Tx_DATA[7], sync_tmp10, sync_out10);
    Debounce db_TxDATA_7 (clk, sync_out10, sync_tmp10, db_Tx_DATA[7]);
    
    UART top (db_out_rst, clk, db_baud_select, db_Tx_DATA, db_out_Tx_WR, db_out_Tx_EN, TxD, 
            Tx_BUSY, Rx_DATA, db_out_Rx_EN, TxD, Rx_FERROR, Rx_PERROR, Rx_VALID);
            
    LED_driver led (clk, db_out_rst, led_chars, anode_en, a, b, c, d, e, f, g, dp, an0, an1, an2, an3, an4, an5, an6, an7);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Cur_state <= s_IDLE;
        end else begin
            Cur_state <= Nextstate;
        end
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            CHANGE_STATE_FLAG <= 1'b0;
            btn_prv <= 1'b0;
        end else if (db_out_btn && !btn_prv) begin
            CHANGE_STATE_FLAG <= 1'b1;
            btn_prv <= 1'b1;
        end else begin
            CHANGE_STATE_FLAG <= 1'b0;
            btn_prv <= db_out_btn;
        end
    end

    always @(Cur_state or CHANGE_STATE_FLAG or db_baud_select or db_Tx_DATA or db_out_Tx_WR or db_out_Tx_EN or db_out_Rx_EN or Rx_DATA) begin
        anode_en = 8'hFF;
        led_chars = 32'h12345678;
        case (Cur_state)
            s_IDLE: begin
                anode_en = 8'hFF;
                led_chars = 32'h12345678;
                Nextstate = CHANGE_STATE_FLAG ? s_BS : s_IDLE;
            end
            s_BS: begin
                case (db_baud_select)
                    3'b000: {anode_en, led_chars} = {8'h07, 32'h00000300};
                    3'b001: {anode_en, led_chars} = {8'h0F, 32'h00001200};
                    3'b010: {anode_en, led_chars} = {8'h0F, 32'h00004800};
                    3'b011: {anode_en, led_chars} = {8'h0F, 32'h00009600};
                    3'b100: {anode_en, led_chars} = {8'h1F, 32'h00019200};
                    3'b101: {anode_en, led_chars} = {8'h1F, 32'h00038400};
                    3'b110: {anode_en, led_chars} = {8'h1F, 32'h00057600};
                    3'b111: {anode_en, led_chars} = {8'h3F, 32'h00115200};
                    default: {anode_en, led_chars} = {8'hFF, 32'h12345678};
                endcase
                Nextstate = CHANGE_STATE_FLAG ? s_MSG : s_BS;
            end
            s_MSG: begin
                anode_en = 8'h03;
                led_chars = {24'h000000, db_Tx_DATA};
                Nextstate = CHANGE_STATE_FLAG ? s_RUN : s_MSG;
            end
            s_RUN: begin
                anode_en = 8'h03;
                led_chars = {24'h000000, Rx_DATA};
                Nextstate = CHANGE_STATE_FLAG ? s_IDLE : s_RUN;
            end
            default: begin
                Nextstate = s_IDLE;
            end
        endcase
    end
    
    assign UART_VALID = Rx_VALID;
    assign UART_FERROR = Rx_FERROR;
    assign UART_PERROR = Rx_PERROR;
endmodule
