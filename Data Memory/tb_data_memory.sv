module tb_data_memory;
    reg clk;
    reg mem_write;
    reg [31:0] address;
    reg [31:0] write_data;
    wire [31:0] read_data;

    // Instância da memória (sem mem_read)
    data_memory uut (
        .clk(clk),
        .mem_write(mem_write),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Geração de clock (período 10ns)
    always #5 clk = ~clk;

    initial begin
        // Inicialização
        clk = 0;
        mem_write = 0;
        address = 0;
        write_data = 0;

        // Teste 1: Leitura de endereço não escrito
        #10;
        address = 32'd1;      // Lê posição 1
        #10;

        // Teste 2: Escrita em posição 2
        #10;
        mem_write = 1;
        address = 32'd2;
        write_data = 32'd50;
        #10;
        mem_write = 0;

        #10;
        address = 32'd2;
        #10;

        // Teste 4: Escrita em posição 1023 (limite da memória)
        #10;
        mem_write = 1;
        address = 32'd1023;
        write_data = 32'hFFFF_FFFF;
        #10;
        mem_write = 0;

        // Teste 5: Leitura da posição 1023
        #10;
        address = 32'd1023;
        #10;

        $finish;
    end

    // Monitoramento
    initial begin
        $monitor("Time=%0t | Write=%b | Addr=%d | WriteData=%h | ReadData=%h",
                 $time, mem_write, address, write_data, read_data);
    end
endmodule
