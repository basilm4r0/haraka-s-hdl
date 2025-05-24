class harakas_message extends uvm_sequence_item();

    // initialization for input 
    rand logic [8-1:0] serial_in;
    rand logic [64-1:0] digest_length;
    rand logic process_input;
    rand logic enable;
    rand logic reset;

    // outputs 
    logic [8-1:0] out;

    // uvm registeration macros
    `uvm_object_utils_begin(harakas_message)
        `uvm_field_int(serial_in, UVM_ALL_ON)
        `uvm_field_int(digest_length, UVM_ALL_ON)
        `uvm_field_int(process_input, UVM_ALL_ON)
        `uvm_field_int(enable, UVM_ALL_ON)
        `uvm_field_int(reset , UVM_ALL_ON)
        `uvm_field_int(out, UVM_ALL_ON)  
    `uvm_object_utils_end


    // constructor 
    function new (string name = "harakas_message");
        super.new(name);  
    endfunction: new

    //TODO:  constrains 
    // this is for certain use
    // constraint reset_singal  {reset == 0;}
    // constraint enable_singal {enable == 1;}



endclass: harakas_message
