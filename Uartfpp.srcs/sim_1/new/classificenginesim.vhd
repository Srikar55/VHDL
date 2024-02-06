library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity classificenginesim is
generic(
         W : integer:= 8 );
end classificenginesim;
architecture Behavioral of classificenginesim is
signal clk,reset : std_logic;
signal din,dout :  std_logic_vector(W-1 downto 0);
constant O : time := 100 ns;
begin
p0: entity work.classificengine(Behavioral) port map(clk => clk, reset => reset, din => din, dout => dout);

clck:process
 begin
clk <= '0';
wait for O/2;
clk <= '1';
wait for O/2;
end process;
sim : process
 begin
 reset <= '1';
wait for O/2;
reset <= '0';
wait;
end process;

datain: process
begin
din <= "11111110";
wait for 100ns;
din <= "01000010";  -- B character
wait for 100 ns;
din <= x"31";      -- 1 character
wait for 100 ns;
din <= x"2b";      -- + character
wait for 100 ns;
din <= x"24";      -- $ character
wait for 100 ns;
din <= x"25";      -- % character
wait for 100 ns;
din <= x"41";      -- A character
wait for 100 ns;
din <= x"2a";      -- * character
wait for 100 ns;
din <= x"61"; 
wait;
end process;
end Behavioral;