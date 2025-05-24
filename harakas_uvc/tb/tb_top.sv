
module tb_top;

  // import the UVM library
    import uvm_pkg::*;

  // import the YAPP package
    import harakas_pkg::*;

  // include the testbench and test library files

    `include "harakas_test_lib.sv"

    initial begin
        harakas_vif_config::set(null,"*.env.agent.*","vif", hw_top.in0);
        run_test();
    end

endmodule : tb_top
