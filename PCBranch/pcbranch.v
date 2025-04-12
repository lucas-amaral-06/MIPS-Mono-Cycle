module PCBranch (
    input [31:0] PC,
    input [15:0] immediate,
    output [31:0] PCBranch
);
  
    wire [31:0] extended_immediate = {{14{immediate[15]}}, immediate, 2'b00};
    assign PCBranch = PC + 4 + extended_immediate;
  
endmodule
