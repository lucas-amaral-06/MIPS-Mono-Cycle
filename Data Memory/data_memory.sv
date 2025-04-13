module data_memory (
    input wire clk,               // Clock
    input wire mem_write,         // Controle de escrita
    input wire [31:0] address,    // Endereço de 32 bits
    input wire [31:0] write_data, // Dado a ser escrito
    output reg [31:0] read_data   // Dado lido
);
    
    reg [31:0] memory [0:1023];

    // Escrita síncrona
    always @(posedge clk) begin
        if (mem_write) begin
            memory[address[11:2]] <= write_data;
        end
    end

    // Leitura assíncrona
    always @(*) begin
        read_data = memory[address[11:2]];
    end
endmodule
