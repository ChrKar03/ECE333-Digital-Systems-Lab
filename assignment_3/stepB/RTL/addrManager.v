`timescale 1ns / 1ps

module addrManager(input reset, input clk, input RGB, output [13:0] addr);
    reg [4:0] cnt;
    reg [6:0] HPIXEL, VPIXEL;
    
    parameter LINE_CYCLE = 5'd20;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            HPIXEL <= 7'h00;
            VPIXEL <= 7'h00;
            cnt <= 5'h00;
        end else begin
            if (RGB) begin
                if (cnt == LINE_CYCLE - 1'b1) begin
                    if (HPIXEL == 7'hFF)
                        HPIXEL <= 7'h00;
                    else
                        HPIXEL <= HPIXEL + 1'b1;
                    cnt <= 5'h00;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end else begin
                cnt <= 5'h00;
                HPIXEL <= 7'h00;
            end
        end
    end
    
    assign addr = {VPIXEL, HPIXEL};
endmodule
