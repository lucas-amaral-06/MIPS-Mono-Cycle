module testbench;

    // Test signals
    reg clk;
    reg we;
    reg [4:0] A1, A2, A3;
    reg [31:0] WD3;
    wire [31:0] RD1, RD2;

    // Instantiate the module
    register_file uut (
        .clk(clk),
        .we(we),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD3(WD3),
        .RD1(RD1),
        .RD2(RD2)
    );

    // Clock: toggles every 5 time units
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Initialization
        we = 0;
        A1 = 5'd0;
        A2 = 5'd0;
        A3 = 5'd0;
        WD3 = 32'd0;

        $display("=== Starting Register File Tests ===");

        // Wait a bit before starting
        #10;

        // Attempt to write to register $0 (should be ignored)
        we = 1;
        A3 = 5'd0;
        WD3 = 32'hDEADBEEF;
        #10;
        we = 0;
        A1 = 5'd0;
        #1;
        $display("Attempted to write to $0. Expected RD1 = 0. RD1 = %h", RD1);

        // Write to register 5
        we = 1;
        A3 = 5'd5;
        WD3 = 32'hCAFEBABE;
        #10;
      
        // Read from register 5
        we = 0;
        A1 = 5'd5;
        #1;
        $display("Reading register 5. Expected RD1 = CAFEBABE. RD1 = %h", RD1);

        // Simultaneous read from $0 and register 5
        A1 = 5'd0;
        A2 = 5'd5;
        #1;
        $display("Reading $0 and $5. Expected RD1 = 0, RD2 = CAFEBABE. RD1 = %h, RD2 = %h", RD1, RD2);

        // Write to register 10
        we = 1;
        A3 = 5'd10;
        WD3 = 32'h12345678;
        #10;

        // Read from register 10
        we = 0;
        A1 = 5'd10;
        #1;
        $display("Reading register 10. Expected RD1 = 12345678. RD1 = %h", RD1);

        $display("=== End of Tests ===");
      
        // Simultaneous read from registers 5 and 10
        A1 = 5'd5;
        A2 = 5'd10;
        #1;
        $display("Reading $5 and $10. Expected RD1 = CAFEBABE, RD2 = 12345678. RD1 = %h, RD2 = %h", RD1, RD2);
      
        $display("=== End of Tests ===");
        $finish;
    end

endmodule
