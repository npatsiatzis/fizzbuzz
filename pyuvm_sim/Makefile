# Makefile

# defaults
TOPLEVEL_LANG ?= vhdl
TOPLEVEL = fizzbuzz

ifeq ($(TOPLEVEL_LANG),verilog)
	ifeq ($(SIM),modelsim)			#32-bit sim, 32-bit python required
		SIM ?= modelsim
		TOPLEVEL_LANG ?= verilog
		VERILOG_SOURCES += $(PWD)/../rtl/SystemVerilog/fizzbuzz.sv
		WAVES=1
		MODULE = tb
	else 
		SIM ?= icarus				#64-bit sim, 64-bit python required
		TOPLEVEL_LANG ?= verilog
		VERILOG_SOURCES += $(PWD)/../rtl/SystemVerilog/fizzbuzz.sv
		COMPILE_ARGS += -DWAVEFORM
		WAVES=1
		MODULE = tb
	endif
else ifeq ($(TOPLEVEL_LANG),vhdl)
	ifeq ($(SIM),modelsim)
		SIM ?= modelsim
		VHDL_SOURCES += $(PWD)/../rtl/VHDL/fizzbuzz_pkg.vhd
		VHDL_SOURCES += $(PWD)/../rtl/VHDL/fizzbuzz.vhd
		MODULE = tb
	else 
		SIM ?= ghdl
		EXTRA_ARGS += --std=08
		SIM_ARGS += --wave=wave.ghw
		VHDL_SOURCES += $(PWD)/../rtl/VHDL/fizzbuzz_pkg.vhd
		VHDL_SOURCES += $(PWD)/../rtl/VHDL/fizzbuzz.vhd
		MODULE = tb
	endif
endif



# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
# MODULE is the basename of the Python test file

#PYTHPNPATH is an environment variable that can be set to additional directories
#where python will look for modules and packages
export PYTHONPATH := $(PWD)/../model:$(PYTHONPATH)

test_adder:
		$(MAKE) sim 

lint: $(VHDL_SOURCES)
	vsg --style jcl -f $^
	
documentation:
		doxygen 

.PHONY: clean_dir
clean_dir:
		rm -f *.vcd
		rm -f *.ghw
		rm -f *.o 
		rm -f *.xml
# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim


	
