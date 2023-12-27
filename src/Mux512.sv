module Mux512 (a, b, sel, out);
	input [511:0] a, b;
	input sel;
	output logic [511:0] out;

	always_comb begin
		out = sel ? b : a;
	end
endmodule
