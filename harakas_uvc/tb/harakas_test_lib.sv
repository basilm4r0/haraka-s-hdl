class base_test extends uvm_test;
    // component macro
    `uvm_component_utils(base_test)

    harakas_env env;

    // component constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // UVM build_phase()
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_int::set( this, "*", "recording_detail", 1);
        env = harakas_env::type_id::create("env", this);
    endfunction : build_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction : end_of_elaboration_phase

    // start_of_simulation added for lab03
    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH);
    endfunction : start_of_simulation_phase

    function void check_phase(uvm_phase phase);
        // configuration checker
        check_config_usage();
    endfunction

endclass : base_test

class hello_message_test extends base_test;
    // component macro
    `uvm_component_utils(hello_message_test)

    // component constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_wrapper::set(this, "env.agent.sequencer.run_phase",
                                "default_sequence",
                                hello_message_seq::get_type());
    endfunction : build_phase

endclass : hello_message_test

