module ALU (
    input [31:0] A,
    input [31:0] B,
    input [3:0] op,          // Agora compatível com a ControlUnit (4 bits)
    output reg [31:0] resultado,
    output zero_flag
);

always @(*) begin
    case (op)
        4'b0000: resultado = A & B;    // AND
        4'b0001: resultado = A | B;    // OR
        4'b0010: resultado = A + B;    // ADD
        4'b0110: resultado = A - B;    // SUB
        4'b0111: resultado = (A < B) ? 32'd1 : 32'd0;  // SLT
        4'b1010: begin                  // DIV (opcional)
            if (B != 0) resultado = A / B;
            else resultado = 32'hFFFFFFFF;
        end
        default: resultado = 32'd0;
    endcase
end

assign zero_flag = (resultado == 0);

endmodule
