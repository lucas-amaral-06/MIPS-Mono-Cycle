`timescale 1ns / 1ps

module MIPS_Processor (
    input wire clk,
    input wire reset,
    output [31:0] t0,
    output [31:0] t1,
    output [31:0] t2,
  	output [31:0] t3,
  	output [31:0] s0
);
    // Declaração de sinais
    wire [31:0] PC, PC_plus_4, next_PC;
    wire [31:0] instruction;
    wire [5:0] opcode, funct;
    wire [4:0] rs, rt, rd, shamt;
    wire [15:0] immediate;
    wire [25:0] jump_target;
    
    // Sinais de controle
    wire RegWrite, RegDst, ALUSrc, Branch, MemWrite, MemtoReg, Jump;
    wire [3:0] ALUControl;
    
    // Sinais do caminho de dados
    wire [31:0] read_data1, read_data2;
    wire [4:0] write_reg;
    wire [31:0] sign_extended, ALU_src2, ALU_result;
    wire [31:0] read_data_mem, write_back_data;
    wire [31:0] PCBranch_out;
    wire zero_flag;
    wire PCSrc;

    // Conexão do PC
    pc_register PC_reg (
        .clk(clk),
        .reset(reset),
        .next_PC(next_PC),
        .PC(PC)
    );

    // Memória de instruções
    InstructionMemory IM (
        .address(PC),
        .instruction(instruction)
    );

    // Decodificação da instrução
    assign opcode = instruction[31:26];
    assign rs = instruction[25:21];
    assign rt = instruction[20:16];
    assign rd = instruction[15:11];
    assign shamt = instruction[10:6];
    assign funct = instruction[5:0];
    assign immediate = instruction[15:0];
    assign jump_target = instruction[25:0];

    // Unidade de controle
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

    // Banco de registradores
    register_file reg_file (
        .clk(clk),
        .we(RegWrite),
        .A1(rs),
        .A2(rt),
        .A3(write_reg),
        .WD3(write_back_data),
        .RD1(read_data1),
        .RD2(read_data2),
        .t0(t0),
        .t1(t1),
        .t2(t2),
      	.t3(t3),
      	.s0(s0)
    );

    // MUX para seleção do registrador de escrita
    MUX5bits reg_dst_mux (
        .A(rt),
        .B(rd),
        .sel(RegDst),
        .Y(write_reg)
    );

    // Extensão de sinal
    sign_extend sign_ext (
        .imm16(immediate),
        .extended(sign_extended)
    );

    // MUX para seleção do segundo operando da ALU
    Mux2to1_32bits alu_src_mux (
        .A(read_data2),
        .B(sign_extended),
        .Sel(ALUSrc),
        .Out(ALU_src2)
    );

    // ALU
    ALU alu (
        .A(read_data1),
        .B(ALU_src2),
        .op(ALUControl),
        .resultado(ALU_result),
        .zero_flag(zero_flag)
    );

    // Memória de dados
    data_memory data_mem (
        .clk(clk),
        .mem_write(MemWrite),
        .address(ALU_result),
        .write_data(read_data2),
        .read_data(read_data_mem)
    );

    // MUX para seleção do dado de write-back
    Mux2to1_32bits mem_to_reg_mux (
        .A(ALU_result),
        .B(read_data_mem),
        .Sel(MemtoReg),
        .Out(write_back_data)
    );

    // Cálculo de PC+4
    assign PC_plus_4 = PC + 4;

    // Cálculo do branch
    PCBranch branch_calc (
        .PC(PC_plus_4),
        .immediate(immediate),
        .PCBranch(PCBranch_out)
    );

    // Lógica de PCSrc (Branch AND Zero)
    assign PCSrc = Branch & zero_flag;

    // MUX para seleção do próximo PC
    PCSrc pc_src_mux (
        .Branch(PCSrc),
        .Jump(Jump),
        .PCPlus4(PC_plus_4),
        .PCBranch(PCBranch_out),
        .JumpImm(jump_target),
        .next_PC(next_PC)
    );

endmodule
