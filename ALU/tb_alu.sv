module tb_ALU;

    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] op;
    wire [31:0] resultado;
    wire zero_flag;

    // Instanciando a ALU
    ALU alu (
        .A(A),
        .B(B),
        .op(op),
        .resultado(resultado),
        .zero_flag(zero_flag)
    );

    initial begin

        // AND
        A = 32'd5;
        B = 32'd3;
        op = 4'b0000;
        #10;
      $display("AND: %d & %d = %d", A, B, resultado);

        // OR
        A = 32'd5;
        B = 32'd3;
        op = 4'b0001;
        #10;
        $display("OR: %d | %d = %d", A, B, resultado);

        // Soma
        A = 32'd15;
        B = 32'd20;
        op = 4'b0010;
        #10;
        $display("SOMA: %d + %d = %d", A, B, resultado);

        // Subtração
        A = 32'd30;
        B = 32'd12;
        op = 4'b0110;
        #10;
        $display("SUB: %d - %d = %d", A, B, resultado);

        // SLT
        A = 32'd5;
        B = 32'd10;
        op = 4'b0111;
        #10;
        $display("SLT: (%d < %d) = %d", A, B, resultado);

        // Divisão
        A = 32'd100;
        B = 32'd20;
        op = 4'b1010;
        #10;
        $display("DIV: %d / %d = %d", A, B, resultado);

        // Divisão por zero
        A = 32'd100;
        B = 32'd0;
        op = 4'b1010;
        #10;
        $display("DIV POR ZERO: %d / %d = %h", A, B, resultado);

        $finish;
    end
endmodule
