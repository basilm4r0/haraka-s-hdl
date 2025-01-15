class haraka_s_sequence_item extends uvm_sequence_item();

    // constructor 
    function new (string name = "haraka_s_sequence_item");
        super.new(name);  
    endfunction: new

    // initialization for input 
    rand logic [64-1:0] in;
    rand logic [64-1:0] d;
    rand logic enable;
    rand logic encrypt;
    rand logic reset;

    // outputs 
    logic [64-1:0] out;

    // uvm registeration macros
    `uvm_object_utils_begin(haraka_s_sequence_item)
        `uvm_field_int(in, UVM_ALL_ON)
        `uvm_field_int(d, UVM_ALL_ON)
        `uvm_field_int(enable, UVM_ALL_ON)
        `uvm_field_int(encrypt, UVM_ALL_ON)
        `uvm_field_int(reset , UVM_ALL_ON)
        `uvm_field_int(out, UVM_ALL_ON)  
    `uvm_object_utils_end

    //TODO:  constrains 



endclass: haraka_s_sequence_item