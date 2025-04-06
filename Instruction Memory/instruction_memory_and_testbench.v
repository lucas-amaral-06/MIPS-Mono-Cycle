module InstructionMemory(
    input [31:0] address,    // Endereço da instrução (PC)
    output reg [31:0] instruction // Instrução armazenada no endereço
);

    reg [31:0] memory [0:31]; // Memória com 32 instruções (pode ajustar o tamanho)

    initial begin
        // Exemplo de instruções em hexadecimal (pode substituir conforme necessário)
        memory[0] = 32'h20080005; // addi $t0, $zero, 5
        memory[1] = 32'h20090003; // addi $t1, $zero, 3
        memory[2] = 32'h01095020; // add $t2, $t0, $t1
        memory[3] = 32'hAC0A0004; // sw $t2, 4($zero)
        memory[4] = 32'h8C0B0004; // lw $t3, 4($zero)
        // Adicione mais instruções conforme necessário
    end

    always @(*) begin
        instruction = memory[address >> 2]; // Divide por 4 para acessar corretamente
    end
endmodule
