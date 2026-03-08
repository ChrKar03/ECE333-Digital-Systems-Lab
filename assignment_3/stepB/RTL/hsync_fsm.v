`timescale 1ns / 1ps

module hsync_fsm(input reset, input clk, output reg HSYNC, output reg H_RGB);
    reg [1:0] curState, nxtState;
    reg [11:0] state_cnt;
    
    parameter s_B = 2'b00,
              s_C = 2'b01,
              s_D = 2'b10,
              s_E = 2'b11;

    parameter A_CYCLES = 12'd3200,
              B_CYCLES = 12'd384,
              C_CYCLES = 12'd192,
              D_CYCLES = 12'd2560,
              E_CYCLES = 12'd64;

    always @(posedge clk or posedge reset) begin
        if (reset)
            curState <= s_B;
        else
            curState <= nxtState; 
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_cnt <= 12'h000;
        end else begin
            state_cnt <= state_cnt + 1'b1;
            
            if (state_cnt == A_CYCLES - 1'b1)
                state_cnt <= 12'h000;
        end
    end
    
    always @(curState or state_cnt) begin
        case (curState)
            s_B: begin
                HSYNC = 1'b0;
                H_RGB = 1'b0;
                if (state_cnt == (B_CYCLES - 1'b1))
                    nxtState = s_C;
                else
                    nxtState = s_B;
            end
            s_C: begin
                HSYNC = 1'b1;
                H_RGB = 1'b0;
                if (state_cnt == (B_CYCLES + C_CYCLES - 1'b1))
                    nxtState = s_D;
                else
                    nxtState = s_C;
            end
            s_D: begin
                HSYNC = 1'b1;
                H_RGB = 1'b1;
                if (state_cnt == (B_CYCLES + C_CYCLES + D_CYCLES - 1'b1))
                    nxtState = s_E;
                else
                    nxtState = s_D;
            end
            s_E: begin
                HSYNC = 1'b1;
                H_RGB = 1'b0;
                if (state_cnt == (B_CYCLES + C_CYCLES + D_CYCLES + E_CYCLES - 1'b1))
                    nxtState = s_B;
                else
                    nxtState = s_E;
            end
            default: begin
                HSYNC = 1'b1;
                H_RGB = 1'b0;
                nxtState = s_B;
            end
        endcase
    end
endmodule
