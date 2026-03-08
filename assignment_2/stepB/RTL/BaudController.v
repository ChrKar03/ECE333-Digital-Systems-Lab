`timescale 1ns / 1ps

module baud_controller(reset, clk, baud_select, sample_ENABLE);
    input reset, clk;
    input [2:0] baud_select;
    output reg sample_ENABLE;
    reg [14:0] MAX_CYCLES;
    
    reg [14:0] cnt;
 
    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            cnt <= 15'h0000;
            sample_ENABLE <= 1'b0;
        end else begin
            sample_ENABLE <= 1'b0;
            cnt <= cnt + 1'b1;

            if (cnt == MAX_CYCLES) begin
                cnt <= {15{1'b0}};
                sample_ENABLE <= 1'b1;
            end
        end
    end
    
    always @(baud_select) begin
        case (baud_select)
            3'b000: MAX_CYCLES = 15'd20834;
            3'b001: MAX_CYCLES = 15'd5209;
            3'b010: MAX_CYCLES = 15'd1302;
            3'b011: MAX_CYCLES = 15'd651;
            3'b100: MAX_CYCLES = 15'd326;
            3'b101: MAX_CYCLES = 15'd163;
            3'b110: MAX_CYCLES = 15'd109;
            3'b111: MAX_CYCLES = 15'd54;
            default: MAX_CYCLES = 15'hFFFF;
        endcase
    end
 endmodule