module Haraka (in, rc, clk, out, output_ready, reset);
	input [511:0] in;
	input [127:0] rc [0:7];
	input clk;
	input reset;
	output logic [511:0] out;
	output logic output_ready;
	wire [511:0] mux_out, quad_aes1_out, quad_aes2_out, mix_out, feedback;
	logic [2:0] round_counter;
	wire sel;

	always_ff @(posedge clk or posedge reset) begin
		if (reset) begin
			round_counter <= 0;
			output_ready <= 0;
		end
		else begin
			if (round_counter < 4) begin
				round_counter <= round_counter + 1;
			end
			else begin
				round_counter <= 0;
				output_ready <= 1;
			end
		end
	end

	assign sel = (round_counter < 4)? 0: 1;

	Mux512 Mux (.a(in), .b(feedback), .sel(sel), .out(mux_out));
	QuadAes QuadAes1 (.in(mux_out), .clk(clk), .reset(reset), .round_constant({rc[7], rc[6], rc[5], rc[4]}), .out(quad_aes1_out));
	QuadAes QuadAes2 (.in(quad_aes1_out), .clk(clk), .reset(reset), .round_constant({{rc[3], rc[2], rc[1], rc[0]}}), .out(quad_aes2_out));
	Mix512 Mix (.in(quad_aes2_out), .out(mix_out));
	Demux512 Demux (.in(mix_out), .sel(sel), .a(out), .b(feedback));

endmodule
