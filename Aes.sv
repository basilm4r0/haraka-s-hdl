module Aes (in, clk, out);
	input [127:0] in;
	input clk;
	output logic [127:0] out;

	wire [127:0] round_constant;
	wire [127:0] w1, w2, w3, w4;

	S_box S_box (.in(in), .out(w1));
	Register Register (.in(w1), .clk(clk), .out(w2));
	ShiftRow ShiftRow (.in(w2), .out(w3));
	MixColumn MixColumn (.in(w3), .out(w4));
	Xor128 Xor128 (.a(w4), .b(round_constant), .out(out));

endmodule
