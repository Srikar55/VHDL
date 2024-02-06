
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity integ is
generic(w:integer :=8;
        r:integer :=7);
port(
      clk,reset,rc_in,read: in std_logic;
      empty : out std_logic;
      en : in std_logic;
      full_tc,empty_tc : out std_logic;
      w_uart,r_uart : in std_logic;
      addr: in std_logic_vector(r-1 downto 0);
      dout : out std_logic
      );
--  Port ( );
end integ;

architecture Behavioral of integ is
signal reciever: std_logic_vector((w-1) downto 0);
signal transmitter: std_logic_vector((w-1) downto 0);
component Uart_rc is
port(
      clk, reset,rc_in,read: in std_logic;
      empty: out std_logic;
      rc_out: out std_logic_vector(7 downto 0)
      );
end component;
component memory is
    port(
         addr: in std_logic_vector(r-1 downto 0);
         dai: in std_logic_vector(w-1 downto 0);
         read: in std_logic;
         en: in std_logic;
         clk: in std_logic;
         reset: in std_logic;
         dao: out std_logic_vector(w-1 downto 0)
         );
end component;
component uart_tc is
port( 
     clk,rst,w_uart,r_uart : in std_logic;
     tc_in : in std_logic_vector(7 downto 0);
     tc_out, tcdone, full_tc, empty_tc : out std_logic);
end component;
begin
S: Uart_rc port map(
                    read=>read,
                    rc_in=>rc_in,
                    empty=>empty,
                    rc_out=>reciever,
                    clk=>clk,
                    reset=>reset 
                    );
P: memory port map(
                      addr=>addr,
                      dai=>reciever,
                      en=>en,
                      reset=>reset,
                      read=>read,
                      dao=>transmitter,
                      clk=>clk 
                      );
L: uart_tc port map(
                    w_uart=>w_uart,
                    r_uart=>r_uart,
                    tc_in=> transmitter,
                    tc_out => dout,
                    full_tc => full_tc,
                    empty_tc => empty_tc,
                       clk => clk,
                       rst => reset
                       );
                    
end Behavioral;
