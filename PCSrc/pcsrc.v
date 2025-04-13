module PCSrc (
    input Branch,
    input Jump,
    input [31:0] PCPlus4,
    input [31:0] PCBranch,
    input [25:0] JumpImm,
    output [31:0] next_PC
);
    wire [31:0] JumpAddr = {PCPlus4[31:28], JumpImm, 2'b00};
    assign next_PC = Jump ? JumpAddr : (Branch ? PCBranch : PCPlus4);
endmodule
