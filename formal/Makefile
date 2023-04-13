# Makefile

# defaults
SIM ?= ghdl
TOPLEVEL_LANG ?= vhdl
EXTRA_ARGS += --std=08
SIM_ARGS += --wave=wave.ghw

VHDL_SOURCES += $(PWD)/../rtl/fizzbuzz_pkg.vhd
VHDL_SOURCES += $(PWD)/../rtl/fizzbuzz.vhd
# use VHDL_SOURCES for VHDL files

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
# MODULE is the basename of the Python test file
MODULE = testbench
TOPLEVEL = fizzbuzz

formal :
		sby --yosys "yosys -m ghdl" -f fizzbuzz.sby

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim