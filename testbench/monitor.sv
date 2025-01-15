class haraka_s_monitor extends uvm_monitor();

    //1. Component
    `uvm_component_utils(haraka_s_monitor)

    //2. Initializations
    virtual haraka_s_interface vif;
    haraka_s_sequence_item item ;


    //3. Port
    uvm_analysis_port #(haraka_s_sequence_item) monitor_port;

    //4. Constructor 
    function new(string name = "haraka_s_driver", uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //5. Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor_port = new("monitor_port", this);
        if(!(uvm_config_db#(virtual haraka_s_interface)::get(this,"*","vif",vif)))
        begin
            `uvm_error("haraka_s_monitor", "Failed to get VIF from config DB!")
        end

    endfunction : build_phase

    //6. Connect Phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase

    //7. Run Phase
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            item = haraka_s_sequence_item::type_id::create("item");
            @(posedge vif.monitor.clk);
    
            item.in = vif.in;
            item.d = vif.d;
            item.enable = vif.enable;
            item.encrypt = vif.encrypt;
            item.reset = vif.reset;
            item.out = vif.out;    

            `uvm_info(get_type_name(), $sformatf("Monitor: Sending data to Scoreboard\n %s", item.sprint()),UVM_NONE)
            monitor_port.write(item);
        end

    endtask : run_phase

endclass: haraka_s_monitor