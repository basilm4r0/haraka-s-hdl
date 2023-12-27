module Demux512 (in, sel, a, b);
	input [511:0] in;
	input sel;
	output logic [511:0] a, b;

	always_comb begin
		a = sel ? 0 : in;
		b = sel ? in : 0;
	end
endmodule
