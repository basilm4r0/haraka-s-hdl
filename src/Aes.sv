module Aes (in, clk, encrypt, round_constant, out);
	input [127:0] in;
	input [127:0] round_constant;
	input clk, encrypt;
	output logic [127:0] out;

	wire [127:0] w1, w2, w3, w4;

	S_box S_box (.in(in), .encrypt(encrypt), .out(w1));
	Register Register (.in(w1), .clk(clk), .out(w2));
	ShiftRows ShiftRows (.in(w2), .out(w3));
	MixColumns MixColumns (.in_data(w3), .out_data(w4));
	AddRC AddRC (.data(w4), .round_constant(round_constant), .out(out));

endmodule
