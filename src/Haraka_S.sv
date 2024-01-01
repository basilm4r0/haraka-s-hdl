module Haraka_S_Core (in, sel, encrypt, clk, out);
	input [511:0] in;
	input sel, encrypt, clk;
	output logic [511:0] out;
	logic [511:0] mux_out, quad_aes1_out, quad_aes2_out, mix_out, feedback;

	logic [255:0] round_constants [0:1];
	assign round_constants[0] = 256'h0684704ce620c00ab2c5fef075817b9d;
	assign round_constants[1] = 256'h8b66b4e188f3a06b640f6ba42f08f717;

	logic [511:0] rc [0:1];
	assign rc[0] = round_constants[0];
    assign rc[1] = round_constants[1];
	// TODO: implement sponge structure
	// From Yueqin:
	// The sponge construction used in the HarakaS includes two
	// phases: the absorbing phase and the squeezing phase. As
	// shown in Fig. 1, c represents the capacity of the sponge
	// function, and r is the rate. The message N with an arbitrary
	// length is absorbed into the padding function to obtain a string
	// whose length is the positive multiple of r. Then the padded
	// string is divided into a series of r-bit strings, which are XORed
	// with the output states after the f permutation function, and
	// the first state is initialized to 0. After the absorbing process,
	// the output string is squeezed out for the required fixed length
	// through T runcd function, where d is the length of the output
	// digest. In this work, the f permutation function is π512 used
	// in Haraka-512 v2, and the value of c, as well as r, is set to
	// 256 in the sponge construction.

	Mux512 Mux (.a(in), .b(feedback), .sel(sel), .out(mux_out));
	QuadAes QuadAes1 (.in(mux_out), .clk(clk), .round_constant(rc[0]), .encrypt(encrypt), .out(quad_aes1_out));
	QuadAes QuadAes2 (.in(quad_aes1_out), .clk(clk), .round_constant(rc[1]), .encrypt(encrypt), .out(quad_aes2_out));
	Mix512 Mix (.in(quad_aes2_out), .out(mix_out));
	Demux512 Demux (.in(mix_out), .sel(sel), .a(out), .b(feedback));

endmodule
