module PC_Register(
    input clk,
    input reset,
    input [31:0] next_PC,
    output reg [31:0] PC
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            PC <= 32'b0;
        else
            PC <= next_PC;
    end
endmodule

module PC_Adder(
    input [31:0] PC,
    output [31:0] next_PC
);
    assign next_PC = PC + 32'd4;
endmodule

module PC_System(
    input clk,
    input reset,
    output [31:0] PC
);
    wire [31:0] next_PC;
    
    PC_Register pc_reg (
        .clk(clk),
        .reset(reset),
        .next_PC(next_PC),
        .PC(PC)
    );
    
    PC_Adder pc_adder (
        .PC(PC),
        .next_PC(next_PC)
    );
endmodule
