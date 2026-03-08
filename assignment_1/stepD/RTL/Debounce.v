`timescale 1ns / 1ps

// De-bounce mechanism for avoiding noise from the button push/release.
module Debounce (clk, sync_in, sync_tmp, db_out);
    input clk, sync_in, sync_tmp;
    output reg db_out;

    parameter DEBOUNCE_DELAY = 10000;

    reg [13:0] counter;
    
    always @(posedge clk) begin
        // If the 1st flip flop from the synchronizer has the same value with the second
        // We can increment the counter by 1. The Delay depends on the speed of the clock device.
        if (sync_in == sync_tmp)
            counter <= counter + 1;
        else
            counter <= 0;

        // When the wanted time has passed and the signal is stable
        // We can forward it to the output.
        if (counter == DEBOUNCE_DELAY)
            db_out <= sync_in;
    end

endmodule
