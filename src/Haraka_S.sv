module Haraka_S_Core (in, sel, clk, out);
	input [511:0] in;
	input sel, clk;
	output logic [511:0] out;
	logic [511:0] mux_out, quad_aes1_out, quad_aes2_out, mix_out, feedback;

	Mux512 Mux (.a(in), .b(feedback), .sel(sel), .out(mux_out));
	QuadAes QuadAes1 (.in(mux_out), .clk(clk), .out(quad_aes1_out));
	QuadAes QuadAes2 (.in(quad_aes1_out), .clk(clk), .out(quad_aes2_out));
	Mix512 Mix (.in(quad_aes2_out), .out(mix_out));
	Demux512 Demux (.in(mix_out), .sel(sel), .a(out), .b(feedback));

endmodule
