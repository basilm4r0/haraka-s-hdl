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
	output logic [511:0] out;

	always_comb begin
		out = sel ? b : a;
	end
endmodule


module QuadAes (in, clk,out);
	input [511:0] in;
	input clk;
	output [511:0] out;
	parameter NUM_AES = 4;

	genvar i;
	generate
		for (i = 0; i < NUM_AES; i++) begin : aes_gen
			Aes Aes (.in(in [511 - i * 128 : 384 - i * 128]),
				     .clk(clk),
					 .out(out [511 - i * 128 : 384 - i * 128]));
		end
	endgenerate

endmodule


module Aes (in, clk, out);
	input [127:0] in;
	input clk;
	output logic [127:0] out;

	wire [127:0] [10:0] round_keys;
	wire [127:0] [10:0] state;

endmodule


module Mix512 (in, out);
	input [511:0] in;
	output logic [511:0] out;

	parameter NUM_CHUNKS = 16;

	genvar i;
	generate
		for (i = 0; i < NUM_CHUNKS; i++) begin : chunks_gen
			wire [31:0] chunk_in = in [(32 * (i + 1)) - 1 : 32 * i];
		end
	endgenerate

	always_comb begin
		out = {chunks_gen[14].chunk_in,
			   chunks_gen[6].chunk_in,
			   chunks_gen[10].chunk_in,
			   chunks_gen[2].chunk_in,
			   chunks_gen[5].chunk_in,
			   chunks_gen[13].chunk_in,
			   chunks_gen[1].chunk_in,
			   chunks_gen[9].chunk_in,
			   chunks_gen[4].chunk_in,
			   chunks_gen[12].chunk_in,
			   chunks_gen[0].chunk_in,
			   chunks_gen[8].chunk_in,
			   chunks_gen[15].chunk_in,
			   chunks_gen[7].chunk_in,
			   chunks_gen[11].chunk_in,
			   chunks_gen[3].chunk_in};
	end

endmodule


module Demux512 (in, sel, a, b);
	input [511:0] in;
	input sel;
	output logic [511:0] a, b;

	always_comb begin
		a = sel ? 0 : in;
		b = sel ? in : 0;
	end
endmodule
