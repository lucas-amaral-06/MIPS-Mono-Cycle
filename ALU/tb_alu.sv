module tb_ALU;
    reg [31:0] A, B;
    reg [3:0] op;
    wire [31:0] resultado;
    wire zero_flag;

    ALU alu (.A(A), .B(B), .op(op), .resultado(resultado), .zero_flag(zero_flag));

    initial begin
        $display("Testando operações da ALU:");
        $monitor("T=%0t op=%b A=%d B=%d | Result=%d Zero=%b", 
                $time, op, A, B, resultado, zero_flag);

        // Teste AND
        op = 4'b0000; A = 32'b1010; B = 32'b1100; #10;

        // Teste OR
        op = 4'b0001; A = 32'b1010; B = 32'b1100; #10;

        // Teste ADD
        op = 4'b0010; A = 32'd15; B = 32'd20; #10;

        // Teste SUB
        op = 4'b0110; A = 32'd30; B = 32'd12; #10;

        // Teste SLT (A < B)
        op = 4'b0111; A = 32'd5; B = 32'd10; #10;

        // Teste SLT (A > B)
        op = 4'b0111; A = 32'd10; B = 32'd5; #10;

        // Teste DIV
        op = 4'b1010; A = 32'd100; B = 32'd20; #10;

        // Teste DIV por zero
        op = 4'b1010; A = 32'd100; B = 32'd0; #10;

        $finish;
    end
endmodule
