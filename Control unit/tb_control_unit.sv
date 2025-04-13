`timescale 1ns / 1ps

module ControlUnit_tb;

// Inputs
reg [5:0] Op;
reg [5:0] Funct;

// Outputs
wire [3:0] ALUControl;
wire MemtoReg;
wire MemWrite;
wire Branch;
wire ALUSrc;
wire RegDst;
wire RegWrite;

ControlUnit uut (
    .Op(Op),
    .Funct(Funct),
    .ALUControl(ALUControl),
    .MemtoReg(MemtoReg),
    .MemWrite(MemWrite),
    .Branch(Branch),
    .ALUSrc(ALUSrc),
    .RegDst(RegDst),
    .RegWrite(RegWrite)
);

initial begin
    // Teste R-type (ADD, SUB, AND, OR, SLT)
    Op = 6'b000000; 
    Funct = 6'b100000; #10; // ADD
    Funct = 6'b100010; #10; // SUB
    Funct = 6'b100100; #10; // AND
    Funct = 6'b100101; #10; // OR
    Funct = 6'b101010; #10; // SLT

    // Teste LW
    Op = 6'b100011; Funct = 6'bxxxxxx; #10;

    // Teste SW
    Op = 6'b101011; Funct = 6'bxxxxxx; #10;

    // Teste BEQ
    Op = 6'b000100; Funct = 6'bxxxxxx; #10;

    $display("Testes concluídos");
    $finish;
end

initial begin
    $monitor("T=%0t Op=%b Funct=%b | ALUCtrl=%b | RegDst=%b ALUSrc=%b MemtoReg=%b RegWrite=%b MemWrite=%b Branch=%b",
             $time, Op, Funct, ALUControl, RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, Branch);
end

endmodule
