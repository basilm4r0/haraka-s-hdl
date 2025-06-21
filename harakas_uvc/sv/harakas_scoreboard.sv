// import the function to access the reference model 
import "DPI-C" function void dpi_haraka_s(
    input byte input_data[],
    input longint input_len, 
    output byte output_data[],
    input longint output_len
);

class harakas_scoreboard extends uvm_scoreboard;

    // declares an array that can hold an arbitrary number of top_sequence_item objects
    harakas_message mesgs_queue[$];

    // variables for ref model 
    longint input_len = 0;
    byte input_queue[$];       // buffer to store the message     
    byte input_data[];        // Dynamic array to collect valid bytes
    byte output_data[64];     // Output buffer (64 bytes)
    harakas_message msg;
    longint output_len = 0;
    string hex_str = "";

    `uvm_component_utils(harakas_scoreboard)



    // Receives all transactions broadcasted by a uvm_analysis_port.
    uvm_analysis_imp #(harakas_message, harakas_scoreboard) scoreboard_port;
    
    // create a constructor 
    function new(string name = "harakas_scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scoreboard_port = new("scoreboard_port", this);
    endfunction : build_phase

    // // Connect Phase
    // function void connect_phase(uvm_phase phase);
    //     super.connect_phase(phase);
    // endfunction : connect_phase


    // Write Method
    function void write(harakas_message item);
        harakas_message sb_message;
        $cast(sb_message, item.clone());
        mesgs_queue.push_back(sb_message);
        `uvm_info(get_type_name(), "Scoreboard: Accept transaction item!", UVM_MEDIUM)
        print_mesgs_queue(); 
        
    endfunction : write

    function void print_mesgs_queue();
    `uvm_info(get_type_name(), "Printing all messages in mesgs_queue:", UVM_LOW)
    foreach (mesgs_queue[i]) begin
            `uvm_info(get_type_name(), $sformatf("Message[%0d]: serial_in = 0x%0h, process_input = %0b, reset = %0b", 
            i, mesgs_queue[i].serial_in, mesgs_queue[i].process_input, mesgs_queue[i].reset), UVM_MEDIUM)
        end
    endfunction: print_mesgs_queue

    // //! Run Phase: the comparing will happen here. 
    task run_phase(uvm_phase phase);
        super.run_phase(phase); 
        forever begin
            wait(mesgs_queue.size() > 0);
            msg = mesgs_queue.pop_front();
            if (!msg.reset && msg.process_input) begin
                input_queue.push_back(byte'(msg.serial_in));
                input_len++;
                output_len = msg.digest_length;
            end
            // when reset is set to 1 for the second time, it indicates the input sequence is done and data should be sent to the DPI
            if (msg.reset && !msg.process_input && input_len > 0 ) begin
                `uvm_info(get_type_name(), $sformatf("Input length: %0d, output length: %0d", input_len, output_len), UVM_MEDIUM)
                
                // allocate and copy data from queue to dynamic array
                input_data = new[input_queue.size()];
                for (int i = 0; i < input_queue.size(); i++) begin
                    input_data[i] = input_queue[i];
                end

                foreach (input_data[i]) begin
                    `uvm_info(get_type_name(), $sformatf("Input data: %02x ", input_data[i]), UVM_MEDIUM)
                end
                dpi_haraka_s(input_data, input_len, output_data, output_len); // call the ref model to calcuate the final output
                
                // Print output data after DPI call
                for (int i = 0; i < output_len; i++) begin
                    hex_str = {hex_str, $sformatf("%02x", output_data[i])};
                end
                `uvm_info(get_type_name(), $sformatf("\n\nOutput from C language reference model: %s", hex_str), UVM_MEDIUM)
                
                // Print output of the DUT 
                `uvm_info(get_type_name(), $sformatf("\n\nOutput from Systemverilog DUT: %0d",msg.out ), UVM_MEDIUM) // the output is x, because the DUT is still under construction  
            end

        end

    endtask : run_phase
    
endclass: harakas_scoreboard
