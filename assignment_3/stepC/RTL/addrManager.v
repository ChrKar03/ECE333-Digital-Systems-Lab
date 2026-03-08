`timescale 1ns / 1ps

module addrManager(input reset, input clk, input H_RGB, input V_RGB, output [13:0] addr);
    reg [4:0] H_cnt;
    reg [13:0] V_cnt;
    reg [6:0] HPIXEL, VPIXEL;
    
    parameter H_LINE_CYCLE = 5'd20,
              V_LINE_CYCLE = 14'd16000;

    // HPIXEL Control Block.
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            HPIXEL <= 7'h00;
            H_cnt <= 5'h00;
        end else begin
            if (H_RGB) begin
                if (H_cnt == H_LINE_CYCLE - 1'b1) begin
                    if (HPIXEL == 7'hFF)
                        HPIXEL <= 7'h00;
                    else
                        HPIXEL <= HPIXEL + 1'b1;
                    H_cnt <= 5'h00;
                end else begin
                    H_cnt <= H_cnt + 1'b1;
                end
            end else begin
                H_cnt <= 5'h00;
                HPIXEL <= 7'h00;
            end
        end
    end
    
    // VPIXEL Control Block.
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            VPIXEL <= 7'h00;
            V_cnt <= 14'h0000;
        end else begin
            if (V_RGB) begin
                if (V_cnt == V_LINE_CYCLE - 1'b1) begin
                    if (VPIXEL == 7'd95)
                        VPIXEL <= 7'h00;
                    else
                        VPIXEL <= VPIXEL + 1'b1;
                    V_cnt <= 14'h0000;
                end else begin
                    V_cnt <= V_cnt + 1'b1;
                end
            end else begin
                V_cnt <= 14'h0000;
                VPIXEL <= 7'h00;
            end
        end
    end
    
    assign addr = (H_RGB == 1'b0 || V_RGB == 1'b0) ? 14'd13000 : {VPIXEL, HPIXEL};
endmodule
