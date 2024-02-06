library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Uart_rcsim is
--  Port ( );
end Uart_rcsim;

architecture Behavioral of Uart_rcsim is
--signal
signal clk,reset,rc,read     : std_logic;
signal dout                    : std_logic_vector(7 downto 0);
--constant
constant T : time := 30 ns;
begin
--port map
UUT: entity work.Uart_rc(behavioral) port map(clk => clk, reset => reset, rc_in => rc, read => read,
                                                    rc_out => dout);
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
	wait for T;
	reset <= '0';
	wait;
  end process;
  
-- read_enable
 Rea: process
    begin
        wait for (2 * T);
        read <= '1';
        wait for (2 * T);
        read <= '0';
        wait;
    end process;
    
--data bits
databi  : process
    begin
      for i in 0 to 32 loop
        rc <= '1';
        wait for (3 * T);
        rc <= '0';
        wait for (3 * T);
        rc <= '1';
        wait for (3 * T);
        rc <= '1';
        wait for (3 * T);
        rc <= '1';
        wait for (3 * T);
        rc <= '0';
        wait for (3 * T);
        rc <= '0';
        wait for (3 * T);
        rc <= '0';
        wait for (3 * T);
        rc <= '1';
        wait for (3 * T);
        
        rc <= '1';
        wait for (3 * T);
        rc <= '1';
        wait for (3 * T);
        rc <= '0';
        wait for (3 * T);
        rc <= '0';
        wait for (3 * T);
        rc <= '0';
        wait for (3 * T);
        rc <= '1';
        wait for (3 * T);
        rc <= '0';
        wait for (3 * T);
        rc <= '0';
        wait for (3 * T);
        rc <= '1';
        wait for (3 * T);
        
        rc <= '0';
        wait for (3 * T);
        rc <= '1';
        wait for (3 * T);
        rc <= '1';
        wait for (3 * T);
        rc <= '1';
        wait for (3 * T);
        rc <= '0';
        wait for (3 * T);
        rc <= '0';
        wait for (3 * T);
        rc <= '1';
        wait for (3 * T);
        rc <= '0';
        wait for (3 * T);
        rc <= '0';
        wait for (3 * T);
        wait for (2 * T);
     end loop;
    end process;
end Behavioral;

