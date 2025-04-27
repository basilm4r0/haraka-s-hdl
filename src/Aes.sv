module Aes (in, clk, reset, round_constant, out);
	input [127:0] in;
	input [127:0] round_constant;
	input clk;
	input reset;
	output logic [127:0] out;

	wire [127:0] w1, w2, w3, w4, w5;

	S_box S_box (.in(in), .encrypt(1), .out(w1));
	Register Register (.in(w1), .round_constant_in(round_constant), .clk(clk), .reset(reset), .out(w2), .round_constant_out(w5));
	ShiftRows ShiftRows (.in(w2), .out(w3));
	MixColumns MixColumns (.in_data(w3), .out_data(w4));
	AddRC AddRC (.data(w4), .round_constant(w5), .out(out));

endmodule
