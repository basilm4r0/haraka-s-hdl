module top;

    logic [8-1:0] serial_in;
    logic process_input;
    logic [64-1:0] digest_length;
    logic enable;
    logic clk;
    logic reset;
    logic [8-1:0] out;


    Haraka_S harka_s (
        .serial_in(serial_in), 
        .process_input(process_input), 
        .digest_length(digest_length),
        .enable(enable),
        .clk(clk),
        .reset(reset), 
        .out(out)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;  // 100MHz clock

    // Stimulus + FSDB dumping
    initial begin
        // FSDB dumping
        $fsdbDumpfile("simv.fsdb");
        $fsdbDumpvars(0, top);  

        // Initialize signals
        reset = 1;
        enable = 0;
        process_input = 0;
        digest_length = 64'd64;
        serial_in = 8'd0;

        // Reset pulse
        #20 reset = 0;
         
        // Start feeding data
        @(posedge clk); enable = 1; serial_in = 8'h48; process_input = 1;
        @(posedge clk); serial_in = 8'h65;
        @(posedge clk); serial_in = 8'h6c;
        @(posedge clk); serial_in = 8'h6c;
        @(posedge clk); serial_in = 8'h6f;
        // Finish input
        @(posedge clk);process_input = 0;
            // serial_in = 8'd0;

        // Wait for output (if needed)
        #1500;

        $finish;
    end

endmodule: top
