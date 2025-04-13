`timescale 1ns / 1ps

module ControlUnit(
    input [5:0] Op,
    input [5:0] Funct,
    output reg MemtoReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite,
    output reg [3:0] ALUControl  // 4 bits para compatibilidade com a ALU
);

always @(*) begin
    // Defaults
    MemtoReg = 0;
    MemWrite = 0;
    Branch = 0;
    ALUSrc = 0;
    RegDst = 0;
    RegWrite = 0;
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
            ALUControl = 4'b0010; // ADD
        end
        6'b101011: begin // SW
            ALUSrc = 1;
            MemWrite = 1;
            ALUControl = 4'b0010; // ADD
        end
        6'b000100: begin // BEQ
            Branch = 1;
            ALUControl = 4'b0110; // SUB
        end
        // Adicione outros casos (ADDI, J, etc.) conforme necessário
    endcase
end
endmodule
