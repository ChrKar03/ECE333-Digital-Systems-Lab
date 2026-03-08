`timescale 1ns / 1ps

module vsync_fsm(input reset, input clk, output reg VSYNC, output reg V_RGB);
    reg [1:0] curState, nxtState;
    reg [20:0] state_cnt;
    
    parameter s_P = 2'b00,
              s_Q = 2'b01,
              s_R = 2'b10,
              s_S = 2'b11;

    parameter O_CYCLES = 21'd1667200,
              P_CYCLES = 21'd6400,
              Q_CYCLES = 21'd92800,
              R_CYCLES = 21'd1536000,
              S_CYCLES = 21'd32000;

    always @(posedge clk or posedge reset) begin
        if (reset)
            curState <= s_P;
        else
            curState <= nxtState; 
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_cnt <= 21'h000000;
        end else begin
            state_cnt <= state_cnt + 1'b1;
            
            if (state_cnt == O_CYCLES - 1'b1)
                state_cnt <= 21'h000000;
        end
    end
    
    always @(curState or state_cnt) begin
        case (curState)
            s_P: begin
                VSYNC = 1'b0;
                V_RGB = 1'b0;
                nxtState = s_P;
                if (state_cnt == (P_CYCLES - 1'b1))
                    nxtState = s_Q;
                else
                    nxtState = s_P;
            end
            s_Q: begin
                VSYNC = 1'b1;
                V_RGB = 1'b0;
                if (state_cnt == ((P_CYCLES + Q_CYCLES) - 1'b1))
                    nxtState = s_R;
                else
                    nxtState = s_Q;
            end
            s_R: begin
                VSYNC = 1'b1;
                V_RGB = 1'b1;            
                if (state_cnt == ((P_CYCLES + Q_CYCLES + R_CYCLES) - 1'b1))
                    nxtState = s_S;
                else
                    nxtState = s_R;
            end
            s_S: begin
                VSYNC = 1'b1;
                V_RGB = 1'b0;            
                if (state_cnt == ((P_CYCLES + Q_CYCLES + R_CYCLES + S_CYCLES) - 1'b1))
                    nxtState = s_P;
                else
                    nxtState = s_S;
            end
            default: begin
                VSYNC = 1'b1;
                V_RGB = 1'b0;
                nxtState = s_P;
            end
        endcase
    end
endmodule
