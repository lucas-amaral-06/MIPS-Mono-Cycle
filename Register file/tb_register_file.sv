`timescale 1ns/1ps

module tb_RegisterFile;

    // Entradas
    reg clk;
    reg we;
    reg [4:0] A1;
    reg [4:0] A2;
    reg [4:0] A3;
    reg [31:0] WD3;
    
    // Saídas
    wire [31:0] RD1;
    wire [31:0] RD2;
    wire [31:0] t0;
    wire [31:0] t1;
    wire [31:0] t2;
    wire [31:0] t3;
    wire [31:0] s0;
    
    // Instancia a Unit Under Test (UUT)
    register_file uut (
        .clk(clk),
        .we(we),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD3(WD3),
        .RD1(RD1),
        .RD2(RD2),
        .t0(t0),
        .t1(t1),
        .t2(t2),
        .t3(t3),
        .s0(s0)
    );
    
    // Geração de clock (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Procedimento de teste
    initial begin
        // Inicialização
        we = 0;
        A1 = 0;
        A2 = 0;
        A3 = 0;
        WD3 = 0;
        
        // Configura dump de waveform
        $dumpfile("register_file.vcd");
        $dumpvars(0, tb_RegisterFile);
        
        $display("=========================================");
        $display(" Teste do Banco de Registradores");
        $display("=========================================");
        $display("Tempo | Operacao       | Dados");
        $display("-----------------------------------------");
        
        // Teste 1: Escrita no registrador t0 ($8)
        #10;
        we = 1;
        A3 = 5'd8;  // t0
        WD3 = 32'h12345678;
        $display("%4tns | Escrita $t0   | Valor: %h", $time, WD3);
        
        // Teste 2: Leitura do registrador t0
        #10;
        we = 0;
        A1 = 5'd8;
        $display("%4tns | Leitura $t0   | Valor: %h", $time, RD1);
        
        // Teste 3: Escrita no registrador t1 ($9)
        #10;
        we = 1;
        A3 = 5'd9;  // t1
        WD3 = 32'hABCDEF01;
        $display("%4tns | Escrita $t1   | Valor: %h", $time, WD3);
        
        // Teste 4: Escrita no registrador s0 ($16)
        #10;
        A3 = 5'd16; // s0
        WD3 = 32'h55AA55AA;
        $display("%4tns | Escrita $s0   | Valor: %h", $time, WD3);
        
        // Teste 5: Leitura múltipla
        #10;
        we = 0;
        A1 = 5'd8;  // t0
        A2 = 5'd9;  // t1
        $display("%4tns | Leitura $t0-1 | $t0: %h, $t1: %h", $time, RD1, RD2);
        
        // Teste 6: Tentativa de escrita no $zero
        #10;
        we = 1;
        A3 = 5'd0;  // $zero
        WD3 = 32'hDEADBEEF;
        $display("%4tns | Escrita $zero | (deve ser ignorada)");
        
        // Teste 7: Verificação final
        #10;
        we = 0;
        A1 = 5'd0;  // $zero
        A2 = 5'd16; // s0
        $display("%4tns | Verificacao   | $zero: %h, $s0: %h", $time, RD1, RD2);
        
        // Verificação automática
        #10;
        $display("\nResultados da Verificacao:");
        verificar_registrador(8, 32'h12345678, "$t0");
        verificar_registrador(9, 32'hABCDEF01, "$t1");
        verificar_registrador(16, 32'h55AA55AA, "$s0");
        verificar_registrador(0, 32'h00000000, "$zero");
        
        $display("=========================================");
        $finish;
    end
    
    // Tarefa para verificação automática
    task verificar_registrador(input [4:0] addr, input [31:0] esperado, input string nome);
        A1 = addr;
        #1;
        if (RD1 === esperado) begin
            $display("[SUCESSO] %s = %h", nome, RD1);
        end else begin
            $display("[FALHA] %s deveria ser %h, mas eh %h", nome, esperado, RD1);
        end
    endtask

endmodule
