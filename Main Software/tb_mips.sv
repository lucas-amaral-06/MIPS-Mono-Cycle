`timescale 1ns/1ps

module tb;
    reg clk;
    reg reset;
    wire [31:0] t0, t1, t2, t3, s0;
    
    MIPS_Processor dut (
        .clk(clk),
        .reset(reset),
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
    
    // Reinicialização e estímulo
    initial begin
        // Inicializa e redefine
        reset = 1;
        #20 reset = 0;
        
        // Percorre ciclos o suficiente
        #200;
    end
    
    // Monitora todos os sinais
    initial begin
      $display("\n-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#");
        $display("Simulação do Processador MIPS - Monitor de Registro Detalhado");
        $display("-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#");
        $display("---------------------------------------------------------------------------------------------");
      
      $display("Tempo\tPC\t\tInstrução\t\t$t0\t$t1\t$t2\t$t3\t$s0\tALUOp");
      	$display("---------------------------------------------------------------------------------------------");
        
        forever begin
            @(posedge clk);
            #1; // Pequeno atraso para deixar os sinais estabilizarem
            $display("%0t\t%h\t%h\t%d\t%d\t%d\t%d\t%d\t%b",
                $time,
                dut.PC,
                dut.instruction,
                t0, t1, t2, t3, s0,
                dut.ALUControl);
         $display("----------------------------------------------------------------------------------------------------------------------------");
        end
    end
    
    // Verificação automática
    initial begin
        #220; // Aguarde até que todas as instruções sejam concluídas
        
      $display("\n-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#");
      	$display("Valor final dos registradores:");
        $display("$t0 = %d (Esperado: 20)", t0);
        $display("$t1 = %d (Esperado: 15)", t1);
        $display("$s0 = %d (Esperado: 1)", s0);
      $display("-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#");
        
      	$display("________________________________________________________________________");
        if (t0 === 32'd20 && t1 === 32'd15 && s0 === 32'd1) begin
            $display("TESTE APROVADO - Todos os valores correspondem aos resultados esperados!");
        end else begin
            $display("TESTE FALHOU - Incompatibilidade nos valores do registrador!");
        end
      	$display("________________________________________________________________________");
      
        $finish;
    end
    
    // Exibe de forma contínua
    initial begin
        $dumpfile("mips_waveform.vcd");
        $dumpvars(0, tb);
        $dumpvars(1, dut);
        $dumpvars(2, dut.reg_file);
    end
  
endmodule
