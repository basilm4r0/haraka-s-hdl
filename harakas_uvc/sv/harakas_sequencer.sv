class harakas_sequencer extends uvm_sequencer #(harakas_message);
    
    //1. UVM component
    `uvm_component_utils(harakas_sequencer)

    //2. Constructor
    function new(string name = "harakas_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction

    //3. Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

endclass: harakas_sequencer