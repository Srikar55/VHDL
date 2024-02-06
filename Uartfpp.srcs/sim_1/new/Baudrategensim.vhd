library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Baudrategensim is
--  Port ( );
end Baudrategensim;

architecture Behavioral of Baudrategensim is

signal clk,reset,s_tick_internal : std_logic;
constant t : time := 30 ns;
begin
p0:entity work.Baudrategen(Behavioral) port map(clk => clk, reset => reset, s_tick_internal => s_tick_internal); 
clck:process
 begin
clk <= '1';
wait for t/2;
clk <= '0';
wait for t/2;
end process;
sim : process
 begin
 reset <= '1';
wait for t;
reset <= '0';
wait;
end process;
end Behavioral;

