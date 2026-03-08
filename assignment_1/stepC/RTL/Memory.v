`timescale 1ns / 1ps

// Memory module with message stored and keeps track of the characters to be shown.
module Memory (clk, rst, btn, D_out0, D_out1, D_out2, D_out3);
    input clk, rst, btn;
    output reg [3:0] D_out0, D_out1, D_out2, D_out3;

    reg btn_prv;
    reg [3:0] addr;
    reg [3:0] mem [0:15];

    always @ (posedge clk or posedge rst) begin
        // Set memory and counter.
        if (rst) begin
            mem[0] <= 4'h0;
            mem[1] <= 4'h1;
            mem[2] <= 4'h2;
            mem[3] <= 4'h3;
            mem[4] <= 4'h4;
            mem[5] <= 4'h5;
            mem[6] <= 4'h6;
            mem[7] <= 4'h7;
            mem[8] <= 4'h8;
            mem[9] <= 4'h9;
            mem[10] <= 4'hA;
            mem[11] <= 4'hB;
            mem[12] <= 4'hC;
            mem[13] <= 4'hD;
            mem[14] <= 4'hE;
            mem[15] <= 4'hF;
            
            D_out0 <= 4'b1111;
            D_out1 <= 4'b1111;
            D_out2 <= 4'b1111;
            D_out3 <= 4'b1111;
            
            btn_prv <= 1'b0;
            addr <= 4'b0000;
        // If the button is pressed, move each 
        // character one possition and increace counter.
        // If a cycle has passed and button is still pressed
        // Disable the counter increase function.
        end else if (btn && !btn_prv) begin
            addr <= addr + 1'b1;
            btn_prv <= btn;

            D_out0 <= D_out1;
            D_out1 <= D_out2;
            D_out2 <= D_out3;
            D_out3 <= mem[addr];
        end else begin
            // Update btn_prv.
            btn_prv <= btn;
        end
    end
endmodule