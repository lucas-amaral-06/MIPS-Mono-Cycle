module sign_extend (
    input [15:0] imm16,
    output [31:0] extended
);
    assign extended = {{16{imm16[15]}}, imm16};
endmodule
