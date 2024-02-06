library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity uart_recisim is
--  Port ( );
end uart_recisim;

architecture Behavioral of uart_recisim is

--signal
signal clk,reset,rc,rc_done_tick : std_logic;
signal dout : std_logic_vector(7 downto 0);
--constant
constant T : time := 30 ns;
begin
--port map
UST: entity work.uart_reci(behavioral) port map(clk => clk, reset => reset, rc => rc, dout => 
dout, rc_done_tick => rc_done_tick);
--clock
clock:process
 begin
 clk <= '0';
wait for T/2;
clk <= '1';
wait for T/2;
 end process;
--reset
rst : process
 begin
 reset <= '1';
wait for T*50;
reset <= '0';
wait;
 end process;
--data bits
data : process
 begin
 rc <= '1';
 wait for (2 * T);
 rc <= '1';
 wait for (2 * T);
 rc <= '1';
 wait for (2 * T);
 rc <= '0';
 wait for (2 * T);
 rc <= '1';
 wait for (2 * T);
 rc <= '0';
 wait for (2 * T);
 rc <= '1';
 wait for (2 * T);
 rc <= '1';
 wait for (2 * T);
 rc <= '0';
 wait for (2 * T);
 end process;
end Behavioral;
