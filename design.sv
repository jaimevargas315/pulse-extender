module pulse_extender (clk, in, out,rst);
  input clk, in, rst;
  output out;
  
  reg [5:0] counter;
  
  always @ (posedge clk or posedge rst)
    begin
    if(rst) 
        counter <= 0;
    else begin
    counter[0]<=in;
    counter[1]<=counter[0];
    counter[2]<=counter[1];
    counter[3]<=counter[2];
    counter[4]<=counter[3];
    counter[5]<=counter[4];
  	end
  end

  assign out =
    (counter[0]|counter[1]|counter[2]|counter[3]|counter[4]) & (~counter[5]);
endmodule