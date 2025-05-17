`include "src/serializer.sv"

module test;

    logic [256-1:0] in;
    logic [6-1:0] length;
    logic bclk;
    logic clk;
    logic reset;
    logic [8-1:0] out;


    serializer serializer(
        .in(in), 
        .length(length),
        .bclk(bclk),
        .clk(clk),
        .reset(reset),
        .serial_out(out)
    );

    // Clock generation
    initial bclk = 1;
    always #1 bclk = ~bclk;

    // Clock generation
    initial clk = 1;
    always #32 clk = ~clk;


    // Stimulus + FSDB dumping
    initial begin
        // FSDB dumping
        $fsdbDumpfile("simv.fsdb");
        $fsdbDumpvars(0, test);  

        // Initialize signals
        reset = 1;
        length = 32;
        @(posedge clk); in = 256'h9b26a9260ed12149a6cd6fa17c862b1d5066f8cb54fdae4a9ad7dfb3c4f34076;
        @(posedge clk); in = 256'h303f6be2fb2af6a3dfa8d7c1dfaa6d39d0b84dc60f4126ad589dcb64dcbd8d5a;

        // Reset pulse
        #20 reset = 0;
         
        #3;
        // Start feeding data
        @(posedge bclk); $display("%h\n", out);
        @(posedge bclk); $display("%h\n", out);
        @(posedge bclk); $display("%h\n", out);
        @(posedge bclk); $display("%h\n", out);
        @(posedge bclk); $display("%h\n", out);
        @(posedge bclk); $display("%h\n", out);
        // Wait for output (if needed)
        #400;

        $finish;
    end

endmodule: test
