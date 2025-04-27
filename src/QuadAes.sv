module QuadAes (in, clk, reset, round_constant, out);
	input [511:0] in, round_constant;
	input clk;
	input reset;
	output [511:0] out;

	genvar i;
	generate
		for (i = 511; i > 0; i -= 128) begin : aes_gen
			Aes Aes (.in(in [i -: 128]),
			         .clk(clk),
					 .reset(reset),
					 .round_constant(round_constant [i -: 128]),
			         .out(out [i -: 128]));
		end
	endgenerate

endmodule
