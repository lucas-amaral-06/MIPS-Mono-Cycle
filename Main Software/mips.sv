`timescale 1ns / 1ps

// Módulo do Multiplexador 32 bits
module Mux2to1_32bits (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire        Sel,
    output wire [31:0] Out
);
    assign Out = Sel ? B : A;
endmodule

// Módulo do Multiplexador 5 bits
module MUX5bits(
    input wire [4:0] A,
    input wire [4:0] B,
    input wire       sel,
    output wire [4:0] Y
);
    assign Y = (sel) ? B : A;
endmodule

// Módulo de Shift Left 2
module ShiftLeft2 (
    input  [31:0] in,
    output [31:0] out
);
    assign out = in << 2;
endmodule

// Módulo da ALU
module ALU (
    input [31:0] A,
    input [31:0] B,
    input [3:0] op,
    output reg [31:0] resultado,
    output zero_flag
);
always @(*) begin
    case (op)
        4'b0000: resultado = A & B;    // AND
        4'b0001: resultado = A | B;    // OR
        4'b0010: resultado = A + B;    // ADD
        4'b0110: resultado = A - B;    // SUB
        4'b0111: resultado = (A < B) ? 32'd1 : 32'd0;  // SLT
        default: resultado = 32'd0;
    endcase
end
assign zero_flag = (resultado == 0);
endmodule

// Unidade de Controle
module ControlUnit(
    input [5:0] Op, 
    input [5:0] Funct,
    output reg MemtoReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, Jump,
    output reg [3:0] ALUControl
);
always @(*) begin
    // Defaults
    MemtoReg = 0;
    MemWrite = 0;
    Branch = 0;
    ALUSrc = 0;
    RegDst = 0;
    RegWrite = 0;
    Jump = 0;
    ALUControl = 4'b0000;

    case (Op)
        6'b000000: begin // R-type
            RegDst = 1;
            RegWrite = 1;
            case (Funct)
                6'b100000: ALUControl = 4'b0010; // ADD
                6'b100010: ALUControl = 4'b0110; // SUB
                6'b100100: ALUControl = 4'b0000; // AND
                6'b100101: ALUControl = 4'b0001; // OR
                6'b101010: ALUControl = 4'b0111; // SLT
                default:   ALUControl = 4'b0000;
            endcase
        end
        6'b100011: begin // LW
            ALUSrc = 1;
            MemtoReg = 1;
            RegWrite = 1;
            ALUControl = 4'b0010;
        end
        6'b101011: begin // SW
            ALUSrc = 1;
            MemWrite = 1;
            ALUControl = 4'b0010;
        end
        6'b000100: begin // BEQ
            Branch = 1;
            ALUControl = 4'b0110;
        end
        6'b000010: begin // J
            Jump = 1;
        end
        6'b001000: begin // ADDI
            ALUSrc = 1;
            RegWrite = 1;
            ALUControl = 4'b0010;
        end
    endcase
end
endmodule

// Memória de Dados
module data_memory (
    input wire clk,
    input wire mem_write,
    input wire [31:0] address,
    input wire [31:0] write_data,
    output reg [31:0] read_data
);
    reg [31:0] memory [0:1023];
    
    always @(posedge clk) begin
        if (mem_write) begin
            memory[address[11:2]] <= write_data;
        end
    end
    
    always @(*) begin
        read_data = memory[address[11:2]];
    end
endmodule

// Memória de Instruções
module InstructionMemory(
    input [31:0] address,
    output reg [31:0] instruction
);
    reg [31:0] memory [0:31];
    
    initial begin
        // Programa de teste
        memory[0] = 32'h20080005; // addi $t0, $zero, 5
        memory[1] = 32'h20090003; // addi $t1, $zero, 3
        memory[2] = 32'h01095020; // add $t2, $t0, $t1
        memory[3] = 32'hAC0A0004; // sw $t2, 4($zero)
        memory[4] = 32'h8C0B0004; // lw $t3, 4($zero)
        memory[5] = 32'h00000000; // nop (termina o programa)
    end
    
    always @(*) begin
        instruction = memory[address >> 2];
    end
endmodule

// Registrador PC
module pc_register (
    input wire clk,
    input wire reset,
    input wire [31:0] next_PC,
    output reg [31:0] PC
);
    always @(posedge clk) begin
        if (reset)
            PC <= 32'h00000000;
        else
            PC <= next_PC;
    end
endmodule

// Cálculo de PCBranch
module PCBranch (
    input [31:0] PC,
    input [15:0] immediate,
    output [31:0] PCBranch
);
    wire [31:0] extended_immediate = {{14{immediate[15]}}, immediate, 2'b00};
    assign PCBranch = PC + 4 + extended_immediate;
endmodule

// Seleção de PC
module PCSrc (
    input Branch,
    input Jump,
    input [31:0] PCPlus4,
    input [31:0] PCBranch,
    input [25:0] JumpImm,
    output [31:0] next_PC
);
    wire [31:0] JumpAddr = {PCPlus4[31:28], JumpImm, 2'b00};
    assign next_PC = Jump ? JumpAddr : (Branch ? PCBranch : PCPlus4);
endmodule

// Banco de Registradores com saídas de monitoramento
module register_file (
    input clk,
    input we,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD3,
    output [31:0] RD1,
    output [31:0] RD2,
    output [31:0] t0,  // $8
    output [31:0] t1,  // $9
    output [31:0] t2,  // $10
    output [31:0] t3   // $11
);
    reg [31:0] regs [31:0];
    
    assign RD1 = (A1 == 5'd0) ? 32'd0 : regs[A1];
    assign RD2 = (A2 == 5'd0) ? 32'd0 : regs[A2];
    
    assign t0 = regs[8];
    assign t1 = regs[9];
    assign t2 = regs[10];
    assign t3 = regs[11];
    
    always @(posedge clk) begin
        if (we && A3 != 5'd0) begin
            regs[A3] <= WD3;
        end
    end
endmodule

// Extensão de Sinal
module sign_extend (
    input [15:0] imm16,
    output [31:0] extended
);
    assign extended = {{16{imm16[15]}}, imm16};
endmodule

// MIPS Processor Top-Level
module MIPS_Processor (
    input wire clk,
    input wire reset,
    output [31:0] t0,
    output [31:0] t1,
    output [31:0] t2,
    output [31:0] t3
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
        .t3(t3)
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
