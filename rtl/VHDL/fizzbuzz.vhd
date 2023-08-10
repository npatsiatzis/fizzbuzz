-- file fizzbuzz.vhd
-- this is the sole RTL file of an RTL adaptation of fizzbuzz

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.math_real.all;
	use work.fizzbuzz_pkg.all;

entity FIZZBUZZ is
	generic (
		G_LENGTH : natural := 20
	);
	port (
		I_CLK     : in    std_ulogic;
		I_RST     : in    std_ulogic;
		I_EN      : in    std_ulogic;
		O_IS_FIZZ : out   std_ulogic;
		O_IS_BUZZ : out   std_ulogic;
		O_NUMBER  : out   std_ulogic_vector(natural(ceil(log2(real(G_LENGTH)))) - 1 downto 0)	--! current number
	);
end entity FIZZBUZZ;

architecture ARCH of FIZZBUZZ is

	type fizz_states is (idle, fizz_1, fizz_2, fizz_3);

	type buzz_states is (idle, buzz_1, buzz_2, buzz_3, buzz_4, buzz_5);

	signal state_fizz : fizz_states;

	signal state_buzz : buzz_states;

	signal cnt        : integer range 0 to G_LENGTH;

begin

	FIZZBUZZ_FSM : process (I_CLK) is

		variable start : boolean;

	begin

		if (rising_edge(I_CLK)) then
			if (I_RST = '1') then
				cnt       <= 0;
				O_IS_FIZZ <= '0';
				O_IS_BUZZ <= '0';
				start     := false;

				state_fizz <= idle;
				state_buzz <= idle;
			else
				O_IS_FIZZ <= '0';

				case state_fizz is

					when idle =>
						if (I_EN = '1') then
							start := true;

							state_fizz <= fizz_1;
						else
							start := false;
						end if;

					when fizz_1 =>
						state_fizz <= fizz_2;

					when fizz_2 =>
						O_IS_FIZZ <= '1';

						state_fizz <= fizz_3;

					when fizz_3 =>
						state_fizz <= fizz_1;

					when others =>
						state_fizz <= idle;

				end case;

				O_IS_BUZZ <= '0';

				case state_buzz is

					when idle =>
						if (I_EN = '1') then
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
						O_IS_BUZZ <= '1';

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

	O_NUMBER <= std_ulogic_vector(to_unsigned(cnt, O_NUMBER'length));

end architecture ARCH;