module PCBranch_tb;
    reg [31:0] PC;
    reg [15:0] immediate;
    wire [31:0] PCBranch;

    PCBranch uut (.PC(PC), .immediate(immediate), .PCBranch(PCBranch));

    initial begin
        // Teste 1: salto positivo
        PC = 32'h1000;       // Endereço inicial
        immediate = 16'h0004; // Offset +4
        #10;
        $display("PC=%h, Offset=%h → PCBranch=%h (Esperado: 1014)", 
                 PC, immediate, PCBranch);

        // Teste 2: salto negativo
        PC = 32'h1000;
        immediate = 16'hFFFC; // Offset -4
        #10;
        $display("Teste 2 - Salto Negativo:");
        $display("PC=%h, Offset=%h → PCBranch=%h (Esperado: 0FF4)", 
                 PC, immediate, PCBranch);
        #10 $finish;
      
    end
  
endmodule
