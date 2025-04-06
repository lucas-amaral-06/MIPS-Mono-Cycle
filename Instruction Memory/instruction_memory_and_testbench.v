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

module InstructionMemory_Testbench;
    reg [31:0] address;  // Endereço de entrada (PC)
    wire [31:0] instruction; // Saída da instrução

    // Instancia o módulo da Memória de Instruções
    InstructionMemory uut (
        .address(address),
        .instruction(instruction)
    );

    initial begin
        // Monitorando as mudanças na simulação
        $monitor("Time: %0t | PC: %h | Instrução: %h", $time, address, instruction);

        // Testa diferentes endereços
        address = 32'd0;  #10; // Busca a instrução na posição 0
        address = 32'd4;  #10; // Busca a instrução na posição 1
        address = 32'd8;  #10; // Busca a instrução na posição 2
        address = 32'd12; #10; // Busca a instrução na posição 3
        address = 32'd16; #10; // Busca a instrução na posição 4

        // Finaliza a simulação
        #10;
        $finish;
    end
endmodule
