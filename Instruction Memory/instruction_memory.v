module InstructionMemory(
    input [31:0] address,
    output reg [31:0] instruction
);
    reg [31:0] memory[0:31];
    
    initial begin
        // addi $t0, $zero, 20
        memory[0] = 32'b001000_00000_01000_0000000000010100;  // Opcode 8, $zero(0), $t0(8), valor 20
        
        // addi $t1, $zero, 15
        memory[1] = 32'b001000_00000_01001_0000000000001111;  // Opcode 8, $zero(0), $t1(9), valor 15
        
        // slt $s0, $t1, $t0
        memory[2] = 32'b000000_01001_01000_10000_00000_101010; // Opcode 0, $t1(9), $t0(8), $s0(16), funct 42
        
        // Preenche o resto com nops
        for (int i = 3; i < 32; i++) begin
            memory[i] = 32'b00000000000000000000000000000000;
        end
    end
    
    always @(*) begin
        instruction = memory[address >> 2];
    end
endmodule
