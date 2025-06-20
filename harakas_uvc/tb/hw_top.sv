module hw_top;

    // Clock and reset signals
    logic         clk;

    // harakas Interface to the DUT
    harakas_if in0(clk);

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;  // 100MHz clock


    // instance of the dut
    Haraka_S dut (
        .serial_in(in0.serial_in), 
        .process_input(in0.process_input), 
        .digest_length(in0.digest_length),
        .enable(in0.enable),
        .clk(clk),
        .reset(in0.reset), 
        .out(in0.out)
    );


    initial begin
        // create a waveform to see the tb results 
        $fsdbDumpfile("tb_results.fsdb");
        $fsdbDumpvars(0, hw_top); 
    end



endmodule: hw_top


