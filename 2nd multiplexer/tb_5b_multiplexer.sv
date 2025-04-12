`timescale 1ns / 1ps

module MUX5bits_tb;

  // Inputs (declared as regs in the testbench)
  reg [4:0] A;
  reg [4:0] B;
  reg       sel;

  // Output (declared as wire)
  wire [4:0] Y;

  // Instantiate the Unit Under Test (UUT)
  MUX5bits uut (
    .A(A),
    .B(B),
    .sel(sel),
    .Y(Y)
  );

  // Initial stimulus block
  initial begin
    $display("Time | sel |   A   |   B   |   Y");
    $display("-------------------------------");

    // Test 1: sel = 0, Y should equal A
    A = 5'b00001;
    B = 5'b11111;
    sel = 0;
    #10 $display("%4dns |  %b  | %b | %b | %b", $time, sel, A, B, Y);

    // Test 2: sel = 1, Y should equal B
    sel = 1;
    #10 $display("%4dns |  %b  | %b | %b | %b", $time, sel, A, B, Y);

    // Test 3: change A and B values
    A = 5'b10101;
    B = 5'b01010;
    sel = 0;
    #10 $display("%4dns |  %b  | %b | %b | %b", $time, sel, A, B, Y);

    sel = 1;
    #10 $display("%4dns |  %b  | %b | %b | %b", $time, sel, A, B, Y);

    // End simulation
    $finish;
  end

endmodule
