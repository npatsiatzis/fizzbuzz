--! \file fizzbuzz.vhd
--! \brief this is the sole RTL file of an RTL adaptation of fizzbuzz

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.fizzbuzz_pkg.all;

--! \details Fizzbuzz implementation. Counts from 0 to LENGTH (user defined) and if number
--! is divisible by 3 fizz is asserted,resp. buzz if divisible by 5 and fizzbuzz
--! if divisible by both 3 and 5.
--!
--! **Instantiation template**
--!
--! ```vhdl
--! fizzbuzz_0 : entity work.fizzbuzz(arch)
--!  generic map (
--!    g_length => g_length
--!  )
--!  port map (
--!    i_clk     => w_clk,
--!    i_rst  	 => w_rst,
--!    i_en  	 => w_en,
--!	   o_is_fizz => w_is_fizz,
--!	   o_is_buzz => w_is_buzz,
--!	   o_number  => w_number
--!  );
--! ```
entity fizzbuzz is
	generic (
		g_length : natural :=20);		--! number up to which to run fizzbuzz
	port(	
		i_clk : in std_ulogic;			--! system clock
		i_rst : in std_ulogic;			--! system reset
		i_en : in std_ulogic;			--! enable to fizzbuzz procedure
		o_is_fizz : out std_ulogic;		--! value is fizz indicator
		o_is_buzz : out std_ulogic;		--!	value is buzz indicator
		o_number : out std_ulogic_vector(natural(ceil(log2(real(g_length)))) -1 downto 0));	--! current number
end fizzbuzz;

architecture arch of fizzbuzz is
	type fizz_states is (idle,fizz_1,fizz_2,fizz_3);
	signal state_fizz : fizz_states :=idle;

	type buzz_states is (idle,buzz_1,buzz_2,buzz_3,buzz_4,buzz_5); 
	signal state_buzz : buzz_states :=idle;

	signal cnt : integer range 0 to g_length :=0;
begin

	fizzbuzz_FSM : process(i_clk) 
		variable start : boolean :=false;
	begin
		if(rising_edge(i_clk)) then
			if(i_rst = '1') then
				cnt <= 0;
				o_is_fizz <= '0';
				o_is_buzz <= '0';
				start := false;

				state_fizz <= idle;
				state_buzz <= idle;
			else
				o_is_fizz <= '0';
				case state_fizz is 
					when idle =>
						if(i_en = '1') then
							start := true;
							state_fizz <= fizz_1;
						else
							start := false;
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
							start := true;
							state_buzz <= buzz_1;
						else
							start := false;
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

				if(start = true) then
					if(cnt < g_length) then
						cnt <= cnt +1;
					else
						cnt <= 0;
						state_fizz <= idle;
						state_buzz <= idle;
					end if;
				else
					cnt <= 0;
				end if;

			end if;
		end if;
	end process; -- fizzbuzz_FSM
	
	o_number <= std_ulogic_vector(to_unsigned(cnt,o_number'length));
end arch;