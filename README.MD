![example workflow](https://github.com/npatsiatzis/fizzbuzz/actions/workflows/regression.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/fizzbuzz/actions/workflows/coverage.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/fizzbuzz/actions/workflows/regression_pyuvm.yml/badge.svg)
![example workflow](https://github.com/npatsiatzis/fizzbuzz/actions/workflows/coverage_pyuvm.yml/badge.svg)

### fizzbuzz RTL implementation


- Count from 0 to length (user-defined)
- set fizz if number divisible by 3, buzz if divisible by 5 and fizzbuzz if divisible by both
- CoCoTB testbench for functional verification
    - $ make
- CoCoTB-test unit testing to exercise the CoCoTB tests across a range of values for the generic parameters
    - $  SIM=ghdl pytest -n auto -o log_cli=True --junitxml=test-results.xml --cocotbxml=test-cocotb.xml


