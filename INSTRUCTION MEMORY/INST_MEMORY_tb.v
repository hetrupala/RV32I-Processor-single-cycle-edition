`timescale 1ns / 1ps

module INST_MEMORY_tb;

    reg [31:0] addr_in;
    wire [31:0] inst_out;

    integer i;

    INST_MEMORY uut (
        .addr_in(addr_in),
        .inst_out(inst_out)
    );

    // ============================================================
    // TEST
    // ============================================================

    initial begin

        #1;

        $display("==================================================");
        $display("INST_MEMORY TEST");
        $display("==================================================");

        for(i = 0; i < 72; i = i + 1) begin

            addr_in = i * 4;

            #1;

            $display("Address = %h    Instruction = %h",
                     addr_in,
                     inst_out);

        end

        // ========================================================
        // DEFAULT ADDRESS TEST
        // ========================================================

        addr_in = 32'h00000120;

        #1;

        $display("Address = %h    Instruction = %h",
                 addr_in,
                 inst_out);

        $display("==================================================");
        $display("INST_MEMORY TEST COMPLETE");
        $display("==================================================");

        #10;

        $finish;

    end

endmodule
