![example workflow](https://github.com/npatsiatzis/fizzbuzz/actions/workflows/regression.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/fizzbuzz/actions/workflows/coverage.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/fizzbuzz/actions/workflows/formal.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/fizzbuzz/actions/workflows/regression_pyuvm.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/fizzbuzz/actions/workflows/coverage_pyuvm.yml/badge.svg)

### fizzbuzz RTL implementation


- Count from 0 to length (user-defined)
- set fizz if number divisible by 3, buzz if divisible by 5 and fizzbuzz if divisible by both

-- RTL code in:
- [VHDL](https://github.com/npatsiatzis/fizzbuzz/tree/main/rtl/VHDL)
- [SystemVerilog](https://github.com/npatsiatzis/fizzbuzz/tree/main/rtl/SystemVerilog)

-- Functional verification with methodologies:
- [cocotb](https://github.com/npatsiatzis/fizzbuzz/tree/main/cocotb_sim)
- [pyuvm](https://github.com/npatsiatzis/fizzbuzz/tree/main/pyuvm_sim)
- [UVM](https://github.com/npatsiatzis/fizzbuzz/tree/main/uvm_sim)
- [C++-based transactional tb (verilator)](https://github.com/npatsiatzis/fizzbuzz/tree/main/verilator_sim)

