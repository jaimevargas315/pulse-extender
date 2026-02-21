module pulse_extender_tb;
  reg clk, in, rst;
  wire out;
  
  pulse_extender dut(
    .in(in),
    .clk(clk),
    .out(out),
    .rst(rst)
  );
  
  always #2 clk = ~clk;
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
    
    clk = 0;
    in = 0;
    rst = 1;
    #5 rst = 0;
    #10 in = 1;
    #10 in = 0;
    #20 in = 1;
    #5 in = 0;
    
    #50 $finish;
  end
endmodule