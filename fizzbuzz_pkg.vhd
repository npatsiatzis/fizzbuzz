library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

package fizzbuzz_pkg is
	constant LENGTH : natural :=100;
	constant SIZE : natural :=natural(ceil(log2(real(LENGTH))));
end fizzbuzz_pkg;