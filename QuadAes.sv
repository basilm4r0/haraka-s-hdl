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
