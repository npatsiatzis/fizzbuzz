### simple fizzbuzz SystemVerilog implementation


-- Verilator tb for functional verification, adapted from the work of Norbet Kremeris (https://www.itsembedded.com/dhd/verilator_4/). Added coverage class for the input and output interfaces,sequence class, coverage-based end-of-test condition and coverage-driven test generation
    - $ make sim
- open waveform with gtkwave
    - $ make waves
- lint test (verilator & verible)
    - $make lint
