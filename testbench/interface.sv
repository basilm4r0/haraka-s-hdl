interface haraka_s_interface(input logic clk);

    // inputs 
    logic [8-1:0]  serial_in;
	logic [64-1:0] digest_length;
	logic enable;
	logic reset;
	
    // outputs
    logic [8-1:0] out;

    
endinterface: haraka_s_interface