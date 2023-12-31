module Register (in, clk, out);
	input [127:0] in;
	input clk;
	output logic [127:0] out;

	always_ff @(posedge clk) begin
		out <= in;
	end
endmodule
