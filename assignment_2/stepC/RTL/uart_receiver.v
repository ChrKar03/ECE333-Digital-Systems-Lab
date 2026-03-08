`timescale 1ns / 1ps

module uart_receiver (reset, clk, sample_ENABLE, Rx_DATA, Rx_EN, RxD, Rx_FERROR, Rx_PERROR, Rx_VALID);
    input reset, clk, Rx_EN, RxD, sample_ENABLE;
    output reg [7:0] Rx_DATA;
    output reg Rx_FERROR;
    output reg Rx_PERROR;
    output reg Rx_VALID;

    parameter RxIdle = 3'b000,
              RxStart = 3'b001,
              RxSample = 3'b010,
              RxParity = 3'b011,
              RxStop = 3'b100;
    
    parameter SMP_START = 4'h4, SMP_END = 4'hb, SMP_MAX = 5'h10;
    
    reg smp_check, CHANGE_STATE_FLAG, MSG_END, ERROR_FLAG;
    reg [2:0] RxState, NextState, Bit_cnt, state;
    reg [4:0] smp_cnt;
    reg [7:0] Rx_Msg;
    
    wire sample_ENABLE;
    
    // FSM control block.
    always @(posedge clk or posedge reset) begin
        if (reset)
            RxState <= RxIdle;
        else
            RxState <= NextState;
    end
    
    // CHANGE_STATE_FLAG and MSG_END Control Block.
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            smp_cnt <= 5'h00;
            smp_check <= 1'b0;
            Bit_cnt <= 3'b111;
            CHANGE_STATE_FLAG <= 1'b0;
            MSG_END <= 1'b0;
            ERROR_FLAG <= 1'b0;
            Rx_Msg <= {8{1'b0}};
            Rx_DATA <= {8{1'b1}};
        end else begin
            MSG_END <= 1'b0;
            CHANGE_STATE_FLAG <= 1'b0;
            ERROR_FLAG <= 1'b0;
            if (smp_cnt == SMP_MAX)
                smp_cnt <= 5'h00;
            
            if (sample_ENABLE) begin
                if (smp_cnt == SMP_MAX - 1'b1)
                    CHANGE_STATE_FLAG <= 1'b1;

                smp_cnt <= smp_cnt + 1'b1;
                
                if (state == RxIdle) begin
                    smp_cnt <= 5'h00;
                end else if (smp_cnt == SMP_MAX - 1'b1 && state == RxSample) begin
                    if (Bit_cnt == 3'b000) begin
                        Rx_Msg[Bit_cnt] <= smp_check;
                        MSG_END <= 1'b1;
                    end else begin
                        Rx_Msg[Bit_cnt] <= smp_check;
                    end
                    Bit_cnt <= Bit_cnt - 1'b1;
                end else begin
                    if (smp_cnt >= SMP_START && smp_cnt <= SMP_END && state != RxParity)
                        smp_check <= RxD;

                    if(state == RxParity)
                        smp_check <= ^Rx_Msg;

                    if (smp_cnt > SMP_START && smp_cnt < SMP_END && smp_check ^ RxD)
                        ERROR_FLAG <= 1'b1;
                    
                    if (state == RxStop)
                        Rx_DATA = Rx_Msg;
               end
            end
        end
    end
    
    // Combinational block with default assignments.
    always @(RxState or Rx_Msg or smp_cnt or Bit_cnt or CHANGE_STATE_FLAG or MSG_END or ERROR_FLAG or RxD or Rx_EN or smp_check) begin
        Rx_FERROR = 1'b0;
        Rx_PERROR = 1'b0;
        Rx_VALID = 1'b0;
        case (RxState)
            RxIdle: begin
                Rx_DATA = Rx_DATA;
                if (Rx_EN && ~RxD) begin
                    NextState = RxStart;
                    state = RxStart;
                end else begin
                    NextState = RxIdle;
                    state = RxIdle;
                end
            end
            RxStart: begin
                Rx_DATA = Rx_DATA;
                if (Rx_EN) begin
                    if (CHANGE_STATE_FLAG) begin
                        NextState = RxSample;
                        state = RxSample;
                    end else if (smp_cnt >= SMP_START || smp_cnt <= SMP_END) begin
                        if (ERROR_FLAG) begin
                            NextState = RxIdle;
                            state = RxIdle;
                            Rx_FERROR = 1'b1;
                        end else begin
                            NextState = RxStart;
                            state = RxStart;
                        end
                    end else begin
                        NextState = RxStart;
                        state = RxIdle;
                    end
                end else begin
                    NextState = RxIdle;
                    state = RxIdle;
                end
            end
            RxSample: begin
                Rx_DATA = Rx_DATA;
                if (Rx_EN) begin
                    if (CHANGE_STATE_FLAG) begin
                        if (MSG_END) begin
                            NextState = RxParity;
                            state = RxParity;
                        end else begin
                            NextState = RxSample;
                            state = RxSample;
                        end
                    end else if (smp_cnt >= SMP_START || smp_cnt <= SMP_END) begin
                        if (ERROR_FLAG) begin
                            NextState = RxIdle;
                            state = RxIdle;
                            Rx_FERROR = 1'b1;
                        end else begin
                            NextState = RxSample;
                            state = RxSample;
                        end
                    end else begin
                        NextState = RxSample;
                        state = RxSample;
                    end
                end else begin
                    NextState = RxIdle;
                    state = RxIdle;
                end
            end
            RxParity: begin
                Rx_DATA = Rx_DATA;
                if (Rx_EN) begin
                    if (CHANGE_STATE_FLAG) begin
                        NextState = RxStop;
                        state = RxStop;
                    end else if (smp_cnt >= SMP_START || smp_cnt <= SMP_END) begin
                        if (ERROR_FLAG) begin
                            NextState = RxIdle;
                            state = RxIdle;
                            Rx_PERROR = 1'b1;
                        end else begin
                            NextState = RxParity;
                            state = RxParity;
                        end
                    end else begin
                        NextState = RxParity;
                        state = RxParity;
                    end
                end else begin
                    NextState = RxIdle;
                    state = RxIdle;
                end
            end
            RxStop: begin
                Rx_DATA = Rx_DATA;
                if (Rx_EN) begin
                    Rx_VALID = 1'b1;
                    if (CHANGE_STATE_FLAG) begin
                        NextState = RxIdle;
                        state = RxIdle;
                    end else begin
                        NextState = RxStop;
                        state = RxStop;
                    end
                end else begin
                    NextState = RxIdle;
                    state = RxIdle;
                end
            end
            default: begin
                NextState = RxIdle;
                state = RxIdle;
            end
        endcase
    end
endmodule