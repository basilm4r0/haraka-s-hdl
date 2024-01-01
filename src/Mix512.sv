module Mix512 (in, out);
	input [511:0] in;
	output logic [511:0] out;

	parameter NUM_CHUNKS = 512 / 32;

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
