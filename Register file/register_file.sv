module register_file (
    input wire clk,
    input wire we,
    input wire [4:0] A1,
    input wire [4:0] A2,
    input wire [4:0] A3,
    input wire [31:0] WD3,
    output wire [31:0] RD1,
    output wire [31:0] RD2,
    output wire [31:0] t0,
    output wire [31:0] t1,
    output wire [31:0] t2,
    output wire [31:0] t3,
    output wire [31:0] s0
);
    reg [31:0] regs [31:0];
    
    assign RD1 = (A1 == 5'd0) ? 32'd0 : regs[A1];
    assign RD2 = (A2 == 5'd0) ? 32'd0 : regs[A2];
    
    assign t0 = regs[8];
    assign t1 = regs[9];
    assign t2 = regs[10];
    assign t3 = regs[11];
    assign s0 = regs[16];
    
    always @(posedge clk) begin
        if (we && A3 != 5'd0) begin
            regs[A3] <= WD3;
        end
    end
endmodule
