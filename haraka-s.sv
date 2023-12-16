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


module Mux512 (a, b, sel, out);
	input [511:0] a, b;
	input sel;
	output [511:0] out;

always_comb begin
		out = sel ? b : a;
	end
endmodule


module QuadAes (in, clk, out);
	input [511:0] in;
	input clk;
	output [511:0] out;
	wire [127:0] aes1_in, aes2_in, aes3_in, aes4_in;

	Aes Aes1 (.in(in [511:383]), .clk(clk), .out(out [511:383]));
	Aes Aes2 (.in(in [382:256]), .clk(clk), .out(out [382:256]));
	Aes Aes3 (.in(in [255:128]), .clk(clk), .out(out [255:128]));
	Aes Aes4 (.in(in [127:0]), .clk(clk), .out(out [127:0]));

endmodule
