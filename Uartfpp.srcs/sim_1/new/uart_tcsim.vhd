
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity uart_tcsim is
--  Port ( );
end uart_tcsim;

architecture Behavioral of uart_tcsim is
signal clk, rst, tc_out, w_uart, r_uart : std_logic;
signal tc_in                            : std_logic_vector(7 downto 0);
--constant
constant T : time := 100 ns;
begin
--port map
UST: entity work.uart_tc(behavioral) port map(clk => clk, rst => rst, tc_in => tc_in, w_uart => w_uart, r_uart => r_uart , tc_out => tc_out);
--clock
clock:process
  begin
    clk <= '0';
	wait for T/2;
	clk <= '1';
	wait for T/2;
  end process;
--reset
reset : process
  begin
    rst <= '0';
	wait for T;
	rst <= '0';
	wait;
  end process;
-- write enable
 Wri : process
     begin
         wait for T;
         w_uart <= '0';
         wait for 3 * T;
         w_uart <= '1';
         wait;
     end process;
     
 -- read_enable
 Rea: process
    begin
        wait for (3 * T);
        r_uart <= '1';
        wait;
    end process;
    
--data bits
databi  : process
  begin
      wait for T;
      wait until falling_edge(clk);
      tc_in <= x"11";
      for i in 0 to 18 loop
          wait for T;
          tc_in <= std_logic_vector(unsigned(tc_in) + 1);
      end loop;    
  end process;
end Behavioral;
