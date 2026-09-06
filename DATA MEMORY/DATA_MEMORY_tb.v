`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: DATA_MEMORY_tb
// Project Name: 
// Target Devices: 
// Tool Versions:
// Description: DATA_MEMORY Testbench
//
// Dependencies: 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DATA_MEMORY_tb;

    reg clk;
    reg mem_write_out;
    reg mem_read_out;
    reg [1:0] mem_size;
    reg sign_ext;
    reg [31:0] rs2_value;
    reg [31:0] alu_out;

    wire [31:0] data_out;


    DATA_MEMORY uut (
        .clk(clk),
        .mem_write_out(mem_write_out),
        .mem_read_out(mem_read_out),
        .mem_size(mem_size),
        .sign_ext(sign_ext),
        .rs2_value(rs2_value),
        .alu_out(alu_out),
        .data_out(data_out)
    );


    // ============================================================
    // CLOCK
    // ============================================================

    initial begin
        clk = 1'b0;
    end

    always #5 clk = ~clk;


    // ============================================================
    // TEST
    // ============================================================

    initial begin

        mem_write_out = 1'b0;
        mem_read_out  = 1'b0;
        mem_size      = 2'b00;
        sign_ext      = 1'b1;
        rs2_value     = 32'b0;
        alu_out       = 32'b0;

        #10;


        // ========================================================
        // STORE BYTE
        // ========================================================

        // Store 0xAB at address 100

        mem_write_out = 1'b1;
        mem_read_out  = 1'b0;
        mem_size      = 2'b00;
        rs2_value     = 32'h000000AB;
        alu_out       = 32'd100;

        #10;

        if(uut.memory[100] == 8'hAB)
            $display("PASS: SB");
        else
            $display("FAIL: SB = %h", uut.memory[100]);


        // ========================================================
        // LOAD BYTE SIGNED
        // ========================================================

        mem_write_out = 1'b0;
        mem_read_out  = 1'b1;
        mem_size      = 2'b00;
        sign_ext      = 1'b1;
        alu_out       = 32'd100;

        #2;

        if(data_out == 32'hFFFFFFAB)
            $display("PASS: LB");
        else
            $display("FAIL: LB = %h", data_out);

        $display("Data In  = %h", uut.data_in);
        $display("Data Out = %h", data_out);


        // ========================================================
        // LOAD BYTE UNSIGNED
        // ========================================================

        sign_ext = 1'b0;

        #2;

        if(data_out == 32'h000000AB)
            $display("PASS: LBU");
        else
            $display("FAIL: LBU = %h", data_out);

        $display("Data In  = %h", uut.data_in);
        $display("Data Out = %h", data_out);


        // ========================================================
        // STORE HALFWORD
        // ========================================================

        // Store 0xABCD at address 200

        mem_write_out = 1'b1;
        mem_read_out  = 1'b0;
        mem_size      = 2'b01;
        sign_ext      = 1'b1;
        rs2_value     = 32'h0000ABCD;
        alu_out       = 32'd200;

        #10;

        if(uut.memory[200] == 8'hCD &&
           uut.memory[201] == 8'hAB)
            $display("PASS: SH");
        else
            $display("FAIL: SH");


        // ========================================================
        // LOAD HALFWORD SIGNED
        // ========================================================

        mem_write_out = 1'b0;
        mem_read_out  = 1'b1;
        mem_size      = 2'b01;
        sign_ext      = 1'b1;
        alu_out       = 32'd200;

        #2;

        if(data_out == 32'hFFFFABCD)
            $display("PASS: LH");
        else
            $display("FAIL: LH = %h", data_out);

        $display("Data In  = %h", uut.data_in);
        $display("Data Out = %h", data_out);


        // ========================================================
        // LOAD HALFWORD UNSIGNED
        // ========================================================

        sign_ext = 1'b0;

        #2;

        if(data_out == 32'h0000ABCD)
            $display("PASS: LHU");
        else
            $display("FAIL: LHU = %h", data_out);

        $display("Data In  = %h", uut.data_in);
        $display("Data Out = %h", data_out);


        // ========================================================
        // STORE WORD
        // ========================================================

        // Store 0x12345678 at address 300

        mem_write_out = 1'b1;
        mem_read_out  = 1'b0;
        mem_size      = 2'b10;
        rs2_value     = 32'h12345678;
        alu_out       = 32'd300;

        #10;

        if(uut.memory[300] == 8'h78 &&
           uut.memory[301] == 8'h56 &&
           uut.memory[302] == 8'h34 &&
           uut.memory[303] == 8'h12)
            $display("PASS: SW");
        else
            $display("FAIL: SW");


        // ========================================================
        // LOAD WORD
        // ========================================================

        mem_write_out = 1'b0;
        mem_read_out  = 1'b1;
        mem_size      = 2'b10;
        sign_ext      = 1'b1;
        alu_out       = 32'd300;

        #2;

        if(data_out == 32'h12345678)
            $display("PASS: LW");
        else
            $display("FAIL: LW = %h", data_out);

        $display("Data In  = %h", uut.data_in);
        $display("Data Out = %h", data_out);


        // ========================================================
        // NORMAL / NO MEMORY OPERATION
        // ========================================================

        // This represents instructions such as ADD, ADDI,
        // LUI, AUIPC, branches and jumps.

        mem_write_out = 1'b0;
        mem_read_out  = 1'b0;
        mem_size      = 2'b10;
        alu_out       = 32'd300;

        #2;

        if(data_out == 32'b0)
            $display("PASS: NO MEMORY OPERATION");
        else
            $display("FAIL: NO MEMORY OPERATION = %h", data_out);


        // ========================================================
        // CHECK MEMORY BYTES
        // ========================================================

        $display("----------------------------------------");

        $display("Memory[100] = %h", uut.memory[100]);

        $display("Memory[200] = %h", uut.memory[200]);
        $display("Memory[201] = %h", uut.memory[201]);

        $display("Memory[300] = %h", uut.memory[300]);
        $display("Memory[301] = %h", uut.memory[301]);
        $display("Memory[302] = %h", uut.memory[302]);
        $display("Memory[303] = %h", uut.memory[303]);

        $display("----------------------------------------");


        // ========================================================
        // END
        // ========================================================

        #10;

        $display("========================================");
        $display("DATA MEMORY TEST COMPLETE");
        $display("========================================");

        $finish;

    end

endmodule
