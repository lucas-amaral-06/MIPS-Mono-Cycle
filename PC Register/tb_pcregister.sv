module tb_pc_register;
    reg clk, reset;
    reg [31:0] next_PC;
    wire [31:0] PC;

    pc_register uut (.clk(clk), .reset(reset), .next_PC(next_PC), .PC(PC));

    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1; next_PC = 32'h0;
        #10;
        reset = 0; next_PC = 32'h00001004; // Sequencial
        #10;
        next_PC = 32'h00001010; // Branch
        #10;
        $finish;
    end

    initial $monitor("Time=%0t | reset=%b | next_PC=%h | PC=%h", $time, reset, next_PC, PC);
  
endmodule
