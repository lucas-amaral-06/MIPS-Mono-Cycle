module TB_PCSrc;
    reg Branch;
    reg Jump;
    reg [31:0] PCPlus4 = 32'h0000_0004;
    reg [31:0] PCBranch = 32'h0000_1000;
    reg [31:0] JumpAddr = 32'h0000_2000;

    wire [31:0] next_PC;

    PCSrc uut (
        .Branch(Branch),
        .Jump(Jump),
        .PCPlus4(PCPlus4),
        .PCBranch(PCBranch),
        .JumpAddr(JumpAddr),
        .next_PC(next_PC)
    );
    
    initial begin
        
        // Caso 1: Nenhum sinal ativo (deve selecionar PC+4)
        Branch = 0; Jump = 0;
        #10;
      $display("PCPlus4: %h", next_PC);
        
        // Caso 2: Apenas Branch ativo
        Branch = 1; Jump = 0;
        #10;
        $display("Branch: %h", next_PC);
        
        // Caso 3: Apenas Jump ativo
        Branch = 0; Jump = 1;
        #10;
        $display("Jump: %h", next_PC);
        
        // Caso 4: Ambos ativos (Jump deve ter prioridade)
        Branch = 1; Jump = 1;
        #10;
     	$display("Jump + Branch: %h", next_PC);
        
      	#10;
        $finish;
      
    end
  
endmodule
