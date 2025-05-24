class harakas_base_seqs extends uvm_sequence#(harakas_message);
    
    `uvm_object_utils(harakas_base_seqs)

  // Constructor
    function new(string name = "all_min_one_max_kernel");
        super.new(name);
    endfunction : new

    task pre_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
        // in UVM1.2, get starting phase from method
            phase = get_starting_phase();
        `else
            phase = starting_phase;
        `endif
            if (phase != null) begin
            phase.raise_objection(this, get_type_name());
        `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
        end
    endtask : pre_body

    task post_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
        // in UVM1.2, get starting phase from method
            phase = get_starting_phase();
        `else
            phase = starting_phase;
        `endif
        if (phase != null) begin
            #10; // or wait for `done` signal from DUT
            phase.drop_objection(this, get_type_name());
            `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
        end
    endtask : post_body
    
endclass: harakas_base_seqs

//------------------------------------------------------------------------------
// SEQUENCE: reset_seq sequence 
//------------------------------------------------------------------------------


class reset_seq extends harakas_base_seqs;
    `uvm_object_utils(reset_seq)

    function new(string name="reset_seq");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "Executing reset_seq", UVM_LOW)
        `uvm_do_with(req, {req.reset == 1; req.enable == 0; req.process_input == 0; req.digest_length == 0; req.serial_in == 8'd0;})
    endtask
endclass : reset_seq

//------------------------------------------------------------------------------
// SEQUENCE: send_hello_seq sequence 
//------------------------------------------------------------------------------

class send_hello_seq extends harakas_base_seqs;
    `uvm_object_utils(send_hello_seq)

    function new(string name="send_hello_seq");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "Sending 'Hello' characters", UVM_LOW)
        // Enable and start input
        `uvm_do_with(req, {req.enable == 1; req.serial_in == 8'h48; req.process_input == 1; req.digest_length == 64'd32; req.reset == 0;}) // H
        `uvm_do_with(req, {req.enable == 1; req.serial_in == 8'h65; req.process_input == 1; req.digest_length == 64'd32; req.reset == 0;}) // e
        `uvm_do_with(req, {req.enable == 1; req.serial_in == 8'h6c; req.process_input == 1; req.digest_length == 64'd32; req.reset == 0;}) // l
        `uvm_do_with(req, {req.enable == 1; req.serial_in == 8'h6c; req.process_input == 1; req.digest_length == 64'd32; req.reset == 0;}) // l
        `uvm_do_with(req, {req.enable == 1; req.serial_in == 8'h6f; req.process_input == 1; req.digest_length == 64'd32; req.reset == 0;}) // o
    endtask
endclass :send_hello_seq

//------------------------------------------------------------------------------
// SEQUENCE: reset and hello sequences
//------------------------------------------------------------------------------

class hello_message_seq extends harakas_base_seqs;

  // Required macro for sequences automation
    `uvm_object_utils(hello_message_seq)
    // Reset first
    reset_seq reset_s;
    
    // Send hello message
    send_hello_seq hello_s;

    // Constructor
    function new(string name="hello_message_seq");
        super.new(name);
    endfunction

    // Sequence body definition
    virtual task body();    
        `uvm_info(get_type_name(), "Executing hello_message_seq sequence", UVM_LOW)
        `uvm_do(reset_s)
        `uvm_do(hello_s)
        // Finish sequence
        `uvm_do(reset_s)
    endtask

endclass : hello_message_seq


