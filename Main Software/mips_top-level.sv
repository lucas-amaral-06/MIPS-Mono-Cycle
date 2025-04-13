`timescale 1ns / 1ps

module MIPS_Processor(
    input wire clk,
    input wire reset
);
    // --- Sinais de interconexão ---
    wire [31:0] PC, next_PC, PC_plus_4, instruction;
    wire [5:0] opcode = instruction[31:26];
    wire [4:0] rs = instruction[25:21], rt = instruction[20:16], rd = instruction[15:11];
    wire [5:0] funct = instruction[5:0];
    wire [31:0] read_data1, read_data2, sign_extended, ALU_src2, ALU_result;
    wire [31:0] read_data_mem, write_back_data, PCBranch_out;
    wire zero_flag, PCSrc;
    wire [3:0] ALUControl;
    wire RegWrite, RegDst, ALUSrc, Branch, MemWrite, MemtoReg, Jump;

    // --- Instanciação dos módulos ---
    pc_register PC_reg (
        .clk(clk),
        .reset(reset),
        .next_PC(next_PC),
        .PC(PC)
    );

    InstructionMemory IM (
        .address(PC),
        .instruction(instruction)
    );

    ControlUnit control (
        .Op(opcode),
        .Funct(funct),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUSrc(ALUSrc),
        .RegDst(RegDst),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .ALUControl(ALUControl)
    );

    register_file reg_file (
        .clk(clk),
        .we(RegWrite),
        .A1(rs),
        .A2(rt),
        .A3(write_reg),
        .WD3(write_back_data),
        .RD1(read_data1),
        .RD2(read_data2)
    );

    MUX5bits reg_dst_mux (
        .A(rt),
        .B(rd),
        .sel(RegDst),
        .Y(write_reg)
    );

    sign_extend sign_ext (
        .imm16(instruction[15:0]),
        .extended(sign_extended)
    );

    Mux2to1_32bits alu_src_mux (
        .A(read_data2),
        .B(sign_extended),
        .Sel(ALUSrc),
        .Out(ALU_src2)
    );

    ALU alu (
        .A(read_data1),
        .B(ALU_src2),
        .op(ALUControl),
        .resultado(ALU_result),
        .zero_flag(zero_flag)
    );

    data_memory data_mem (
        .clk(clk),
        .mem_write(MemWrite),
        .address(ALU_result),
        .write_data(read_data2),
        .read_data(read_data_mem)
    );

    Mux2to1_32bits mem_to_reg_mux (
        .A(ALU_result),
        .B(read_data_mem),
        .Sel(MemtoReg),
        .Out(write_back_data)
    );

    assign PC_plus_4 = PC + 4;
    assign PCSrc = Branch & zero_flag;

    PCBranch branch_calc (
        .PC(PC_plus_4),
        .immediate(instruction[15:0]),
        .PCBranch(PCBranch_out)
    );

    PCSrc pc_src (
        .Branch(PCSrc),
        .Jump(Jump),
        .PCPlus4(PC_plus_4),
        .PCBranch(PCBranch_out),
        .JumpImm(instruction[25:0]),
        .next_PC(next_PC)
    );
endmodule
