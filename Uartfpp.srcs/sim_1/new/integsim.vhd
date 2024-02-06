

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
entity integsim is
generic(w:integer :=8;
        r:integer :=7);
end integsim;

architecture Behavioral of integsim is
component integ
         port(
              clk, reset,rc_in,read: in std_logic;
              empty: out std_logic;
              full_tc,empty_tc: out std_logic;
              w_uart,r_uart: in std_logic;
              en: in std_logic;
              addr: in std_logic_vector(r-1 downto 0);
              dout: out std_logic 
              );
end component;
signal addr: std_logic_vector(6 downto 0) := (others => '0');
signal rc_in: std_logic;
signal empty: std_logic;
signal w_uart:std_logic;
signal r_uart : std_logic;
signal empty_tc : std_logic;
signal full_tc : std_logic;
signal read,clk: std_logic:= '0';

signal reset : std_logic:='1';
signal en: std_logic := '1';
signal dout : std_logic;
constant S : time :=100 ns;

begin
ust: integ port map(
                    addr => addr,
                    rc_in => rc_in,
                    w_uart => w_uart,
                    r_uart => r_uart,
                    full_tc => full_tc,
                    empty => empty,
                    empty_tc => empty_tc,
                    reset => reset,
                    read => read,
                    clk => clk,
                    en => en,
                    dout => dout
                   
                    );
                    
clock:process
  begin
     clk <= '0';
     wait for S/2;
     clk <= '1';
     wait for S/2;
  end process;
  
rst : process
   begin
     reset <= '1';
     wait for S;
     reset <= '0';
     wait;
end process;

Wri : process
  begin
     wait for S;
     w_uart <= '1';
     wait for 33*S;
     w_uart <= '0';
     wait;
   end process;
   
Rea : process
   begin
      wait for (2 * S);
      read <= '1';
      r_uart <= '1';
      wait;
   end process;
   
data : process
  begin
    for i in 0 to 32 loop
      rc_in <= '0';
      wait for (2 * S);
      rc_in <= '0';
      wait for (2 * S);
      rc_in <= '0';
      wait for (2 * S);
      rc_in <= '1';
      wait for (2 * S);
      rc_in <= '1';
      wait for (2 * S);
      rc_in <= '0';
      wait for (2 * S);
      rc_in <= '0';
      wait for (2 * S);
      rc_in <= '1';
      wait for (2 * S);
      rc_in <= '0';
      wait for (2 * S);
      wait for ( 8 * S);
    end loop;
    end process;

end Behavioral;
