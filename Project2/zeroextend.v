module zeroextend(in1,out1);
input [15:0] in1;
assign in2 = 0;
output [31:0] out1;
assign 	 out1 = {{ 16 {in2}}, in1};
endmodule
