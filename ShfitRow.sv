// vcs -sverilog  haraka-s.sv
//Implment the shift row operation of the AES round function

/*
    assume the input is a 16x16 byte matrix
    input:          output: 
    87 F2 4D 97 ---> 87 F2 4D 97
    EC 6E 4C 90 ---> 6E 4C 90 EC
    4A C3 46 E7 ---> 46 E7 4A C3
    8C D8 95 A6 ---> A6 8C D8 95 
*/


module ShiftRow (
    input logic [127:0] in,
    output logic [127:0] out
);

    always_comb begin
        // 1st row unchanged
        out[127:96] = in[127:96];
        // 2nd row 1-byte circular left shift 
        out[95:64] = (in[95:64] << 8) | (in[95:64] >> 24);
        // 3rd row 2-byte circular left shift 
        out[63:32] = (in[63:32] << 16) | (in[63:32] >> 16);
        // 4th row 3-byte circular left shift 
        out[31:0] = (in[31:0] << 24) | (in[31:0] >> 8);
    end

endmodule
