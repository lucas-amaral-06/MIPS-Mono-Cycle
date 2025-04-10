`timescale 1ns / 1ps

module ShiftLeft2_tb;

    // Inputs and outputs
    reg [31:0] in;
    wire [31:0] out;

    // Instantiate the module under test (UUT)
    ShiftLeft2 uut (
        .in(in),
        .out(out)
    );

    initial begin
        $display("Testing ShiftLeft2 (input << 2):");
        
        // Test 1
        in = 32'd1;
        #10;
        $display("in = %d, out = %d (expected: %d)", in, out, in << 2);

        // Test 2
        in = 32'd4;
        #10;
        $display("in = %d, out = %d (expected: %d)", in, out, in << 2);

        // Test 3
        in = 32'd255;
        #10;
        $display("in = %d, out = %d (expected: %d)", in, out, in << 2);

        // Test 4 (negative value)
        in = -32'd8;
        #10;
        $display("in = %d, out = %d (expected: %d)", in, out, in << 2);

        // End of simulation
        $finish;
    end

endmodule