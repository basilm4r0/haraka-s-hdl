module tb_MixColumns;
// command to run: vcs -sverilog tb_MixColumns.sv  MixColumns.sv 
  reg [127:0] in_data;
  wire [127:0] out_data;

  MixColumns uut (
    .in_data(in_data),
    .out_data(out_data)
  );

  initial begin
    // Initialize input
    in_data = 128'h87F24D976E4C90EC46E74AC3A68CD895;
    
    // Display initial values
    $display("Initial in_data: %h", in_data);

    // Simulate for 10 time units
    #10;

    // Display output
    $display("Final out_data: %h", out_data);

     // Check the result
    if (out_data === 128'hc2384d1874b136ad378e6bfa95432594) begin
      $display("Test passed!");
    end else begin
      $display("Test failed!");
    end
    // End simulation
    $finish;

    // End simulation
    $finish;
  end

endmodule
