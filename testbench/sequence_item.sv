import uvm_pkg::*;
class haraka_s_sequence_item extends uvm_sequence_item();

    // constructor 
    function new (string name = "haraka_s_sequence_item");
        super.new(name);  
    endfunction: new

    // initialization for input 
    rand logic [8-1:0] serial_in;
    rand logic [64-1:0] digest_length;
    rand logic enable;
    rand logic reset;

    // outputs 
    logic [8-1:0] out;

    // uvm registeration macros
    `uvm_object_utils_begin(haraka_s_sequence_item)
        `uvm_field_int(serial_in, UVM_ALL_ON)
        `uvm_field_int(digest_length, UVM_ALL_ON)
        `uvm_field_int(enable, UVM_ALL_ON)
        `uvm_field_int(reset , UVM_ALL_ON)
        `uvm_field_int(out, UVM_ALL_ON)  
    `uvm_object_utils_end

    //TODO:  constrains 



endclass: haraka_s_sequence_item