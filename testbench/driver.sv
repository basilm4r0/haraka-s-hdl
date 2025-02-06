class haraka_s_driver extends uvm_driver #(haraka_s_sequence_item);

    //1.UVM component
    `uvm_component_utils(haraka_s_driver)

    //2. Initialization (vif & seq_item)
    virtual haraka_s_interface vif;
    haraka_s_sequence_item item; 

    //3. Constructor
    function new(string name = "haraka_s_driver", uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //4. Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!(uvm_config_db#(virtual haraka_s_interface)::get(this, "*", "vif", vif))) 
                begin
                `uvm_error("FA_driver", "Failed to get VIF from config DB!")
                end
    endfunction : build_phase


    //5. Connect Phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction : connect_phase

    //6. Run Phase
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            item = haraka_s_sequence_item::type_id::create("item");
            seq_item_port.get_next_item(item);
            drive(item);
            seq_item_port.item_done();
        end
    endtask : run_phase

    //7. Drive
    task drive(haraka_s_sequence_item item);
        `uvm_info(get_type_name(), $sformatf("Driver: Sending data to DUT\n %s", item.sprint()),UVM_NONE)
        vif.serial_in      <= item.serial_in;
        vif.digest_length  <= item.digest_length;
        vif.enable         <= item.enable;
        vif.reset          <= item.reset;
        vif.out            <= item.out;
 
        //TODO: check this before running 
        // @(posedge driver.vif.clk);

    endtask : drive

endclass: haraka_s_driver