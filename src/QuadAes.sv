module QuadAes (in, clk, encrypt, round_constant, out);
	input [511:0] in;
	input clk, encrypt;
	output [511:0] out;

	genvar i;
	generate
		for (i = 511; i > 0; i -= 128) begin : aes_gen
			Aes Aes (.in(in [i -: 128]),
			         .clk(clk),
					 .encrypt(encrypt),
					 .round_constant(round_constant),
			         .out(out [i -: 128]));
		end
	endgenerate

endmodule
