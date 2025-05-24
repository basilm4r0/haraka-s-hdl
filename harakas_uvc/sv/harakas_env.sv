class harakas_env extends uvm_env;

    // intialize the agent and the soceborad

    harakas_agent agent;
    harakas_scoreboard scb;

    // define macro 
    `uvm_component_utils(harakas_env)

    // create a constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);     
    endfunction: new

    // create a build phase
    function void build_phase( uvm_phase phase);
        super.build_phase(phase);
        agent = harakas_agent::type_id::create("agent", this);
        scb   = harakas_scoreboard::type_id::create("scb", this); 
    endfunction: build_phase


    // connect phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.monitor.monitor_port.connect(scb.scoreboard_port);
    endfunction : connect_phase

endclass: harakas_env 