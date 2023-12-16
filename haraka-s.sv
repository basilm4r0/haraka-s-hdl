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


module QuadAesAlt (in, clk, out);
	input [511:0] in;
	input clk;
	output [511:0] out;

	Aes Aes1 (.in(in [511:384]), .clk(clk), .out(out [511:384]));
	Aes Aes2 (.in(in [383:256]), .clk(clk), .out(out [383:256]));
	Aes Aes3 (.in(in [255:128]), .clk(clk), .out(out [255:128]));
	Aes Aes4 (.in(in [127:0]), .clk(clk), .out(out [127:0]));

endmodule


module Mix512 (in, out);
	input [511:0] in;
	output logic [511:0] out;

	wire [15:0] [31:0] bytes_in;

	// {bytes_in [0], bytes_in [1], bytes_in [2], bytes_in [3],
	//  bytes_in [4], bytes_in [5], bytes_in [6], bytes_in [7],
	//  bytes_in [0], bytes_in [1], bytes_in [2], bytes_in [3],
    //  bytes_in [4], bytes_in [5], bytes_in [6], bytes_in [7]} = in;
endmodule


module Demux512 (in, sel, a, b);
	input [511:0] in;
	input sel;
	output logic [511:0] a, b;

	wire [127:0] [10:0] round_keys;
	wire [127:0] [10:0] state;

always_comb begin
		a = sel ? 0 : in;
		b = sel ? in : 0;
	end
endmodule
