module MIPS(
  input clk,
  input reset
);

  // Sinais internos
  wire [31:0] PC, next_PC, instr;
  wire [31:0] read_data1, read_data2, ALU_result, write_data;
  wire [4:0] rs, rt, rd;
  wire [5:0] opcode;
  wire [15:0] immediate;
  wire reg_write, mem_write, mem_read, mem_to_reg, branch, alu_src, reg_dst;
  wire [3:0] alu_control;

  // Instanciando os módulos
  // 1. PC
  pc_register pc_inst (
    .clk(clk),
    .reset(reset),
    .next_PC(next_PC),
    .PC(PC)
  );

  // 2. Memória de instrução
  InstructionMemory instr_mem_inst (
    .address(PC),
    .instruction(instr)
  );

  // 3. Unidade de controle
  ControlUnit control_unit_inst (
    .Op(instr[31:26]),
    .Funct([5:0]),
    .MemtoReg(mem_to_reg),
    .MemWrite(mem_write),
    .Branch(branch),
    .ALUControl(alu_op),
    .ALUSrc(alu_src),
    .RegDst(reg_dst)
    .RegWrite(reg_write),
  );

  // 4. Decodificação da instrução
  assign rs = instr[25:21];
  assign rt = instr[20:16];
  assign rd = instr[15:11];
  assign opcode = instr[31:26];
  assign immediate = instr[15:0];

  // 5. Banco de registradores
  RegFile regfile_inst (
    .clk(clk),
    .we(reg_write),
    .A1(rs),
    .A2(rt),
    .A3(rd),
    .WD3(write_data),
    .RD1(read_data1),
    .RD2(read_data2)
  );

  // 6. MUX RegDst (seleciona entre rd e rt)
  MUX2to1 reg_dst_mux (
    .A(instr[20:16]),   // rt
    .B(instr[15:11]),   // rd
    .sel(reg_dst),      // RegDst
    .Y(rd)
  );

  // 7. MUX ALUSrc (seleciona entre o registrador ou o imediato)
  Mux2to1_32bits alu_src_mux (
    .A(read_data2),
    .B(immediate),       // Imediato
    .Sel(alu_src),       // ALUSrc
    .Out(alu_input_b)      // Entrada B da ALU
  );

  // 8. ALU (Executa a operação)
  ALU alu_inst (
    .A(read_data1),
    .B(alu_input_b),
    .op(alu_op),
    .resultado(ALU_result)
  );

  // 9. Memória de dados
  DataMemory data_mem_inst (
    .clk(clk),
    .address(ALU_result),
    .write_data(read_data2),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .read_data(write_data)
  );

  // 10. MUX MemToReg (seleciona entre ALU ou Memória de dados)
  Mux2to1_32bits mem_to_reg_mux (
    .A(ALU_result),
    .B(data_mem_out),    // Memória de dados
    .Sel(mem_to_reg),
    .Out(write_data)
  );

  // 11. MUX de PC (decide se o próximo PC é sequencial ou resultado de um branch)
  Mux2to1_32bits pc_mux (
    .A(PC + 4),
    .B(branch_target),
    .Sel(branch),
    .Out(next_PC)
  );

endmodule