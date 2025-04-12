module PCSrc (
    input wire Branch,         	// Sinal de branch
    input wire Jump,           	// Sinal de jump
  	input wire [31:0] PCPlus4,  // PCPlus4
    input wire [31:0] PCBranch, // PC calculado para branch
  	input wire [31:0] JumpAddr, // Endereço para jump
    output wire [31:0] next_PC  // Próximo PC selecionado
);

assign next_PC = Jump ? JumpAddr: 
                 (Branch ? PCBranch : PCPlus4);

endmodule
