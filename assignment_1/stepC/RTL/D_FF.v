`timescale 1ns / 1ps

// D-Flip Flop implementation.
module D_ff(clk, D, Q);
    input clk, D;
    output reg Q;
    
    always @ (posedge clk) begin
        Q <= D;
    end
endmodule