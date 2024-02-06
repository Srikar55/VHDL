library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Fiforcsim is
generic(
          DBITS: integer:= 8
        );  
--  Port ( );
end Fiforcsim;

architecture Behavioral of Fiforcsim is
signal clk,reset,write,read,izfull,izempty : std_logic;
signal din,dout : std_logic_vector(DBITS-1 downto 0);
--constant
constant P : time := 50 ns;

begin
Unit1 : entity work.Fiforc(behavioral) port map(clk => clk, reset => reset, write => write, read => read, izfull => izfull,
 izempty => izempty, din => din, dout => dout);
 
 clock : process
 begin
 clk <= '0';
wait for P/2;
clk <= '1';
wait for P/2;
 end process;

--reset
 rst : process
 begin
 reset <= '0';
 wait for P;
 reset <= '1';
 wait;
 end process;

REa : process
 begin
 wait for P;
 read <= '1';
 wait for  P;
 read <= '1';
 wait for 3 * P;
 read <= '0';
 wait;
 end process;
 
 -- rd_en
 WRi : process
 begin
 wait for 3 * P;
 write <= '1';
 wait for 3 * P;
 write <= '0';
 wait;
 end process;
 
 -- data
 databi : process
 begin 
 wait for P;
 wait until falling_edge(clk); 
 for i in 0 to 20 loop
 din <= x"a5";
 wait for P;
 din <= x"ba";
 wait for P;
 din <= x"dd";
 wait for P;
 din <= x"f1";
 wait for P; 
 end loop; 
 end process; 


end Behavioral;
