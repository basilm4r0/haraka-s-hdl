module Haraka_S (serial_in, process_input, digest_length, enable, clk, reset, out);
	input [8-1:0] serial_in;
    input process_input;
	input [64-1:0] digest_length;
	input enable;
	input clk;
	input reset;
	output logic [8-1:0] out;

	wire gated_clk;
	assign gated_clk = clk && enable;

	wire internal_clk;
	logic [256-1:0] padded;
	logic [256-1:0] rate;
	logic [256-1:0] capacity;
	wire [512-1:0] haraka_out;
	wire [512-1:0] haraka_in;
	logic [3:0] round;
	logic [127:0] rc [7:0];
	logic [255:0] serializer_input;
	logic [58:0] counter;
	wire output_ready;
	wire start_squeeze;
	logic [5:0] serializer_length;
	logic [127:0] round_constants [39:0];
	wire deserialized_output_ready;

	deserializer deserializer (.serial_in(serial_in), .process_input(process_input), .clk(gated_clk), .out(padded), .outclk(internal_clk), .clear(reset), .output_ready(deserialized_output_ready), .start_squeeze(start_squeeze));
	Haraka Haraka (.in(haraka_in), .rc(rc), .clk(internal_clk), .out(haraka_out), .reset(reset), .output_ready(output_ready));
	serializer serializer (.in(serializer_input), .length(serializer_length), .bclk(gated_clk), .clk(internal_clk), .reset(reset), .serial_out(out));

	always_ff @(posedge internal_clk, posedge reset) begin
		if (reset) begin
			rate <= 0;
			capacity <= 0;
			round <= 0;
			counter <= 0;
		end
		else begin
			if (output_ready) begin
				rate <= haraka_out[511:256];
				capacity <= haraka_out[255:0];
			end
			if (start_squeeze || (counter != 0)) begin
				counter <= counter + 1;
				if (counter < digest_length>>5) begin
					serializer_input <= rate;
					serializer_length <= 32;
				end
				else if (counter < (digest_length>>5 + (digest_length[4:0] != 0))) begin // counter < # of blocks needed to contain digest length
					serializer_input <= rate;
					serializer_length <= digest_length[5:0];
				end
				else
					serializer_input <= 0;
			end
		end
	end

	assign haraka_in = {rate^padded, capacity};

	always_comb begin
			rc = {round_constants[round*8+7],
				  round_constants[round*8+6],
				  round_constants[round*8+5],
				  round_constants[round*8+4],
				  round_constants[round*8+3],
				  round_constants[round*8+2],
				  round_constants[round*8+1],
				  round_constants[round*8]};
	end

	
	assign round_constants[0]  = 128'h0684704ce620c00ab2c5fef075817b9d;
	assign round_constants[1]  = 128'h8b66b4e188f3a06b640f6ba42f08f717;
	assign round_constants[2]  = 128'h3402de2d53f28498cf029d609f029114;
	assign round_constants[3]  = 128'h0ed6eae62e7b4f08bbf3bcaffd5b4f79;
	assign round_constants[4]  = 128'hcbcfb0cb4872448b79eecd1cbe397044;
	assign round_constants[5]  = 128'h7eeacdee6e9032b78d5335ed2b8a057b;
	assign round_constants[6]  = 128'h67c28f435e2e7cd0e2412761da4fef1b;
	assign round_constants[7]  = 128'h2924d9b0afcacc07675ffde21fc70b3b;
	assign round_constants[8]  = 128'hab4d63f1e6867fe9ecdb8fcab9d465ee;
	assign round_constants[9]  = 128'h1c30bf84d4b7cd645b2a404fad037e33;
	assign round_constants[10] = 128'hb2cc0bb9941723bf69028b2e8df69800;
	assign round_constants[11] = 128'hfa0478a6de6f55724aaa9ec85c9d2d8a;
	assign round_constants[12] = 128'hdfb49f2b6b772a120efa4f2e29129fd4;
	assign round_constants[13] = 128'h1ea10344f449a23632d611aebb6a12ee;
	assign round_constants[14] = 128'haf0449884b0500845f9600c99ca8eca6;
	assign round_constants[15] = 128'h21025ed89d199c4f78a2c7e327e593ec;
	assign round_constants[16] = 128'hbf3aaaf8a759c9b7b9282ecd82d40173;
	assign round_constants[17] = 128'h6260700d6186b01737f2efd910307d6b;
	assign round_constants[18] = 128'h5aca45c22130044381c29153f6fc9ac6;
	assign round_constants[19] = 128'h9223973c226b68bb2caf92e836d1943a;
	assign round_constants[20] = 128'hd3bf9238225886eb6cbab958e51071b4;
	assign round_constants[21] = 128'hdb863ce5aef0c677933dfddd24e1128d;
	assign round_constants[22] = 128'hbb606268ffeba09c83e48de3cb2212b1;
	assign round_constants[23] = 128'h734bd3dce2e4d19c2db91a4ec72bf77d;
	assign round_constants[24] = 128'h43bb47c361301b434b1415c42cb3924e;
	assign round_constants[25] = 128'hdba775a8e707eff603b231dd16eb6899;
	assign round_constants[26] = 128'h6df3614b3c7559778e5e23027eca472c;
	assign round_constants[27] = 128'hcda75a17d6de7d776d1be5b9b88617f9;
	assign round_constants[28] = 128'hec6b43f06ba8e9aa9d6c069da946ee5d;
	assign round_constants[29] = 128'hcb1e6950f957332ba25311593bf327c1;
	assign round_constants[30] = 128'h2cee0c7500da619ce4ed0353600ed0d9;
	assign round_constants[31] = 128'hf0b1a5a196e90cab80bbbabc63a4a350;
	assign round_constants[32] = 128'hae3db1025e962988ab0dde30938dca39;
	assign round_constants[33] = 128'h17bb8f38d554a40b8814f3a82e75b442;
	assign round_constants[34] = 128'h34bb8a5b5f427fd7aeb6b779360a16f6;
	assign round_constants[35] = 128'h26f65241cbe5543843ce5918ffbaafde;
	assign round_constants[36] = 128'h4ce99a54b9f3026aa2ca9cf7839ec978;
	assign round_constants[37] = 128'hae51a51a1bdff7be40c06e2822901235;
	assign round_constants[38] = 128'ha0c1613cba7ed22bc173bc0f48a659cf;
	assign round_constants[39] = 128'h756acc03022882884ad6bdfde9c59da1;


endmodule
