`timescale 1ns / 1ps

// The eight 7-segment display driver that controls the anodes and which character will be displayed.
module EightDigitLEDdriver(
    input reset, 
    input clk, 
    input [7:0] en, 
    input [31:0] msg, 
    output reg an7, an6, an5, an4, an3, an2, an1, an0, 
    output reg [3:0] char
);

    reg [4:0] cnt;

    parameter Prepare0 = 5'h00,
              Enable0 = 5'h02,
              Prepare1 = 5'h04,
              Enable1 = 5'h06,
              Prepare2 = 5'h08,
              Enable2 = 5'h0a,
              Prepare3 = 5'h0c,
              Enable3 = 5'h0e,
              Prepare4 = 5'h10,
              Enable4 = 5'h12,
              Prepare5 = 5'h14,
              Enable5 = 5'h16,
              Prepare6 = 5'h18,
              Enable6 = 5'h1a,
              Prepare7 = 5'h1c,
              Enable7 = 5'h1e;

    // Sequential block for cnt, which increments on every clock pulse or resets
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            cnt <= 5'h1F;
            an0 = 1'b1;
            an1 = 1'b1;
            an2 = 1'b1;
            an3 = 1'b1;
            an4 = 1'b1;
            an5 = 1'b1;
            an6 = 1'b1;
            an7 = 1'b1;
            char = 4'b0000;
        end else begin
            case (cnt)
                Prepare0: char = msg[3:0];
                Enable0: an0 = en[0] ? 1'b0 : 1'b1;
                Prepare1: char = msg[7:4];
                Enable1: an1 = en[1] ? 1'b0 : 1'b1;
                Prepare2: char = msg[11:8];
                Enable2: an2 = en[2] ? 1'b0 : 1'b1;
                Prepare3: char = msg[15:12];
                Enable3: an3 = en[3] ? 1'b0 : 1'b1;
                Prepare4: char = msg[19:16];
                Enable4: an4 = en[4] ? 1'b0 : 1'b1;
                Prepare5: char = msg[23:20];
                Enable5: an5 = en[5] ? 1'b0 : 1'b1;
                Prepare6: char = msg[27:24];
                Enable6: an6 = en[6] ? 1'b0 : 1'b1;
                Prepare7: char = msg[31:28];
                Enable7: an7 = en[7] ? 1'b0 : 1'b1;
                default: begin
                    an0 = 1'b1;
                    an1 = 1'b1;
                    an2 = 1'b1;
                    an3 = 1'b1;
                    an4 = 1'b1;
                    an5 = 1'b1;
                    an6 = 1'b1;
                    an7 = 1'b1;
                end
            endcase
            cnt <= cnt + 1'b1;
        end
    end
endmodule
