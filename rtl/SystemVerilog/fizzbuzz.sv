`default_nettype none

module fizzbuzz
    #(
        //use /*verilator public*/ on parameter -> parameter values visible to verialted code
        parameter int G_LENGTH /*verilator public*/ = 50
    )

    (
        input logic i_clk,    // Clock
        input logic i_rst, // synchronous active high reset
        input logic i_en,  // enable
        output logic o_is_fizz,
        output logic o_is_buzz,
        output logic [$clog2(G_LENGTH) -1 : 0] o_number
    );

    typedef enum logic [1:0] {idle_fizz = 0, fizz_[1:3]} fizz_t /*verilator public*/;
    typedef enum logic [2:0] {idle_buzz = 0, buzz_[1:5]} buzz_t /*verilator public*/;

    fizz_t state_fizz;
    buzz_t state_buzz;

    logic [$clog2(G_LENGTH) -1 : 0] cnt;

    always_ff @(posedge i_clk) begin : fizzbuzz_FSM
        logic start;

        if(i_rst) begin
            cnt <= 0;
            state_fizz <= idle_fizz;
            state_buzz <= idle_buzz;
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
                default :
                    state_fizz <= idle_fizz;
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
                default :
                    state_buzz <= idle_buzz;
            endcase

            if(start) begin
                if(32'(cnt) < G_LENGTH)
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

endmodule : fizzbuzz
