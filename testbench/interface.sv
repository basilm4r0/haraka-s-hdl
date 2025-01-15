interface haraka_s_interface(input logic clk, input logic bclk; );

    // inputs 
    logic [64-1:0] in;
	logic [64-1:0] d;
	logic enable;
	logic encrypt;
	logic reset;
	
    // outputs
    logic [64-1:0] out;

    
endinterface: haraka_s_interface