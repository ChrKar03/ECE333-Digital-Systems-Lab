`timescale 1ns / 1ps

 module uart_transmitter(reset, clk, sample_ENABLE, Tx_DATA, Tx_WR, Tx_EN, TxD, Tx_BUSY);
    input reset, clk, Tx_EN, Tx_WR, sample_ENABLE;
    input [7:0] Tx_DATA;
    output reg TxD, Tx_BUSY;
 
    parameter TxIdle = 3'b000,
              TxStart = 3'b001,
              TxSend = 3'b010,
              TxParity = 3'b011,
              TxStop = 3'b100;
 
    parameter StartBit = 1'b0, IdleBit = 1'b1, MAX_CNT = 5'h10;

    reg CHANGE_STATE_FLAG, MSG_END;
    reg [4:0] Tx_Cnt;
    reg [2:0] TxState, NextState, Bit_cnt, state;
 
    wire sample_ENABLE;
 
    // FSM Control Block.
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            TxState <= TxIdle;
        end else begin
            TxState <= NextState;
        end
    end
    
    // CHANGE_STATE_FLAG and MSG_END Control Block.
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Tx_Cnt <= 5'h00;
            Bit_cnt <= 3'b111;
            CHANGE_STATE_FLAG <= 1'b0;
            MSG_END <= 1'b0;
        end else begin
            if (Tx_Cnt == MAX_CNT) begin
                Tx_Cnt <= 5'h00;
            end
            
            CHANGE_STATE_FLAG <= 1'b0;
            MSG_END <= 1'b0;
            if (sample_ENABLE) begin
                // Prepare flag one cycle before.
                if (Tx_Cnt == MAX_CNT - 1'b1) begin
                    CHANGE_STATE_FLAG <= 1'b1;
                end
                
                Tx_Cnt <= Tx_Cnt + 1'b1;
                
                // Increment counter only when we aren't in the Idle State.
                if (state == TxIdle) begin
                    Tx_Cnt <= 5'h00;
                end else if (state == TxSend) begin
                    // One cycle before we check if the message has been 
                    // transmited so we can change to the next state.
                    if (Tx_Cnt == MAX_CNT - 1'b1) begin
                        if (Bit_cnt == 3'b000) begin
                            MSG_END <= 1'b1;
                        end else begin
                            MSG_END <= 1'b0;
                        end
                        
                        Bit_cnt <= Bit_cnt - 1'b1;
                    end
                end else begin
                    Bit_cnt <= 3'b111;
                end
           end
        end
    end

    // Combinational block with default assignments.
    always @(TxState or Tx_EN or Tx_WR or Tx_Cnt or Bit_cnt or Tx_DATA or CHANGE_STATE_FLAG or MSG_END) begin
        NextState = TxState;
        TxD = IdleBit;
        Tx_BUSY = 1'b0;
        
        case (TxState)
            TxIdle: begin
                Tx_BUSY = 1'b0;
                TxD = IdleBit;
                if (Tx_EN && Tx_WR) begin
                    NextState = TxStart;
                    state = TxStart;
                end else begin
                    NextState = TxIdle;
                    state = TxIdle;
                end
            end
            TxStart: begin
                Tx_BUSY = 1'b1;
                TxD = StartBit;
                if (Tx_EN) begin
                    if (CHANGE_STATE_FLAG) begin
                        NextState = TxSend;
                        state = TxSend;
                    end else begin
                        NextState = TxStart;
                        state = TxStart;
                    end
                end else begin
                    NextState = TxIdle;
                    state = TxIdle;
                end
            end
            TxSend: begin
                Tx_BUSY = 1'b1;
                if (Tx_EN) begin
                    if (CHANGE_STATE_FLAG) begin
                        if (MSG_END) begin
                            NextState = TxParity;
                            state = TxParity;
                            TxD = Tx_DATA[0];
                        end else begin
                            NextState = TxSend;
                            state = TxSend;
                            TxD = Tx_DATA[Bit_cnt];
                        end
                    end else begin
                        NextState = TxSend;
                        state = TxSend;
                        TxD = Tx_DATA[Bit_cnt];
                    end
                end else begin
                    NextState = TxIdle;
                    state = TxIdle;
                end
            end
            TxParity: begin
                Tx_BUSY = 1'b1;
                TxD = ^Tx_DATA;  // Parity bit
                if (Tx_EN) begin
                    if (CHANGE_STATE_FLAG) begin
                        NextState = TxStop;
                        state = TxStop;
                    end else begin
                        NextState = TxParity;
                        state = TxParity;
                    end
                end else begin
                    NextState = TxIdle;
                    state = TxIdle;
                end
            end
            TxStop: begin
                Tx_BUSY = 1'b1;
                TxD = IdleBit;
                if (Tx_EN) begin
                    if (CHANGE_STATE_FLAG) begin
                        NextState = TxIdle;
                        state = TxIdle;
                    end else begin
                        NextState = TxStop;
                        state = TxStop;
                    end
                end else begin
                    NextState = TxIdle;
                    state = TxIdle;
                end
            end
            default: begin
                NextState = TxIdle;
                state = TxIdle;
            end
        endcase
    end
 endmodule