`timescale 1ns / 1ps

// Synchronizer module for synchronizing the environment signals with device clock.
module Synchronizer (clk, async_in, sync_ff2, sync_out);
    input  clk, async_in;
    output sync_ff2, sync_out;

    wire sync_tmp, sync_ff1;

    // Sync flip flops.
    D_ff ff1(clk, async_in, sync_ff1);
    D_ff ff2(clk, sync_ff1, sync_tmp);
    D_ff ff3(clk, sync_tmp, sync_out);

    assign sync_ff2 = sync_tmp;

endmodule
