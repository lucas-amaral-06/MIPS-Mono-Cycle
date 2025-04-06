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
