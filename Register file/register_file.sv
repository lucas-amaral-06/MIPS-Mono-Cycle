module register_file (
    input clk,               // Clock signal
    input we,                // Write Enable
    input [4:0] A1,          // Read address 1
    input [4:0] A2,          // Read address 2
    input [4:0] A3,          // Write address
    input [31:0] WD3,        // Data to be written
    output [31:0] RD1,       // Data read from A1
    output [31:0] RD2        // Data read from A2
);

    // Declare 32 registers, each 32 bits wide
    reg [31:0] regs [31:0];

    // Asynchronous read logic
    assign RD1 = (A1 == 5'd0) ? 32'd0 : regs[A1];
    assign RD2 = (A2 == 5'd0) ? 32'd0 : regs[A2];

    // Synchronous write on rising clock edge
    always @(posedge clk) begin
        if (we && A3 != 5'd0) begin
            regs[A3] <= WD3;
        end
    end

endmodule
