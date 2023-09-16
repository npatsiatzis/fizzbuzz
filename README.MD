![example workflow](https://github.com/npatsiatzis/fizzbuzz/actions/workflows/regression.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/fizzbuzz/actions/workflows/coverage.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/fizzbuzz/actions/workflows/formal.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/fizzbuzz/actions/workflows/regression_pyuvm.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/fizzbuzz/actions/workflows/coverage_pyuvm.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/fizzbuzz/actions/workflows/verilator_regression.yml/badge.svg)
[![codecov](https://codecov.io/gh/npatsiatzis/fizzbuzz/graph/badge.svg?token=UIM9DPOFZE)](https://codecov.io/gh/npatsiatzis/fizzbuzz)
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


### Repo Structure

This is a short tabular description of the contents of each folder in the repo.

| Folder | Description |
| ------ | ------ |
| [rtl/SystemVerilog](https://github.com/npatsiatzis/fizzbuzz/tree/main/rtl/SystemVerilog) | SV RTL implementation files |
| [rtl/VHDL](https://github.com/npatsiatzis/fizzbuzz/tree/main/rtl/VHDL) | VHDL RTL implementation files |
| [cocotb_sim](https://github.com/npatsiatzis/fizzbuzz/tree/main/cocotb_sim) | Functional Verification with CoCoTB (Python-based) |
| [pyuvm_sim](https://github.com/npatsiatzis/fizzbuzz/tree/main/pyuvm_sim) | Functional Verification with pyUVM (Python impl. of UVM standard) |
| [uvm_sim](https://github.com/npatsiatzis/fizzbuzz/tree/main/uvm_sim) | Functional Verification with UVM (SV impl. of UVM standard) |
| [verilator_sim](https://github.com/npatsiatzis/fizzbuzz/tree/main/verilator_sim) | Functional Verification with Verilator (C++ based) |
| [formal](https://github.com/npatsiatzis/fizzbuzz/tree/main/formal) | Formal Verification using  PSL properties and [YoysHQ/sby](https://github.com/YosysHQ/oss-cad-suite-build) |


This is the tree <!-- view of the strcture of the repo.
<pre>
<font size = "2">
.
├── <font size = "4"><b><a href="https://github.com/npatsiatzis/fizzbuzz/tree/main/rtl">rtl</a></b> </font>
│   ├── <font size = "4"><a href="https://github.com/npatsiatzis/fizzbuzz/tree/main/rtl/SystemVerilog">SystemVerilog</a> </font>
│   │   └── SV files
│   └── <font size = "4"><a href="https://github.com/npatsiatzis/fizzbuzz/tree/main/rtl/VHDL">VHDL</a> </font>
│       └── VHD files
├── <font size = "4"><b><a href="https://github.com/npatsiatzis/fizzbuzz/tree/main/cocotb_sim">cocotb_sim</a></b></font>
│   ├── Makefile
│   └── python files
├── <font size = "4"><b><a 
 href="https://github.com/npatsiatzis/fizzbuzz/tree/main/pyuvm_sim">pyuvm_sim</a></b></font>
│   ├── Makefile
│   └── python files
├── <font size = "4"><b><a href="https://github.com/npatsiatzis/fizzbuzz/tree/main/uvm_sim">uvm_sim</a></b></font>
│   └── .zip file
├── <font size = "4"><b><a href="https://github.com/npatsiatzis/fizzbuzz/tree/main/verilator_sim">verilator_sim</a></b></font>
│   ├── Makefile
│   └── verilator tb
└── <font size = "4"><b><a href="https://github.com/npatsiatzis/fizzbuzz/tree/main/formal">formal</a></b></font>
    ├── Makefile
    └── PSL properties file, scripts
</pre> -->

