module hw_top;

    // Clock and reset signals
    logic         clk;

    // harakas Interface to the DUT
    harakas_if in0(clk);

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;  // 100MHz clock

    initial begin
        #200ns;
        $finish;
    end


    // DUT Instantiation later
    // initial begin
    // // Wait for output (if needed)
    // #10;
    // $finish;
    // end 


endmodule: hw_top


