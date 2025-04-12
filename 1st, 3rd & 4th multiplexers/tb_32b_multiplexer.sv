`timescale 1ns / 1ps

module TestMux;

    reg [31:0] A;
    reg [31:0] B;
    reg        Sel;
    wire [31:0] Out;

    Mux2to1_32bits uut (
        .A(A),
        .B(B),
        .Sel(Sel),
        .Out(Out)
    );

    initial begin
        $display("Starting MUX testbench...\n");

        // Test 1: Sel = 0
        A = 32'hDEADBEEF;
        B = 32'hCAFEBABE;
        Sel = 0;
        #10;
        $display("Test 1 - Sel = 0: Out = %h (expected: %h)", Out, A);

        // Test 2: Sel = 1
        Sel = 1;
        #10;
        $display("Test 2 - Sel = 1: Out = %h (expected: %h)", Out, B);

        // Test 3: Different values
        A = 32'h12345678;
        B = 32'h87654321;
        Sel = 0;
        #10;
        $display("Test 3 - Sel = 0: Out = %h (expected: %h)", Out, A);

        // Test 4: Sel = 1
        Sel = 1;
        #10;
        $display("Test 4 - Sel = 1: Out = %h (expected: %h)", Out, B);

        // Test 5: A and B both 0
        A = 32'h00000000;
        B = 32'h00000000;
        Sel = 0;
        #10;
        $display("Test 5 - Sel = 0, both zero: Out = %h (expected: 00000000)", Out);

        Sel = 1;
        #10;
        $display("Test 6 - Sel = 1, both zero: Out = %h (expected: 00000000)", Out);

        // Test 7: A and B both all ones
        A = 32'hFFFFFFFF;
        B = 32'hFFFFFFFF;
        Sel = 0;
        #10;
        $display("Test 7 - Sel = 0, both all ones: Out = %h (expected: FFFFFFFF)", Out);

        Sel = 1;
        #10;
        $display("Test 8 - Sel = 1, both all ones: Out = %h (expected: FFFFFFFF)", Out);

        // Test 9: A == B, random value
        A = 32'hFACEFACE;
        B = 32'hFACEFACE;
        Sel = 0;
        #10;
        $display("Test 9 - Sel = 0, A == B: Out = %h (expected: %h)", Out, A);

        Sel = 1;
        #10;
        $display("Test 10 - Sel = 1, A == B: Out = %h (expected: %h)", Out, B);

        // Test 11: Rapid toggle
        A = 32'hAAAAAAAA;
        B = 32'h55555555;

        Sel = 0; #5;
        $display("Test 11a - Sel = 0: Out = %h (expected: %h)", Out, A);

        Sel = 1; #5;
        $display("Test 11b - Sel = 1: Out = %h (expected: %h)", Out, B);

        Sel = 0; #5;
        $display("Test 11c - Sel = 0: Out = %h (expected: %h)", Out, A);

        // (Optional) Test 12: Force X on Sel
        Sel = 1'bx;
        #10;
        $display("Test 12 - Sel = X: Out = %h (expected: undefined)", Out);

        $display("\nExtended tests completed.");
        $finish;
    end

endmodule
