# flags
VCS       = vcs
VCS_FLAGS = -full64 -sverilog -lca -kdb -debug_access+all+reverse 

# needed source files 
SRC = \
    top.sv \
    deserializer.sv \
    serializer.sv \
    Mux512.sv \
    QuadAes.sv \
    Aes.sv \
    S_box.sv \
    Register.sv \
    ShiftRows.sv \
    MixColumns.sv \
    AddRC.sv \
    Mix512.sv \
    Demux512.sv \
    Haraka.sv \
    Haraka_S.sv \
  

# target: compile and run simulation
all: simv
	./simv

# build the simulation executable
simv:
	$(VCS) $(VCS_FLAGS) $(SRC) -o simv

# remove generated files
clean:
	rm -rf simv* csrc* vcs* *.log

.PHONY: all simv clean
