// Code used to implement Multiplexer for 32 bits, since MIPS has multiplexers both for 32 and 5 bits.

module Mux2to1_32bits (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire        Sel,
    output wire [31:0] Out
);
    assign Out = Sel ? B : A;
endmodule