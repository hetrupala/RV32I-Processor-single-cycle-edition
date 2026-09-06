`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.08.2026 11:25:57
// Design Name: 
// Module Name: DECODER_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: RV32I Instruction Decoder Testbench
//
// Dependencies: 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DECODER_tb;

    reg [31:0] instruction_in;

    wire [6:0] opcode_out;
    wire branch_out;
    wire [1:0] result_mux_out;
    wire [2:0] branch_op_out;
    wire alu_src_a_out;
    wire mem_write_out;
    wire mem_read_out;
    wire alu_src_b_out;
    wire reg_write_out;
    wire [5:0] alu_op_out;
    wire [2:0] imm_type_out;
    wire [1:0] mem_size_out;
    wire sign_ext_out;

    wire [4:0] rs1_addr_out;
    wire [4:0] rs2_addr_out;
    wire [4:0] rd_addr_out;


    DECODER uut (
        .instruction_in(instruction_in),

        .opcode_out(opcode_out),
        .branch_out(branch_out),
        .result_mux_out(result_mux_out),
        .branch_op_out(branch_op_out),
        .alu_src_a_out(alu_src_a_out),
        .mem_write_out(mem_write_out),
        .mem_read_out(mem_read_out),
        .alu_src_b_out(alu_src_b_out),
        .reg_write_out(reg_write_out),
        .alu_op_out(alu_op_out),
        .imm_type_out(imm_type_out),
        .mem_size_out(mem_size_out),
        .sign_ext_out(sign_ext_out),

        .rs1_addr_out(rs1_addr_out),
        .rs2_addr_out(rs2_addr_out),
        .rd_addr_out(rd_addr_out)
    );


    // ============================================================
    // TEST
    // ============================================================

    task check_decoder;

        input [31:0] instruction;
        input [31:0] expected;

        begin

            instruction_in = instruction;

            #2;

            if(
                opcode_out       == expected[31:25] &&
                branch_out       == expected[24] &&
                result_mux_out   == expected[23:22] &&
                branch_op_out    == expected[21:19] &&
                alu_src_a_out    == expected[18] &&
                mem_write_out    == expected[17] &&
                mem_read_out     == expected[16] &&
                alu_src_b_out    == expected[15] &&
                reg_write_out    == expected[14] &&
                alu_op_out       == expected[13:8] &&
                imm_type_out     == expected[7:5] &&
                mem_size_out     == expected[4:3] &&
                sign_ext_out     == expected[2]
            )
                $display("PASS: Instruction = %h", instruction);

            else begin
                $display("FAIL: Instruction = %h", instruction);

                $display("  opcode     = %b", opcode_out);
                $display("  branch     = %b", branch_out);
                $display("  result_mux = %b", result_mux_out);
                $display("  branch_op  = %b", branch_op_out);
                $display("  alu_src_a  = %b", alu_src_a_out);
                $display("  mem_write  = %b", mem_write_out);
                $display("  mem_read   = %b", mem_read_out);
                $display("  alu_src_b  = %b", alu_src_b_out);
                $display("  reg_write  = %b", reg_write_out);
                $display("  alu_op     = %b", alu_op_out);
                $display("  imm_type   = %b", imm_type_out);
                $display("  mem_size   = %b", mem_size_out);
                $display("  sign_ext   = %b", sign_ext_out);

            end

        end

    endtask


    initial begin


        // ============================================================
        // R-TYPE
        // ============================================================

        // ADD
        instruction_in = 32'h002081B3;
        #2;

        if(result_mux_out == 2'b00 &&
           mem_read_out == 1'b0 &&
           mem_write_out == 1'b0 &&
           reg_write_out == 1'b1 &&
           alu_op_out == 6'b000000 &&
           imm_type_out == 3'b101)
            $display("PASS: ADD");
        else
            $display("FAIL: ADD");


        // SUB
        instruction_in = 32'h40110233;
        #2;

        if(alu_op_out == 6'b000001 &&
           reg_write_out == 1'b1)
            $display("PASS: SUB");
        else
            $display("FAIL: SUB");


        // SLL
        instruction_in = 32'h002092B3;
        #2;

        if(alu_op_out == 6'b000111)
            $display("PASS: SLL");
        else
            $display("FAIL: SLL");


        // SLT
        instruction_in = 32'h0020A333;
        #2;

        if(alu_op_out == 6'b000101)
            $display("PASS: SLT");
        else
            $display("FAIL: SLT");


        // SLTU
        instruction_in = 32'h0020B3B3;
        #2;

        if(alu_op_out == 6'b000110)
            $display("PASS: SLTU");
        else
            $display("FAIL: SLTU");


        // XOR
        instruction_in = 32'h0020C433;
        #2;

        if(alu_op_out == 6'b000100)
            $display("PASS: XOR");
        else
            $display("FAIL: XOR");


        // SRL
        instruction_in = 32'h0020D4B3;
        #2;

        if(alu_op_out == 6'b001000)
            $display("PASS: SRL");
        else
            $display("FAIL: SRL");


        // SRA
        instruction_in = 32'h4020D533;
        #2;

        if(alu_op_out == 6'b001001)
            $display("PASS: SRA");
        else
            $display("FAIL: SRA");


        // OR
        instruction_in = 32'h0020E5B3;
        #2;

        if(alu_op_out == 6'b000011)
            $display("PASS: OR");
        else
            $display("FAIL: OR");


        // AND
        instruction_in = 32'h0020F633;
        #2;

        if(alu_op_out == 6'b000010)
            $display("PASS: AND");
        else
            $display("FAIL: AND");


        // ============================================================
        // I-TYPE OP-IMM
        // ============================================================

        // ADDI
        instruction_in = 32'h00A08193;
        #2;

        if(alu_src_b_out == 1'b1 &&
           reg_write_out == 1'b1 &&
           alu_op_out == 6'b000000 &&
           imm_type_out == 3'b000 &&
           mem_read_out == 1'b0 &&
           mem_write_out == 1'b0)
            $display("PASS: ADDI");
        else
            $display("FAIL: ADDI");


        // SLLI
        instruction_in = 32'h00309493;
        #2;

        if(alu_op_out == 6'b000111 &&
           alu_src_b_out == 1'b1)
            $display("PASS: SLLI");
        else
            $display("FAIL: SLLI");


        // SLTI
        instruction_in = 32'h00512213;
        #2;

        if(alu_op_out == 6'b000101)
            $display("PASS: SLTI");
        else
            $display("FAIL: SLTI");


        // SLTIU
        instruction_in = 32'h00513293;
        #2;

        if(alu_op_out == 6'b000110)
            $display("PASS: SLTIU");
        else
            $display("FAIL: SLTIU");


        // XORI
        instruction_in = 32'h00A0C313;
        #2;

        if(alu_op_out == 6'b000100)
            $display("PASS: XORI");
        else
            $display("FAIL: XORI");


        // SRLI
        instruction_in = 32'h0030D513;
        #2;

        if(alu_op_out == 6'b001000)
            $display("PASS: SRLI");
        else
            $display("FAIL: SRLI");


        // SRAI
        instruction_in = 32'h4030D593;
        #2;

        if(alu_op_out == 6'b001001)
            $display("PASS: SRAI");
        else
            $display("FAIL: SRAI");


        // ORI
        instruction_in = 32'h00A0E393;
        #2;

        if(alu_op_out == 6'b000011)
            $display("PASS: ORI");
        else
            $display("FAIL: ORI");


        // ANDI
        instruction_in = 32'h00A0F413;
        #2;

        if(alu_op_out == 6'b000010)
            $display("PASS: ANDI");
        else
            $display("FAIL: ANDI");


        // ============================================================
        // LOAD
        // ============================================================

        // LB
        instruction_in = 32'h00808183;
        #2;

        if(mem_read_out == 1'b1 &&
           mem_write_out == 1'b0 &&
           result_mux_out == 2'b01 &&
           mem_size_out == 2'b00 &&
           sign_ext_out == 1'b1 &&
           reg_write_out == 1'b1)
            $display("PASS: LB");
        else
            $display("FAIL: LB");


        // LH
        instruction_in = 32'h00809203;
        #2;

        if(mem_read_out == 1'b1 &&
           mem_size_out == 2'b01 &&
           sign_ext_out == 1'b1)
            $display("PASS: LH");
        else
            $display("FAIL: LH");


        // LW
        instruction_in = 32'h0080A283;
        #2;

        if(mem_read_out == 1'b1 &&
           mem_size_out == 2'b10 &&
           sign_ext_out == 1'b1)
            $display("PASS: LW");
        else
            $display("FAIL: LW");


        // LBU
        instruction_in = 32'h0080C303;
        #2;

        if(mem_read_out == 1'b1 &&
           mem_size_out == 2'b00 &&
           sign_ext_out == 1'b0)
            $display("PASS: LBU");
        else
            $display("FAIL: LBU");


        // LHU
        instruction_in = 32'h0080D383;
        #2;

        if(mem_read_out == 1'b1 &&
           mem_size_out == 2'b01 &&
           sign_ext_out == 1'b0)
            $display("PASS: LHU");
        else
            $display("FAIL: LHU");


        // ============================================================
        // STORE
        // ============================================================

        // SB
        instruction_in = 32'h00508423;
        #2;

        if(mem_write_out == 1'b1 &&
           mem_read_out == 1'b0 &&
           mem_size_out == 2'b00)
            $display("PASS: SB");
        else
            $display("FAIL: SB");


        // SH
        instruction_in = 32'h00509423;
        #2;

        if(mem_write_out == 1'b1 &&
           mem_read_out == 1'b0 &&
           mem_size_out == 2'b01)
            $display("PASS: SH");
        else
            $display("FAIL: SH");


        // SW
        instruction_in = 32'h0050A423;
        #2;

        if(mem_write_out == 1'b1 &&
           mem_read_out == 1'b0 &&
           mem_size_out == 2'b10)
            $display("PASS: SW");
        else
            $display("FAIL: SW");


        // ============================================================
        // BRANCH
        // ============================================================

        // BEQ
        instruction_in = 32'h00208863;
        #2;

        if(branch_out == 1'b1 &&
           branch_op_out == 3'b000 &&
           imm_type_out == 3'b010)
            $display("PASS: BEQ");
        else
            $display("FAIL: BEQ");


        // BNE
        instruction_in = 32'h00209863;
        #2;

        if(branch_out == 1'b1 &&
           branch_op_out == 3'b001)
            $display("PASS: BNE");
        else
            $display("FAIL: BNE");


        // BLT
        instruction_in = 32'h0020C863;
        #2;

        if(branch_out == 1'b1 &&
           branch_op_out == 3'b100)
            $display("PASS: BLT");
        else
            $display("FAIL: BLT");


        // BGE
        instruction_in = 32'h0020D863;
        #2;

        if(branch_out == 1'b1 &&
           branch_op_out == 3'b101)
            $display("PASS: BGE");
        else
            $display("FAIL: BGE");


        // BLTU
        instruction_in = 32'h0020E863;
        #2;

        if(branch_out == 1'b1 &&
           branch_op_out == 3'b110)
            $display("PASS: BLTU");
        else
            $display("FAIL: BLTU");


        // BGEU
        instruction_in = 32'h0020F863;
        #2;

        if(branch_out == 1'b1 &&
           branch_op_out == 3'b111)
            $display("PASS: BGEU");
        else
            $display("FAIL: BGEU");


        // ============================================================
        // LUI
        // ============================================================

        instruction_in = 32'h123452B7;
        #2;

        if(imm_type_out == 3'b011 &&
           result_mux_out == 2'b10 &&
           reg_write_out == 1'b1 &&
           mem_read_out == 1'b0 &&
           mem_write_out == 1'b0)
            $display("PASS: LUI");
        else
            $display("FAIL: LUI");


        // ============================================================
        // AUIPC
        // ============================================================

        instruction_in = 32'h12345297;
        #2;

        if(imm_type_out == 3'b011 &&
           alu_src_a_out == 1'b1 &&
           alu_src_b_out == 1'b1 &&
           alu_op_out == 6'b000000 &&
           result_mux_out == 2'b00 &&
           reg_write_out == 1'b1)
            $display("PASS: AUIPC");
        else
            $display("FAIL: AUIPC");


        // ============================================================
        // JAL
        // ============================================================

        instruction_in = 32'h010000EF;
        #2;

        if(imm_type_out == 3'b100 &&
           result_mux_out == 2'b11 &&
           reg_write_out == 1'b1)
            $display("PASS: JAL");
        else
            $display("FAIL: JAL");


        // ============================================================
        // JALR
        // ============================================================

        instruction_in = 32'h010102E7;
        #2;

        if(imm_type_out == 3'b000 &&
           result_mux_out == 2'b11 &&
           reg_write_out == 1'b1)
            $display("PASS: JALR");
        else
            $display("FAIL: JALR");


        // ============================================================
        // END
        // ============================================================

        $display("========================================");
        $display("DECODER TEST COMPLETE");
        $display("========================================");

        $finish;

    end

endmodule
