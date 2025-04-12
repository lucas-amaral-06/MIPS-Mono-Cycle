module tb_sig_extend;
    reg  [15:0] a;
    wire [31:0] y;

  sign_extend uut (.a(a), .y(y));

    initial begin
      $monitor("Time = %0t | Input = %16b | Out = %32b", $time, a, y);

        a = 16'b0000000000000000;
      	#10;
        a = 16'b0000000000000001;
      	#10;
        a = 16'b1000000000000000;
      	#10;
        a = 16'b1111111111111111;
      	#10;
        a = 16'b0111111111111111;
      	#10;
      
        $finish;
      
    end
  
endmodule
