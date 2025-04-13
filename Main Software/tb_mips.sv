`timescale 1ns / 1ps

module tb;
    // Inputs
    reg clk;
    reg reset;
    
    // Outputs para monitoramento
    wire [31:0] t0, t1, t2, t3;
    
    // Instantiate the Unit Under Test (UUT)
    MIPS_Processor uut (
        .clk(clk),
        .reset(reset),
        .t0(t0),
        .t1(t1),
        .t2(t2),
        .t3(t3)
    );
    
    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Monitor para acompanhar a execução
    initial begin
        $monitor("Time = %t ns | PC = %h | Instr = %h | $t0 = %h, $t1 = %h, $t2 = %h, $t3 = %h", 
                 $time, uut.PC, uut.instruction, t0, t1, t2, t3);
    end
    
    // Dump de variáveis para visualização
    initial begin
        $dumpfile("mips_processor.vcd");
        $dumpvars(0, tb);
    end
    
    // Test sequence
    initial begin
        // Inicialização com reset
        reset = 1;
        #20;
        reset = 0;
        
        // Executa por tempo suficiente para todas as instruções
        #200;
        
        // Verificação dos resultados
      $display("\n#-#-#-# Resultado dos Testes #-#-#-#");
        $display("$t0 (8) = %h (Expected: 00000005)", t0);
        $display("$t1 (9) = %h (Expected: 00000003)", t1);
        $display("$t2 (10) = %h (Expected: 00000008)", t2);
        $display("$t3 (11) = %h (Expected: 00000008)", t3);
        
        // Verificação automática
        if (t0 === 32'h00000005 && t1 === 32'h00000003 && 
            t2 === 32'h00000008 && t3 === 32'h00000008) begin
            $display("PASSED: All tests completed successfully!");
        end else begin
            $display("FAILED: Some tests did not produce the expected results");
        end
        
        $finish;
    end
endmodule
