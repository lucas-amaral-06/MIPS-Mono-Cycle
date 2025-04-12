// Code used to implement Multiplexer for 5 bits, since MIPS has multiplexers both for 32 and 5 bits.

module MUX5bits(
  input wire [4:0] A,
  input wire [4:0] B,
  input wire       sel,
  output wire [4:0] Y
);

  assign Y = (sel) ? B : A;

endmodule


