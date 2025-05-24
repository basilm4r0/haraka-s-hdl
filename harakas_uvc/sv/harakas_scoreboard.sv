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
            // when the second resert that means input data is ready send the data to the dpi 
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
                dpi_haraka_s(input_data, input_len, output_data, output_len);
                
                // Print output data after DPI call
                for (int i = 0; i < output_len; i++) begin
                    hex_str = {hex_str, $sformatf("%02x", output_data[i])};
                end
                `uvm_info(get_type_name(), $sformatf("\n\nOutput: %s", hex_str), UVM_MEDIUM)
            
            end

        end

    endtask : run_phase


    // function void conv_to_dpi_wrapper();
    //      // Extract input message from queue
    //         harakas_message msg = mesgs_queue[i];
    //         // if (msg.reset && !msg.process_input) begin
    //          //     input_len = 0;
    //         //     output_len = 0;
    //         // end
    //         if (!msg.reset && msg.process_input) begin
    //             input_data.push_back(byte'(msg.serial_in));
    //             input_len++;
    //             output_len = msg.digest_length;
    //         end
    //     end
    //     // print the input for DPI 
    //     `uvm_info(get_type_name(), $sformatf("Input length: %0d, output length: %0d", input_len, output_len), UVM_MEDIUM)
    //     foreach (input_data[i]) begin
    //         `uvm_info(get_type_name(), $sformatf("Input data: %02x ", input_data[i]), UVM_MEDIUM)
    //     end
        // // covert for DPI 
        // // detect end of message: reset high and process_input low
        // if (sb_message.reset && !sb_message.process_input) begin
        //     input_len = 0;
        //     output_len = 0;
        // end
        // conv_to_dpi_wrapper();
        // // Extract input message from queue
        // foreach (mesgs_queue[i]) begin
        //     harakas_message msg = mesgs_queue[i];
        //     if (!msg.reset && msg.process_input) begin
        //         input_data.push_back(byte'(msg.serial_in));
        //         input_len++;
        //         output_len = msg.digest_length;
        //     end
        // end
        // // print the input for DPI 
        // `uvm_info(get_type_name(), $sformatf("Input length: %0d, output length: %0d", input_len, output_len), UVM_MEDIUM)
        // foreach (input_data[i]) begin
        //     `uvm_info(get_type_name(), $sformatf("Input data: %02x ", input_data[i]), UVM_MEDIUM)
        // end
    // endfunction : conv_to_dpi_wrapper


    // Compare Task
    // task compare(harakas_message trans);
    // endtask : compare
    


endclass: harakas_scoreboard


/**
now if my dpi_wrapper is like this 
i want to save the input as one stream then send it to my dpi_wrapper
import "DPI-C" function void dpi_haraka_s(
    input byte input_data[],
    input longint input_len, 
    output byte output_data[],
    input longint output_len
);

my mesgs_queue[i] contains: 
Message[0]: serial_in = 0x0, process_input = 0, reset = 1, digest_length = 0x40
Message[1]: serial_in = 0x48, process_input = 1, reset = 0
Message[2]: serial_in = 0x65, process_input = 1, reset = 0
Message[3]: serial_in = 0x6c, process_input = 1, reset = 0
Message[4]: serial_in = 0x6c, process_input = 1, reset = 0
Message[5]: serial_in = 0x6f, process_input = 1, reset = 0
Message[6]: serial_in = 0x0, process_input = 0, reset = 1

input_len is (i-1)
first message and last message are reset messages 
message is 0x48656c6c6f 
output_len = logic digest_length is 64 in decimal, 40 in hexa 

longint count;
byte input_data[];       // Input message
byte output_data[64];    // Output buffer
foreach (mesgs_queue[i]) begin
        if (mesgs_queue[i].serial_in != 0) begin 
        count++; 
        input_data[i] = mesgs_queue[i].serial_in;      
end

// Call the DPI function
    dpi_haraka_s(input_data, input_len, output_data, mesgs_queue[i].digest_length);

note that mesgs_queue[i].serial_in is pf type logic
*/