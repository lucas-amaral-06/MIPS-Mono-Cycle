module PCPlus4(     // Módulo do registrador do PC
    input clk,
    input reset,
    input [31:0] next_PC,
    output reg [31:0] PC
);
    always @(posedge clk or posedge reset) begin
        if (reset)   // Zera o PC
            PC <= 32'b0;
        else        // Atualiza o PC
            PC <= next_PC;
    end
endmodule

module PC_Adder(  // Incremento o valor atual do PC em 4
    input [31:0] PC,
    output [31:0] next_PC
);
    assign next_PC = PC + 32'd4;  // Gera o netx_PC que será usado no módulo anterior
endmodule

module PC_System(  // Conecta os dois módulos anteriores
    input clk,
    input reset,
    output [31:0] PC
);
    wire [31:0] next_PC;
    
    PCPlus4 pc_reg (
        .clk(clk),
        .reset(reset),
        .next_PC(next_PC),
        .PC(PC)
    );
    
    PC_Adder pc_adder (
        .PC(PC),
        .next_PC(next_PC)
    );
endmodule
