module sign_extend (
  	input  [15:0] a,     // Entrada de 16 bits
    output [31:0] y      // Saída de 32 bits
);
  
    assign y = {{16{a[15]}}, a};
  
endmodule
