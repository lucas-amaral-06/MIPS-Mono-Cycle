module register_file (
    input clk,
    input we,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD3,
    output [31:0] RD1,
    output [31:0] RD2,
    output [31:0] t0,  // $8
    output [31:0] t1,  // $9
    output [31:0] t2,  // $10
    output [31:0] t3   // $11
);

    reg [31:0] regs [31:0];
    
    assign RD1 = (A1 == 5'd0) ? 32'd0 : regs[A1];
    assign RD2 = (A2 == 5'd0) ? 32'd0 : regs[A2];
    
    // Conexões diretas para os registradores monitorados
    assign t0 = regs[8];
    assign t1 = regs[9];
    assign t2 = regs[10];
    assign t3 = regs[11];
    
    always @(posedge clk) begin
        if (we && A3 != 5'd0) begin
            regs[A3] <= WD3;
        end
    end
endmodule
