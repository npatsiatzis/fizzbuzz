--Fizzbuzz implementation. Counts from 0 to LENGTH (user defined) and if number
--is divisible by 3 fizz is asserted,resp. buzz if divisible by 5 and fizzbuzz
--if divisible by both 3 and 5.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.fizzbuzz_pkg.all;

entity fizzbuzz is
	generic (
		g_length : natural :=100;
		formal : boolean := true);
	port(
		i_clk : in std_ulogic;
		i_rst : in std_ulogic;
		i_en : in std_ulogic;
		o_is_fizz : out std_ulogic;
		o_is_buzz : out std_ulogic;
		o_number : out std_ulogic_vector(natural(ceil(log2(real(g_length)))) -1 downto 0));
end fizzbuzz;

architecture arch of fizzbuzz is
	type fizz_states is (idle,fizz_1,fizz_2,fizz_3);
	signal state_fizz : fizz_states;

	type buzz_states is (idle,buzz_1,buzz_2,buzz_3,buzz_4,buzz_5); 
	signal state_buzz : buzz_states;

	signal cnt : integer range 0 to g_length :=0;
begin
	fizzbuzz_FSM : process(i_clk) 
	begin
		if(rising_edge(i_clk)) then
			if(i_rst = '1') then
				cnt <= 0;
				o_is_fizz <= '0';
				o_is_buzz <= '0';

				state_fizz <= idle;
				state_buzz <= idle;
			else
				if(i_en) then
					if(cnt < g_length) then
						cnt <= cnt +1;
					else
						cnt <= 0;
					end if;
				end if;

				o_is_fizz <= '0';
				case state_fizz is 
					when idle =>
						if(i_en = '1') then
							state_fizz <= fizz_1;
						end if;
					when fizz_1 =>
						state_fizz <= fizz_2;
					when fizz_2 =>
						o_is_fizz <= '1';
						state_fizz <= fizz_3;
					when fizz_3 =>
						state_fizz <= fizz_1;
					when others => 
						state_fizz <= idle;
				end case;

				o_is_buzz <= '0';
				case state_buzz is 
					when idle =>
						if(i_en = '1') then
							state_buzz <= buzz_1;
						end if ;
					when buzz_1 =>
						state_buzz <= buzz_2;
					when buzz_2 =>
						state_buzz <= buzz_3;
					when buzz_3 =>
						state_buzz <= buzz_4;
					when buzz_4 =>
						o_is_buzz <= '1';
						state_buzz <= buzz_5;
					when buzz_5 =>
						state_buzz <= buzz_1;
					when others => 
						state_buzz <= idle;
				end case;
			end if;
		end if;
	end process; -- fizzbuzz_FSM

	o_number <= std_ulogic_vector(to_unsigned(cnt,o_number'length));

	--cover temporal conditions(verify sequential functional behavior over period of time)
	--combinatorial (zero-time) conditions can be verified by assertions in VHDL or testbench (cocotb)
	formal_properties : if formal = true generate 
		signal prev_cnt : integer range 0 to g_length;
	begin
		reg_number : process(i_clk)
		begin
			if(rising_edge(i_clk)) then
				if(i_rst = '1') then
					prev_cnt <= 0;
				else
					prev_cnt <= cnt;
				end if;
			end if;
		end process; -- reg_number

		default clock is rising_edge(i_clk);

		sequence not_init is {i_rst = '0' and i_en ='1' [*1 to inf]; i_rst = '1' [*1 to inf]};
		sequence init is {i_rst = '1'; i_rst = '0' and i_en = '1' [*1 to inf]};

		assert_not_init_fizz : assert always {not_init; prev_cnt mod 3 =2}|-> o_is_fizz = '1';
		assert_not_init_buzz : assert always {not_init; prev_cnt mod 5 =4}|-> o_is_buzz = '1';
		assert_fizz : assert always {init; prev_cnt mod 3 = 2} |-> o_is_fizz = '1';
		assert_buzz : assert always {init; prev_cnt mod 5 = 4} |-> o_is_buzz = '1';
	end generate;
end arch;