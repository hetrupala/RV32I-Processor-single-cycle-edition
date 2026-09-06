`timescale 1ns / 1ps

module INST_MEMORY(
    input wire [31:0] addr_in,
    output reg [31:0] inst_out
);

    reg [31:0] memory [0:71];

    integer i;

    initial begin

        // ============================================================
        // DEFAULT MEMORY = NOP
        // ============================================================

        for(i = 0; i < 72; i = i + 1) begin
            memory[i] = 32'h00000013;
        end


        // ============================================================
        // I-TYPE
        // ============================================================

        memory[0] = 32'h06400093;   // 0x000  ADDI  x1, x0, 100
        memory[1] = 32'h01400113;   // 0x004  ADDI  x2, x0, 20
        memory[2] = 32'hFEC00193;   // 0x008  ADDI  x3, x0, -20
        memory[3] = 32'h07B00213;   // 0x00C  ADDI  x4, x0, 123
        memory[4] = 32'h00300293;   // 0x010  ADDI  x5, x0, 3
        memory[5] = 32'h00400313;   // 0x014  ADDI  x6, x0, 4
        memory[6] = 32'h00100393;   // 0x018  ADDI  x7, x0, 1
        memory[7] = 32'h00200413;   // 0x01C  ADDI  x8, x0, 2


        // ============================================================
        // R-TYPE
        // ============================================================

        memory[8]  = 32'h002084B3;  // 0x020  ADD   x9,  x1, x2
        memory[9]  = 32'h40208533;  // 0x024  SUB   x10, x1, x2
        memory[10] = 32'h005115B3;  // 0x028  SLL   x11, x2, x5
        memory[11] = 32'h0021A633;  // 0x02C  SLT   x12, x3, x2
        memory[12] = 32'h003136B3;  // 0x030  SLTU  x13, x2, x3
        memory[13] = 32'h0020C733;  // 0x034  XOR   x14, x1, x2
        memory[14] = 32'h005157B3;  // 0x038  SRL   x15, x2, x5
        memory[15] = 32'h4051D833;  // 0x03C  SRA   x16, x3, x5
        memory[16] = 32'h0020E8B3;  // 0x040  OR    x17, x1, x2
        memory[17] = 32'h0020F933;  // 0x044  AND   x18, x1, x2


        // ============================================================
        // I-TYPE OP-IMM
        // ============================================================

        memory[18] = 32'hFFB10993;  // 0x048  ADDI  x19, x2, -5
        memory[19] = 32'h00311A13;  // 0x04C  SLLI  x20, x2, 3
        memory[20] = 32'h01E12A93;  // 0x050  SLTI  x21, x2, 30
        memory[21] = 32'h01E13B13;  // 0x054  SLTIU x22, x2, 30
        memory[22] = 32'h05514B93;  // 0x058  XORI  x23, x2, 0x55
        memory[23] = 32'h002BDD13;  // 0x05C  SRLI  x26, x23, 2
        memory[24] = 32'h4021D293;  // 0x060  SRAI  x5, x3, 2
        memory[25] = 32'h0AA16D13;  // 0x064  ORI   x26, x2, 0xAA
        memory[26] = 32'h01FD7D93;  // 0x068  ANDI  x27, x26, 0x1F


        // ============================================================
        // U-TYPE
        // ============================================================

        memory[27] = 32'h12345E37;  // 0x06C  LUI   x28, 0x12345
        memory[28] = 32'h00001E97;  // 0x070  AUIPC x29, 0x1


        // ============================================================
        // STORE
        // Base address = x1 = 100
        //
        // memory[100] = EC
        // memory[104] = 7B 00
        // memory[108] = 14 00 00 00
        // ============================================================

        memory[29] = 32'h00308023;  // 0x074  SB    x3, 0(x1)
        memory[30] = 32'h00409223;  // 0x078  SH    x4, 4(x1)
        memory[31] = 32'h0020A423;  // 0x07C  SW    x2, 8(x1)


        // ============================================================
        // LOAD
        // ============================================================

        memory[32] = 32'h00008F03;  // 0x080  LB    x30, 0(x1)
        memory[33] = 32'h0000CF83;  // 0x084  LBU   x31, 0(x1)
        memory[34] = 32'h00409583;  // 0x088  LH    x11, 4(x1)
        memory[35] = 32'h0040D603;  // 0x08C  LHU   x12, 4(x1)
        memory[36] = 32'h0080A683;  // 0x090  LW    x13, 8(x1)


        // ============================================================
        // BRANCH TEST SETUP
        // ============================================================

        memory[37] = 32'h00000D13;  // 0x094  ADDI x26, x0, 0
        memory[38] = 32'h00000D93;  // 0x098  ADDI x27, x0, 0


        // ============================================================
        // TAKEN BRANCH TESTS
        //
        // Every taken branch skips the following instruction.
        // ============================================================

        memory[39] = 32'h01AD0463;  // 0x09C  BEQ   x26, x27, +8
        memory[40] = 32'h3E700E13;  // 0x0A0  ADDI  x28, x0, 999  SKIPPED

        memory[41] = 32'h01BD1463;  // 0x0A4  BNE   x27, x27, +8
        memory[42] = 32'h3E800E13;  // 0x0A8  ADDI  x28, x0, 1000 EXECUTES

        memory[43] = 32'h01BD4463;  // 0x0AC  BLT   x26, x27, +8
        memory[44] = 32'h3E900E13;  // 0x0B0  ADDI  x28, x0, 1001 EXECUTES

        memory[45] = 32'h01AD5463;  // 0x0B4  BGE   x26, x27, +8
        memory[46] = 32'h3EA00E13;  // 0x0B8  ADDI  x28, x0, 1002 EXECUTES

        memory[47] = 32'h01BD6463;  // 0x0BC  BLTU  x26, x27, +8
        memory[48] = 32'h3EB00E13;  // 0x0C0  ADDI  x28, x0, 1003 EXECUTES

        memory[49] = 32'h01AD7463;  // 0x0C4  BGEU  x26, x27, +8
        memory[50] = 32'h3EC00E13;  // 0x0C8  ADDI  x28, x0, 1004 EXECUTES


        // ============================================================
        // SECOND BRANCH SET
        //
        // These are deliberately NOT taken.
        // The following ADDI executes.
        // ============================================================

        memory[51] = 32'h01BD0463;  // 0x0CC  BEQ   x26, x27, +8
        memory[52] = 32'h3E900E93;  // 0x0D0  ADDI  x29, x0, 1001

        memory[53] = 32'h01AD1463;  // 0x0D4  BNE   x26, x26, +8
        memory[54] = 32'h3EA00E93;  // 0x0D8  ADDI  x29, x0, 1002

        memory[55] = 32'h01BD4463;  // 0x0DC  BLT   x27, x26, +8
        memory[56] = 32'h3EB00E93;  // 0x0E0  ADDI  x29, x0, 1003

        memory[57] = 32'h01AD5463;  // 0x0E4  BGE   x26, x27, +8
        memory[58] = 32'h3EC00E93;  // 0x0E8  ADDI  x29, x0, 1004

        memory[59] = 32'h01BD6463;  // 0x0EC  BLTU  x27, x26, +8
        memory[60] = 32'h3ED00E93;  // 0x0F0  ADDI  x29, x0, 1005

        memory[61] = 32'h01AD7463;  // 0x0F4  BGEU  x26, x27, +8
        memory[62] = 32'h3EE00E93;  // 0x0F8  ADDI  x29, x0, 1006


        // ============================================================
        // JAL
        //
        // JAL at 0x0FC jumps to 0x104.
        // 0x100 is skipped.
        // ============================================================

        memory[63] = 32'h00800FEF;  // 0x0FC  JAL   x31, +8
        memory[64] = 32'h3E700F13;  // 0x100  ADDI  x30, x0, 999  SKIPPED
        memory[65] = 32'h14100F13;  // 0x104  ADDI  x30, x0, 321


        // ============================================================
        // JALR SETUP
        //
        // 264 decimal = 0x108
        // ============================================================

        memory[66] = 32'h11000F13;  // 0x108  ADDI x30, x0, 272
        memory[67] = 32'h000F0FE7;  // 0x10C  JALR x31, 0(x30)


        // ============================================================
        // JALR TARGET
        // ============================================================

        memory[68] = 32'h06500093;  // 0x110  ADDI  x1, x0, 101
        memory[69] = 32'h00110233;  // 0x114  ADD   x4, x2, x1
        memory[70] = 32'h00000013;  // 0x118  NOP
        memory[71] = 32'h00000013;  // 0x11C  NOP

    end


    // ============================================================
    // INSTRUCTION READ
    // ============================================================

    always @(*) begin

        case(addr_in)

            32'h00000000: inst_out = memory[0];
            32'h00000004: inst_out = memory[1];
            32'h00000008: inst_out = memory[2];
            32'h0000000C: inst_out = memory[3];
            32'h00000010: inst_out = memory[4];
            32'h00000014: inst_out = memory[5];
            32'h00000018: inst_out = memory[6];
            32'h0000001C: inst_out = memory[7];

            32'h00000020: inst_out = memory[8];
            32'h00000024: inst_out = memory[9];
            32'h00000028: inst_out = memory[10];
            32'h0000002C: inst_out = memory[11];
            32'h00000030: inst_out = memory[12];
            32'h00000034: inst_out = memory[13];
            32'h00000038: inst_out = memory[14];
            32'h0000003C: inst_out = memory[15];
            32'h00000040: inst_out = memory[16];
            32'h00000044: inst_out = memory[17];

            32'h00000048: inst_out = memory[18];
            32'h0000004C: inst_out = memory[19];
            32'h00000050: inst_out = memory[20];
            32'h00000054: inst_out = memory[21];
            32'h00000058: inst_out = memory[22];
            32'h0000005C: inst_out = memory[23];
            32'h00000060: inst_out = memory[24];
            32'h00000064: inst_out = memory[25];
            32'h00000068: inst_out = memory[26];

            32'h0000006C: inst_out = memory[27];
            32'h00000070: inst_out = memory[28];

            32'h00000074: inst_out = memory[29];
            32'h00000078: inst_out = memory[30];
            32'h0000007C: inst_out = memory[31];

            32'h00000080: inst_out = memory[32];
            32'h00000084: inst_out = memory[33];
            32'h00000088: inst_out = memory[34];
            32'h0000008C: inst_out = memory[35];
            32'h00000090: inst_out = memory[36];

            32'h00000094: inst_out = memory[37];
            32'h00000098: inst_out = memory[38];
            32'h0000009C: inst_out = memory[39];
            32'h000000A0: inst_out = memory[40];
            32'h000000A4: inst_out = memory[41];
            32'h000000A8: inst_out = memory[42];
            32'h000000AC: inst_out = memory[43];
            32'h000000B0: inst_out = memory[44];
            32'h000000B4: inst_out = memory[45];
            32'h000000B8: inst_out = memory[46];
            32'h000000BC: inst_out = memory[47];
            32'h000000C0: inst_out = memory[48];
            32'h000000C4: inst_out = memory[49];
            32'h000000C8: inst_out = memory[50];

            32'h000000CC: inst_out = memory[51];
            32'h000000D0: inst_out = memory[52];
            32'h000000D4: inst_out = memory[53];
            32'h000000D8: inst_out = memory[54];
            32'h000000DC: inst_out = memory[55];
            32'h000000E0: inst_out = memory[56];
            32'h000000E4: inst_out = memory[57];
            32'h000000E8: inst_out = memory[58];
            32'h000000EC: inst_out = memory[59];
            32'h000000F0: inst_out = memory[60];
            32'h000000F4: inst_out = memory[61];
            32'h000000F8: inst_out = memory[62];

            32'h000000FC: inst_out = memory[63];
            32'h00000100: inst_out = memory[64];
            32'h00000104: inst_out = memory[65];
            32'h00000108: inst_out = memory[66];
            32'h0000010C: inst_out = memory[67];

            32'h00000110: inst_out = memory[68];
            32'h00000114: inst_out = memory[69];
            32'h00000118: inst_out = memory[70];
            32'h0000011C: inst_out = memory[71];

            default: inst_out = 32'h00000013;

        endcase

    end

endmodule
