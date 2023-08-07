from cocotb_test.simulator import run
import pytest
import os

vhdl_compile_args = "--std=08"
sim_args = "--wave=wave.ghw"


tests_dir = os.path.abspath(os.path.dirname(__file__)) #gives the path to the test(current) directory in which this test.py file is placed
rtl_dir = tests_dir                                    #path to hdl folder where .vhdd files are placed

module = "tb"
toplevel = "fizzbuzz"   
vhdl_sources = [
    os.path.join(rtl_dir, "../rtl/VHDL/fizzbuzz_pkg.vhd"),
    os.path.join(rtl_dir, "../rtl/VHDL/fizzbuzz.vhd"),
    ]

                                   
#run 10 test with length generic values start = 10 end = 1000 step = 100
@pytest.mark.parametrize("parameter", [{"g_length": str(i)} for i in range(100,1100,100)])
def test(parameter):



    run(
        python_search=[tests_dir],                         #where to search for all the python test files
        vhdl_sources=vhdl_sources,
        toplevel=toplevel,
        module=module,

        vhdl_compile_args=[vhdl_compile_args],
   		toplevel_lang="vhdl",
        parameters=parameter,                              #parameter dictionary
   		extra_env=parameter,
        sim_build="sim_build/"
        + "_".join(("{}={}".format(*i) for i in parameter.items())),
    )

    if __name__ == "__main__":
    	test(parameter)