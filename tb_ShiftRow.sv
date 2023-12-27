module tb_ShiftRow;
  // how to compile: vcs -sverilog tb_ShiftRow.sv ShiftRow.sv
  // parameters
  parameter CLK_PERIOD = 10;

  // signals
  logic [127:0] in_data;
  logic [127:0] out_data;

  // instantiate the ShiftRow module
  ShiftRow uut (
    .in(in_data),
    .out(out_data)
  );

  // clock generation
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_ShiftRow);

    // apply initial input values
    in_data = 128'h87F24D97EC6E4C904AC346E78CD895A6;

    forever begin
        #((CLK_PERIOD)/2) $display("Time = %0t: Toggle Clock", $time);
      end

  end

  // apply stimulus and check results
  initial begin
    // wait for a few clock cycles before applying inputs
    #10;

    // display initial values
    $display("Time = %0t: in_data = %h, out_data = %h", $time, in_data, out_data);

    // apply new input values
    in_data = 128'h87F24D97EC6E4C904AC346E78CD895A6; // Same as the initial input

    // wait for a few clock cycles
    #10;

    // display updated values
    $display("Time = %0t: in_data = %h, out_data = %h", $time, in_data, out_data);

    // check if the output matches the expected result
    if (out_data == 128'h87F24D976E4C90EC46E74AC3A68CD895)
      $display("Test passed!");
    else
      $display("Test failed!");

    // terminate the simulation
    $finish;
  end

endmodule
