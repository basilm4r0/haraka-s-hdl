import harakas_pkg::*;
`include "uvm_macros.svh"

import uvm_pkg::*;

interface harakas_if(input logic clk);

    // inputs 
    logic [8-1:0]  serial_in;
	logic [64-1:0] digest_length;
    logic process_input;
	logic enable;
	logic reset;
	
    // outputs
    logic [8-1:0] out;



    
endinterface: harakas_if