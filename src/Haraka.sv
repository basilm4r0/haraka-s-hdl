module Haraka (in, rc, sel, encrypt, clk, out);
	input [511:0] in;
	input [127:0] rc [0:7];
	input sel, encrypt, clk;
	output logic [511:0] out;
	logic [511:0] mux_out, quad_aes1_out, quad_aes2_out, mix_out, feedback;


	Mux512 Mux (.a(in), .b(feedback), .sel(sel), .out(mux_out));
	QuadAes QuadAes1 (.in(mux_out), .clk(clk), .round_constant({rc[7], rc[6], rc[5], rc[4]}), .encrypt(encrypt), .out(quad_aes1_out));
	QuadAes QuadAes2 (.in(quad_aes1_out), .clk(clk), .round_constant({{rc[3], rc[2], rc[1], rc[0]}}), .encrypt(encrypt), .out(quad_aes2_out));
	Mix512 Mix (.in(quad_aes2_out), .out(mix_out));
	Demux512 Demux (.in(mix_out), .sel(sel), .a(out), .b(feedback));

endmodule
