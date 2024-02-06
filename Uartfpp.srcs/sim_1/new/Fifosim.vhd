library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Fifosim is
generic(
          DBITS: integer:= 8
        );  
--  Port ( );
end Fifosim;

architecture Behavioral of Fifosim is
signal clk,reset,write,read,izfull,izempty : std_logic;
signal din,dout : std_logic_vector(DBITS-1 downto 0);
--constant
constant T : time := 30 ns;

begin
Unit1 : entity work.Fifo(behavioral) port map(clk => clk, reset => reset, write => write, read => read, izfull => izfull,
 izempty => izempty, din => din, dout => dout);
 
 clock : process
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

Wri : process
 begin
 wait for T;
 write <= '1';
 wait for 3 * T;
 write <= '0';
 wait;
 end process;
 
 -- rd_en
 Rea : process
 begin
 wait for 3 * T;
 read <= '1';
 wait for 3 * T;
 read <= '0';
 wait;
 end process;
 
 -- data
 databi : process
 begin 
 wait for T;
 wait until falling_edge(clk); 
 for i in 0 to 32 loop
 din <= x"d1";
 wait for T;
 din <= x"c3";
 wait for T;
 din <= x"cd";
 wait for T;
 din <= x"a9";
 wait for T; 
 end loop; 
 end process; 


end Behavioral;
