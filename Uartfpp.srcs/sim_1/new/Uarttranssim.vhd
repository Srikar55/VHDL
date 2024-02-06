library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Uarttranssim is
generic(
DBIT: integer := 8);
--  Port ( );
end Uarttranssim;

architecture Behavioral of Uarttranssim is
--signal
signal clk,reset,tc,tc_start,tc_done_tick : std_logic;
signal din : std_logic_vector(DBIT-1 downto 0);
--constant
constant T : time := 30 ns;
begin
Unit1: entity work.Uarttrans(behavioral) port map(clk => clk, reset => reset, tc => tc, tc_start => tc_start, din 
=> din, tc_done_tick => tc_done_tick);
--clock
clock:process
 begin
 clk <= '1';
wait for T/2;
clk <= '0';
wait for T/2;
 end process;
--reset
rst : process
 begin
 reset <= '0';
wait for T;
reset <= '1';
tc_start <= '1';
wait;
 end process;
data : process
 begin
 din <= x"ac";
 wait for (2 * T);
 din <= x"50";
 wait for (2 * T);
  din <= x"ad";
 wait for (2 * T);
 din <= x"8c";
 wait for (2 * T);
 end process;

end Behavioral;