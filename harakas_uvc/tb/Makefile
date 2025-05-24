# VCS_OPTS = -full64 -sverilog -timescale=1ns/1ns +vpi -debug_pp -l vcs.log
# Tool and flags
VCS        = vcs
TEST_NAME  = hello_message_test
VCS_FLAGS  = -full64 -sverilog -lca -kdb -debug_access+all+reverse -ntb_opts uvm +UVM_TESTNAME=$(TEST_NAME) -timescale=1ns/1ns
INC_DIRS   = +incdir+../sv
VERBOSITY  = UVM_MEDIUM

# Needed source files
SRC = \
    ../../ref_model/dpi_wrapper.c \
    ../sv/harakas_pkg.sv \
    ../sv/harakas_if.sv \
    tb_top.sv \
    hw_top.sv 

# Default target: compile and run
all: simv
	./simv +UVM_TESTNAME=$(TEST_NAME) +UVM_VERBOSITY=$(VERBOSITY) > simv_output.log 2>&1

# Build the simulation executable
simv:
	$(VCS) $(VCS_FLAGS) $(INC_DIRS) $(SRC) -o simv

# Clean generated files
clean:
	rm -rf simv* csrc* vcs* *.log ucli.key DVEfiles *.vpd *.vcd *.daidir

.PHONY: all simv clean
