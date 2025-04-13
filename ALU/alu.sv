module ALU (

  	input [31:0] A,      // Entrada A (1° operando)
  	input [31:0] B,      // Entrada B (2° operando)
    input [2:0] op,      // Código da operação que será realizada (podendo conter até 03 bits)

  	output reg [31:0] resultado,		// Resultado da operação
    output zero_flag             		// Sinal que indica se o resultado é zero
);

    always @(*) begin
        case (op)
            4'b0000: resultado = A & B;
            4'b0001: resultado = A | B;
            4'b0010: resultado = A + B;
            4'b0110: resultado = A - B;
          	4'b0111: resultado = (A < B) ? 32'd1 : 32'd0;
            4'b1010: begin
              
                if (B != 0)
                  resultado = A / B;                   // Divisão (se B != 0)
                else
                    resultado = 32'hFFFFFFFF;          // Resultado padrão para divisão por zero
              
            end
          
            default: resultado = 32'd0;                  // Caso nenhum código seja válido
        endcase
      
    end

    assign zero_flag = (resultado == 0); // Define o zero_flag como verdadeiro se resultado == 0

endmodule
