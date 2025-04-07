module tb_data_memory;
    reg clk;
    reg mem_write;
    reg mem_read;
    reg [5:0] address;
    reg [31:0] write_data;
    wire [31:0] read_data;

    data_memory uut (
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        mem_write = 0;
        mem_read = 0;
        address = 0;
        write_data = 0;

        #10;
        mem_read = 1;
        address = 6'd1;
        #10;
        mem_read = 0;

        #10;
        mem_write = 1;
        address = 6'd2;
        write_data = 32'd50;
        #10;
        mem_write = 0;

        #10;
        mem_read = 1;
        address = 6'd2;
        #10;
        mem_read = 0;

        #10;
        mem_read = 1;
        address = 6'd3;
        #10;
        mem_read = 0;

        #10;
        $finish;
    end

    initial begin
        $monitor("Time=%0t | clk=%b | mem_write=%b | mem_read=%b | address=%d | write_data=%d | read_data=%d",
                 $time, clk, mem_write, mem_read, address, write_data, read_data);
    end
endmodule
