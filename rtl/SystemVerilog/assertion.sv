module assertion
    #(
        //use /*verilator public*/ on parameter -> parameter values visible to verialted code
        parameter int g_length /*verilator public*/ = 20
    )

    (
        input logic start,

        input logic i_clk,    // Clock
        input logic i_rst, // synchronous active high reset
        input logic i_en,  // enable
        input logic o_is_fizz,
        input logic o_is_buzz,
        input logic [$clog2(g_length) -1 : 0] o_number
    );

    check_fizz : assert property (@(posedge i_clk) disable iff(i_rst) start && (o_number %3 == 0) |-> o_is_fizz);
    check_buzz : assert property (@(posedge i_clk) disable iff(i_rst) start && (o_number %5 == 0) |-> o_is_buzz);
    check_number_range : assert property (@(posedge i_clk) disable iff(i_rst) 32'(o_number) >= 0 && 32'(o_number) <= g_length);

    cover_en : cover property(@(posedge i_clk) i_en);
    cover_range : cover property (@(posedge i_clk) 32'(o_number) == g_length);
endmodule
