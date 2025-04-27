module Register (in, round_constant_in, clk, reset, out, round_constant_out);
	input [127:0] in;
	input [127:0] round_constant_in;
	input clk;
	input reset;
	output logic [127:0] out;
	output logic [127:0] round_constant_out;

	always_ff @(posedge clk or posedge reset) begin
		if (reset) begin
			out <= 0;
			round_constant_out <= 0;
		end
		else begin
			out <= in;
			round_constant_out <= round_constant_in;
		end
	end
endmodule
