module PC_Testbench;
    reg clk;
    reg reset;
    wire [31:0] PC;
    
    PC_System uut (
        .clk(clk),
        .reset(reset),
        .PC(PC)
    );
    
    initial begin
        clk = 0;
        reset = 1;
        #10 reset = 0;
    end
    
    always #5 clk = ~clk;
    
    initial begin
        #100;
        $finish;
    end
    
    initial begin
        $monitor("Time: %0t | PC: %d", $time, PC);
    end
endmodule

