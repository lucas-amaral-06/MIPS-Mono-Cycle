module pc_register (
    input wire clk,              // Clock
    input wire reset,            // Reset síncrono
    input wire [31:0] next_PC,   // Próximo endereço do PC
    output reg [31:0] PC         // Endereço atual do PC
);
    always @(posedge clk) begin
        if (reset)
            PC <= 32'h00000000;  // Zera o PC se reset=1
        else
            PC <= next_PC;       // Atualiza com next_PC
    end
endmodule
