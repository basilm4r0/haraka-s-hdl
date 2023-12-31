module MixColumns (
  input logic [127:0] in_data,
  output logic [127:0] out_data
);

  always_comb begin

    // Extract each column from the input
    logic [7:0] col[4][4];
    for (int i = 0; i < 4; i++) begin
      col[0][i] = in_data[127 - i*32 -: 8]; // extract the 1st column
      col[1][i] = in_data[119 - i*32 -: 8]; // extract the 2nd column
      col[2][i] = in_data[111 - i*32 -: 8]; // extract the 3ed column
      col[3][i] = in_data[103 - i*32 -: 8]; // extract the 4th column
    end

    // Perform MixColumns operation on each column
    for (int i = 0; i < 4; i++) begin
      // Declare variables for each term in the mix column operation
      logic [7:0] a, b, c, d;

      // Assign values to variables
      a = col[0][i];
      b = col[1][i];
      c = col[2][i];
      d = col[3][i];

      // Perform Galois Field multiplication and XOR operations
      col[0][i] = mb2(a) ^ mb3(b) ^ c ^ d;
      col[1][i] = a ^ mb2(b) ^ mb3(c) ^ d;
      col[2][i] = a ^ b ^ mb2(c) ^ mb3(d);
      col[3][i] = mb3(a) ^ b ^ c ^ mb2(d);
    end

    // Combine the columns to produce the output
    out_data = {col[0][0], col[1][0], col[2][0], col[3][0],
                col[0][1], col[1][1], col[2][1], col[3][1],
                col[0][2], col[1][2], col[2][2], col[3][2],
                col[0][3], col[1][3], col[2][3], col[3][3]};
  end

function [7:0] mb2; //multiply by 2
	input [7:0] x;
	begin
			/* multiplication by 2 is shifting on bit to the left, and if the original 8 bits had a 1 @ MSB,
			xor the result with {1b}*/
			if(x[7] == 1) mb2 = ((x << 1) ^ 8'h1b);
			else mb2 = x << 1;
	end
endfunction


/*
	multiplication by 3 is done by:
		multiplication by {02} xor(the original x)
		so that 2+1=3. where xor is the addition of elements in finite fields
*/
function [7:0] mb3; //multiply by 3
	input [7:0] x;
	begin

			mb3 = mb2(x) ^ x;
	end
endfunction
endmodule
