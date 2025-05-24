class harakas_driver extends uvm_driver #(harakas_message);

    //1.UVM component
    `uvm_component_utils(harakas_driver)

    //2. Initialization (vif & seq_item)
    virtual harakas_if vif;
    harakas_message item; 

    //3. Constructor
    function new(string name = "harakas_driver", uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //4. Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!(uvm_config_db#(virtual harakas_if)::get(this, "*", "vif", vif))) 
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
            item = harakas_message::type_id::create("item");
            seq_item_port.get_next_item(item); // get the item from the sequencer 
            drive(item);  //drive to dut 
            seq_item_port.item_done();
        end
    endtask : run_phase

    //7. Drive
    task drive(harakas_message item);
        @(posedge vif.clk);
        `uvm_info(get_type_name(), $sformatf("Driver: Sending data to DUT\n %s", item.sprint()), UVM_LOW)
        vif.serial_in      <= item.serial_in;
        vif.process_input  <= item.process_input;
        vif.digest_length  <= item.digest_length;
        vif.enable         <= item.enable;
        vif.reset          <= item.reset;
        vif.out            <= item.out;
 
        //TODO: check this before running 
        // @(posedge driver.vif.clk);

    endtask : drive

endclass: harakas_driver