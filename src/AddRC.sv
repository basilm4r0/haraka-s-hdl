module AddRC (data, round_constant, out);
	input [127:0] data, round_constant;
	output logic [127:0] out;

	always_comb begin
		out = data ^ round_constant;
	end
endmodule
