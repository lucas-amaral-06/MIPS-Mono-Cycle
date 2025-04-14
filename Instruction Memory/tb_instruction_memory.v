`timescale 1ns/1ps

module tb_MemoriaInstrucoes;

    // Entradas
    reg [31:0] endereco;
    
    // Saídas
    wire [31:0] instrucao;
    
    // Instancia o módulo sendo testado
    InstructionMemory dut (
        .address(endereco),
        .instruction(instrucao)
    );
    
    // Gerador de casos de teste
    initial begin
        // Inicializa entradas
        endereco = 0;
        
        // Configura arquivo de waveform
        $dumpfile("memoria_instrucoes.vcd");
        $dumpvars(0, tb_MemoriaInstrucoes);
        
        $display("==============================================");
        $display("Teste do Modulo de Memoria de Instrucoes");
        $display("==============================================");
        $display("Tempo\tEndereco\tInstrucao\t\tDecodificado");
        $display("----------------------------------------------");
        
        // Testa todas as posições de memória
        for (integer i = 0; i < 32; i = i + 1) begin
            endereco = i << 2;  // Converte índice de palavra para endereço de byte
            #10;
            
            $display("%4t\t%h\t%h\t%s", 
                    $time, 
                    endereco, 
                    instrucao,
                    decodificar_instrucao(instrucao));
        end
        
        // Verifica instruções críticas
        $display("\nResultados da Verificacao:");
        verificar_instrucao(0, 32'b001000_00000_01000_0000000000010100, "addi $t0, $zero, 20");
        verificar_instrucao(4, 32'b001000_00000_01001_0000000000001111, "addi $t1, $zero, 15");
        verificar_instrucao(8, 32'b000000_01001_01000_10000_00000_101010, "slt $s0, $t1, $t0");
        
        $display("==============================================");
        $finish;
    end
    
    // Função para decodificar instruções (versão compatível)
    function string decodificar_instrucao(input [31:0] instr);
        string opcode_str;
        string funct_str;
        
        case (instr[31:26])
            6'b001000: opcode_str = "addi";
            6'b000000: begin
                opcode_str = "Tipo-R";
                case (instr[5:0])
                    6'b101010: funct_str = " (slt)";
                    default: funct_str = " (desconhecido)";
                endcase
            end
            default: opcode_str = "nop/desconhecido";
        endcase
        
        return {opcode_str, funct_str};
    endfunction
    
    // Tarefa para verificar instruções específicas
    task verificar_instrucao(input [31:0] addr, input [31:0] esperado, input string descricao);
        endereco = addr;
        #1;
        if (instrucao === esperado) begin
            $display("[SUCESSO] @%h: %s", addr, descricao);
        end else begin
            $display("[FALHA] @%h: %s\n\tEsperado: %h\n\tObtido: %h", 
                    addr, descricao, esperado, instrucao);
        end
    endtask

endmodule
