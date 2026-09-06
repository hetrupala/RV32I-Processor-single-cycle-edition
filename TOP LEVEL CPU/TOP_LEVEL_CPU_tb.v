`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:
// Design Name:
// Module Name: TOP_LEVEL_CPU_tb
// Project Name:
// Target Devices:
// Tool Versions:
// Description: RV32I Single-Cycle CPU Testbench
//
// Dependencies:
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module TOP_LEVEL_CPU_tb;

    reg clk;
    reg reset;

    integer cycle;


    TOP_LEVEL_CPU uut (
        .clk(clk),
        .reset(reset)
    );


    // ============================================================
    // CLOCK
    // ============================================================

    initial begin
        clk = 1'b0;
    end

    always #5 clk = ~clk;


    // ============================================================
    // CYCLE MONITOR
    // ============================================================

    always @(negedge clk) begin

        if(reset == 1'b0) begin

            cycle = cycle + 1;

            $display("--------------------------------------------------");
            $display("Cycle        = %0d", cycle);
            $display("PC           = %h", uut.pc_value);
            $display("Instruction  = %h", uut.instruction);

            $display("RS1 Value    = %h", uut.rs1_value);
            $display("RS2 Value    = %h", uut.rs2_value);
            $display("Immediate    = %h", uut.immediate);

            $display("ALU Result   = %h", uut.alu_result);
            $display("Data In      = %h", uut.inst9.data_in);
            $display("Data Out     = %h", uut.data_out);
            $display("Write Data   = %h", uut.write_data);

            $display("Mem Read     = %b", uut.mem_read_out);
            $display("Mem Write    = %b", uut.mem_write_out);
            $display("Mem Size     = %b", uut.mem_size_out);
            $display("Sign Ext     = %b", uut.sign_ext_out);

            $display("Branch Taken = %b", uut.branch_taken);
            $display("Jump Taken   = %b", uut.jump_taken);
            $display("Jump Target  = %h", uut.jump_target);

        end

    end


    // ============================================================
    // TEST
    // ============================================================

    initial begin

        cycle = 0;

        reset = 1'b1;

        #10;

        reset = 1'b0;


        // ========================================================
        // ADDI x1, x0, 100
        // PC = 0x00
        // ========================================================

        @(posedge clk);
        #1;

        if(uut.inst3.Registers[1] == 32'd100)
            $display("PASS: ADDI x1,x0,100");
        else
            $display("FAIL: ADDI x1 = %h",
                     uut.inst3.Registers[1]);


        // ========================================================
        // ADDI x2, x0, 20
        // PC = 0x04
        // ========================================================

        @(posedge clk);
        #1;

        if(uut.inst3.Registers[2] == 32'd20)
            $display("PASS: ADDI x2,x0,20");
        else
            $display("FAIL: ADDI x2 = %h",
                     uut.inst3.Registers[2]);


        // ========================================================
        // ADDI x3, x0, -20
        // PC = 0x08
        // ========================================================

        @(posedge clk);
        #1;

        if(uut.inst3.Registers[3] == 32'hFFFFFFEC)
            $display("PASS: ADDI x3,x0,-20");
        else
            $display("FAIL: ADDI x3 = %h",
                     uut.inst3.Registers[3]);


        // ========================================================
        // ADDI x4, x0, 123
        // PC = 0x0C
        // ========================================================

        @(posedge clk);
        #1;

        if(uut.inst3.Registers[4] == 32'd123)
            $display("PASS: ADDI x4,x0,123");
        else
            $display("FAIL: ADDI x4 = %h",
                     uut.inst3.Registers[4]);


        // ========================================================
        // ADD x9, x1, x2
        // PC = 0x20
        // ========================================================

        repeat(3) @(posedge clk);
        #1;

        if(uut.inst3.Registers[9] == 32'd120)
            $display("PASS: ADD x9,x1,x2");
        else
            $display("FAIL: ADD x9 = %h",
                     uut.inst3.Registers[9]);


        // ========================================================
        // SUB x10, x1, x2
        // PC = 0x24
        // ========================================================

        @(posedge clk);
        #1;

        if(uut.inst3.Registers[10] == 32'd80)
            $display("PASS: SUB x10,x1,x2");
        else
            $display("FAIL: SUB x10 = %h",
                     uut.inst3.Registers[10]);


        // ========================================================
        // SLL x11, x2, x5
        // PC = 0x28
        // x2 = 20
        // x5 = 3
        // Result = 20 << 3 = 160
        // ========================================================

        @(posedge clk);
        #1;

        if(uut.inst3.Registers[11] == 32'd160)
            $display("PASS: SLL x11,x2,x5");
        else
            $display("FAIL: SLL x11 = %h",
                     uut.inst3.Registers[11]);


        // ========================================================
        // SLT x12, x3, x2
        // PC = 0x2C
        // x3 = -20
        // x2 = 20
        // -20 < 20 = true
        // ========================================================

        @(posedge clk);
        #1;

        if(uut.inst3.Registers[12] == 32'd1)
            $display("PASS: SLT x12,x3,x2");
        else
            $display("FAIL: SLT x12 = %h",
                     uut.inst3.Registers[12]);


        // ========================================================
        // SLTU x13, x2, x3
        // PC = 0x30
        // ========================================================

        @(posedge clk);
        #1;

        if(uut.inst3.Registers[13] == 32'd1)
            $display("PASS: SLTU x13,x2,x3");
        else
            $display("FAIL: SLTU x13 = %h",
                     uut.inst3.Registers[13]);


        // ========================================================
        // XOR x14, x1, x2
        // PC = 0x34
        // ========================================================

        @(posedge clk);
        #1;

        if(uut.inst3.Registers[14] == 32'h00000070)
            $display("PASS: XOR x14,x1,x2");
        else
            $display("FAIL: XOR x14 = %h",
                     uut.inst3.Registers[14]);


        // ========================================================
        // SRL x15, x2, x5
        // PC = 0x38
        // ========================================================

        @(posedge clk);
        #1;

        if(uut.inst3.Registers[15] == 32'd2)
            $display("PASS: SRL x15,x2,x5");
        else
            $display("FAIL: SRL x15 = %h",
                     uut.inst3.Registers[15]);


        // ========================================================
        // SRA x16, x3, x5
        // PC = 0x3C
        // -20 >>> 3 = -3
        // ========================================================

        @(posedge clk);
        #1;

        if(uut.inst3.Registers[16] == 32'hFFFFFFFD)
            $display("PASS: SRA x16,x3,x5");
        else
            $display("FAIL: SRA x16 = %h",
                     uut.inst3.Registers[16]);


        // ========================================================
        // OR x17, x1, x2
        // PC = 0x40
        // ========================================================

        @(posedge clk);
        #1;

        if(uut.inst3.Registers[17] == 32'h00000074)
            $display("PASS: OR x17,x1,x2");
        else
            $display("FAIL: OR x17 = %h",
                     uut.inst3.Registers[17]);


        // ========================================================
        // AND x18, x1, x2
        // PC = 0x44
        // ========================================================

        @(posedge clk);
        #1;

        if(uut.inst3.Registers[18] == 32'h00000004)
            $display("PASS: AND x18,x1,x2");
        else
            $display("FAIL: AND x18 = %h",
                     uut.inst3.Registers[18]);


        // ========================================================
        // RUN REMAINING PROGRAM
        // ========================================================

        #500;


        // ========================================================
        // FINAL STATE
        // ========================================================

        $display("==================================================");
        $display("FINAL CPU STATE");
        $display("==================================================");

        $display("PC           = %h", uut.pc_value);
        $display("Instruction  = %h", uut.instruction);
        $display("Branch Taken = %b", uut.branch_taken);
        $display("Jump Taken   = %b", uut.jump_taken);
        $display("Jump Target  = %h", uut.jump_target);


        // ========================================================
        // FINAL REGISTERS
        // ========================================================

        $display("==================================================");
        $display("FINAL REGISTERS");
        $display("==================================================");

        $display("x1  = %h", uut.inst3.Registers[1]);
        $display("x2  = %h", uut.inst3.Registers[2]);
        $display("x3  = %h", uut.inst3.Registers[3]);
        $display("x4  = %h", uut.inst3.Registers[4]);
        $display("x5  = %h", uut.inst3.Registers[5]);
        $display("x6  = %h", uut.inst3.Registers[6]);
        $display("x7  = %h", uut.inst3.Registers[7]);
        $display("x8  = %h", uut.inst3.Registers[8]);
        $display("x9  = %h", uut.inst3.Registers[9]);
        $display("x10 = %h", uut.inst3.Registers[10]);
        $display("x11 = %h", uut.inst3.Registers[11]);
        $display("x12 = %h", uut.inst3.Registers[12]);
        $display("x13 = %h", uut.inst3.Registers[13]);
        $display("x14 = %h", uut.inst3.Registers[14]);
        $display("x15 = %h", uut.inst3.Registers[15]);
        $display("x16 = %h", uut.inst3.Registers[16]);
        $display("x17 = %h", uut.inst3.Registers[17]);
        $display("x18 = %h", uut.inst3.Registers[18]);
        $display("x19 = %h", uut.inst3.Registers[19]);
        $display("x20 = %h", uut.inst3.Registers[20]);
        $display("x21 = %h", uut.inst3.Registers[21]);
        $display("x22 = %h", uut.inst3.Registers[22]);
        $display("x23 = %h", uut.inst3.Registers[23]);
        $display("x24 = %h", uut.inst3.Registers[24]);
        $display("x25 = %h", uut.inst3.Registers[25]);
        $display("x26 = %h", uut.inst3.Registers[26]);
        $display("x27 = %h", uut.inst3.Registers[27]);
        $display("x28 = %h", uut.inst3.Registers[28]);
        $display("x29 = %h", uut.inst3.Registers[29]);
        $display("x30 = %h", uut.inst3.Registers[30]);
        $display("x31 = %h", uut.inst3.Registers[31]);


        // ========================================================
        // DATA MEMORY
        // ========================================================

        $display("==================================================");
        $display("DATA MEMORY");
        $display("==================================================");

        $display("Memory[100] = %h", uut.inst9.memory[100]);
        $display("Memory[101] = %h", uut.inst9.memory[101]);
        $display("Memory[104] = %h", uut.inst9.memory[104]);
        $display("Memory[105] = %h", uut.inst9.memory[105]);
        $display("Memory[108] = %h", uut.inst9.memory[108]);
        $display("Memory[109] = %h", uut.inst9.memory[109]);
        $display("Memory[110] = %h", uut.inst9.memory[110]);
        $display("Memory[111] = %h", uut.inst9.memory[111]);


        // ========================================================
        // END
        // ========================================================

        $display("==================================================");
        $display("EXTENDED CPU TEST COMPLETE");
        $display("==================================================");

        #10;

        $finish;

    end

endmodule
