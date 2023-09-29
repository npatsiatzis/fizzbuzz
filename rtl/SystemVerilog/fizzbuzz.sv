module fizzbuzz
    #(
        //use /*verilator public*/ on parameter -> parameter values visible to verialted code
        parameter int g_length /*verilator public*/ = 100
    )

    (
        input logic i_clk,    // Clock
        input logic i_rst, // synchronous active high reset
        input logic i_en,  // enable
        output logic o_is_fizz,
        output logic o_is_buzz,
        output logic [$clog2(g_length) -1 : 0] o_number
    );
    `ifdef USE_VERILATOR
        typedef enum logic [1:0] {idle_fizz = 0, fizz_[1:3]} fizz_t /*verilator public*/;
        typedef enum logic [2:0] {idle_buzz = 0, buzz_[1:5]} buzz_t /*verilator public*/;
    `else   // yosys does not support the shorthand notation of
            // declaring multiple enum values at once
        typedef enum logic [1:0] {idle_fizz = 0, fizz_1,fizz_2,fizz_3} fizz_t;
        typedef enum logic [2:0] {idle_buzz = 0, buzz_1,buzz_2,buzz_3,buzz_4,buzz_5} buzz_t;
    `endif

    fizz_t state_fizz;
    buzz_t state_buzz;

    logic [$clog2(g_length) -1 : 0] cnt;

    // Had to move start out here from being a local variable (as it should)
    // inside the always block, because it was not visible from within the verilator tb
    // and I did not want to make it external to gain visibility.
    // Also then turn off BLKSEQ lint rule since we perform blocking assignments
    // in a sequential procedural block with a NON-LOCAL signal.
    
    logic start /*verilator public_flat*/;
    always_ff @(posedge i_clk) begin : fizzbuzz_FSM

        if(i_rst) begin
            cnt <= 0;
            state_fizz <= idle_fizz;
            state_buzz <= idle_buzz;
            /*verilator lint_off BLKSEQ*/
            start = 1'b0;

            o_is_fizz <= 1'b0;
            o_is_buzz <= 1'b0;
        end else begin

            o_is_fizz <= 1'b0;
            case (state_fizz)
                idle_fizz : begin
                    if(i_en) begin
                        start = 1'b1;
                        state_fizz <= fizz_1;
                    end else
                        start = 1'b0;
                end

                fizz_1 :
                    state_fizz <= fizz_2;
                fizz_2 : begin
                    o_is_fizz <= 1'b1;
                    state_fizz <= fizz_3;
                end
                fizz_3 :
                    state_fizz <= fizz_1;
                /*verilator coverage_off*/
                default :
                    state_fizz <= idle_fizz;
                /*verialator coverage_on*/
            endcase

            o_is_buzz <= 1'b0;
            case (state_buzz)
                idle_buzz : begin
                    if(i_en) begin
                        start = 1'b1;
                        state_buzz <= buzz_1;
                    end else
                        start = 1'b0;
                end
                buzz_1 :
                    state_buzz <= buzz_2;
                buzz_2 :
                    state_buzz <= buzz_3;
                buzz_3 :
                    state_buzz <= buzz_4;
                buzz_4 : begin
                    o_is_buzz <= 1'b1;
                    state_buzz <= buzz_5;
                end
                buzz_5 :
                    state_buzz <= buzz_1;
                /*verilator coverage_off*/
                default :
                    state_buzz <= idle_buzz;
                /*verilator coverage_on*/
            endcase

            if(start) begin
                if(32'(cnt) < g_length)
                    cnt <= cnt + 1;
                else begin
                    cnt <= '0;
                    state_fizz <= idle_fizz;
                    state_buzz <= idle_buzz;
                end
            end else
                cnt <= '0;
        end
    end

    assign o_number = cnt;
    /*verilator lint_on BLKSEQ*/


    `ifdef WAVEFORM
        initial begin
            // Dump waves
            $dumpfile("dump.vcd");
            $dumpvars(0, fizzbuzz);
        end
    `endif

endmodule : fizzbuzz
