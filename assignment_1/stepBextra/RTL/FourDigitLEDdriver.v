`timescale 1ns / 1ps

// The four 7-segmant displays driver that controls the anodes and which character will be displayed.
module FourDigitLEDdriver(reset, clk, an3, an2, an1, an0, char);
    input reset, clk;
    output reg an3, an2, an1, an0;
    output reg [3:0] char;

    reg [3:0] cnt;
    wire [3:0] char0 = 4'b0000;
    wire [3:0] char1 = 4'b0001;
    wire [3:0] char2 = 4'b0010;
    wire [3:0] char3 = 4'b0011;

    // The module works like an FSM.
    always @ (posedge clk or posedge reset) begin
        // Reset.
        if (reset) begin
            an0 <= 1'b1;
            an1 <= 1'b1;
            an2 <= 1'b1;
            an3 <= 1'b1;
            char <= 4'b1111;
            cnt <= 4'b1111;
        end
        else begin
            case (cnt)
                // Enabling anode 3.
                4'b1110: begin
                    an3 <= 1'b0;
                    an2 <= 1'b1;
                    an1 <= 1'b1;
                    an0 <= 1'b1;
                end
                // Enabling anode 2.
                4'b1010: begin
                    an3 <= 1'b1;
                    an2 <= 1'b0;
                    an1 <= 1'b1;
                    an0 <= 1'b1;
                end
                // Enabling anode 1.
                4'b0110: begin
                    an3 <= 1'b1;
                    an2 <= 1'b1;
                    an1 <= 1'b0;
                    an0 <= 1'b1;
                end
                // Enabling anode 0.
                4'b0010: begin
                    an3 <= 1'b1;
                    an2 <= 1'b1;
                    an1 <= 1'b1;
                    an0 <= 1'b0;
                end
                // Prepare first character.
                4'b0000: begin
                    char <= char0;
                    an3 <= 1'b1;
                    an2 <= 1'b1;
                    an1 <= 1'b1;
                    an0 <= 1'b1;
                end
                // Prepare second character.
                4'b0100: begin
                    char <= char1;
                    an3 <= 1'b1;
                    an2 <= 1'b1;
                    an1 <= 1'b1;
                    an0 <= 1'b1;
                end
                // Prepare third character.
                4'b1000: begin
                    char <= char2;
                    an3 <= 1'b1;
                    an2 <= 1'b1;
                    an1 <= 1'b1;
                    an0 <= 1'b1;
                end
                // Prepare fourth character.
                4'b1100: begin
                    char <= char3;
                    an3 <= 1'b1;
                    an2 <= 1'b1;
                    an1 <= 1'b1;
                    an0 <= 1'b1;
                end
                // Disable all anodes.
                default: begin
                    an3 <= 1'b1;
                    an2 <= 1'b1;
                    an1 <= 1'b1;
                    an0 <= 1'b1;
                end
            endcase
            // Increase counter for next state.
            cnt <= cnt + 1'b1;
        end
    end
endmodule
