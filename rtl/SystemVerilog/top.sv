`include "assertion.sv"
module top
    #(
        //use /*verilator public*/ on parameter -> parameter values visible to verialted code
        parameter int g_length /*verilator public*/ = 20
    )

    (
        input logic i_clk,    // Clock
        input logic i_rst, // synchronous active high reset
        input logic i_en,  // enable
        output logic o_is_fizz,
        output logic o_is_buzz,
        output logic [$clog2(g_length) -1 : 0] o_number
    );

    fizzbuzz #(.g_length(g_length)) fizzbuzz_inst 
    (
    	.i_clk,
    	.i_rst,
    	.i_en,
    	.o_is_fizz,
    	.o_is_buzz,
    	.o_number
	);

    // Note: Verilator only ssupports bind to a target module name, NOT to an instance path.
	bind fizzbuzz assertion #(.g_length(g_length)) inst
    (
        .start(fizzbuzz_inst.start),
    	.i_clk,
    	.i_rst,
    	.i_en,
    	.o_is_fizz,
    	.o_is_buzz,
    	.o_number
	);
endmodule
