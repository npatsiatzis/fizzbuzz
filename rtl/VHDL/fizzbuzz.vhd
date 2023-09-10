-- file fizzbuzz.vhd
-- this is the sole RTL file of an RTL adaptation of fizzbuzz

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.math_real.all;
	use work.fizzbuzz_pkg.all;

entity fizzbuzz is
	generic (
		G_LENGTH : natural := 20
	);
	port (
		i_clk     : in    std_ulogic;
		i_rst     : in    std_ulogic;
		i_en      : in    std_ulogic;
		o_is_fizz : out   std_ulogic;
		o_is_buzz : out   std_ulogic;
		o_number  : out   std_ulogic_vector(natural(ceil(log2(real(G_LENGTH)))) - 1 downto 0)	--! current number
	);
end entity fizzbuzz;

architecture arch of fizzbuzz is

	type fizz_states is (idle, fizz_1, fizz_2, fizz_3);

	type buzz_states is (idle, buzz_1, buzz_2, buzz_3, buzz_4, buzz_5);

	signal state_fizz : fizz_states;

	signal state_buzz : buzz_states;

	signal cnt        : integer range 0 to G_LENGTH;

begin

	FIZZBUZZ_FSM : process (i_clk) is

		variable start : boolean;

	begin

		if (rising_edge(i_clk)) then
			if (i_rst = '1') then
				cnt       <= 0;
				o_is_fizz <= '0';
				o_is_buzz <= '0';
				start     := false;

				state_fizz <= idle;
				state_buzz <= idle;
			else
				o_is_fizz <= '0';

				case state_fizz is

					when idle =>
						if (i_en = '1') then
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
						if (i_en = '1') then
							start := true;

							state_buzz <= buzz_1;
						else
							start := false;
						end if;

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

				if (start = true) then
					if (cnt < G_LENGTH) then
						cnt <= cnt + 1;
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

	end process FIZZBUZZ_FSM;

	o_number <= std_ulogic_vector(to_unsigned(cnt, o_number'length));

end architecture arch;