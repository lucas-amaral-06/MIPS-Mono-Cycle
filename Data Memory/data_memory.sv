module data_memory (
    input wire clk,
    input wire mem_write,
    input wire mem_read,
    input wire [5:0] address,
    input wire [31:0] write_data,
    output reg [31:0] read_data
);
    reg [31:0] memory [0:63];
    initial begin
        memory[0] = 32'd0;
        memory[1] = 32'd10;
        memory[2] = 32'd20;
        memory[3] = 32'd30;
    end
    always @(posedge clk) begin
        if (mem_write) begin
            memory[address] <= write_data;
        end
        if (mem_read) begin
            read_data <= memory[address];
        end
    end
endmodule
