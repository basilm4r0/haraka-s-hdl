class harakas_monitor extends uvm_monitor();

    //1. Component
    `uvm_component_utils(harakas_monitor)

    //2. Initializations
    virtual harakas_if vif;
    harakas_message item ;


    //3. Port
    uvm_analysis_port #(harakas_message) monitor_port;

    //4. Constructor 
    function new(string name = "haraka_s_driver", uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //5. Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor_port = new("monitor_port", this);
        if(!(uvm_config_db#(virtual harakas_if)::get(this,"*","vif",vif)))
        begin
            `uvm_error("harakas_monitor", "Failed to get VIF from config DB!")
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
            item = harakas_message::type_id::create("item", this);
            @(posedge vif.clk);
            if (vif.process_input || vif.reset ) begin
                item.serial_in     = vif.serial_in;
                item.process_input = vif.process_input;
                item.digest_length = vif.digest_length;
                item.enable        = vif.enable;
                item.reset         = vif.reset;
                item.out           = vif.out;    
                `uvm_info(get_type_name(), $sformatf("Monitor: Sending data to Scoreboard\n %s", item.sprint()),UVM_NONE)
                monitor_port.write(item);
            end 
        end

    endtask : run_phase

endclass: harakas_monitor