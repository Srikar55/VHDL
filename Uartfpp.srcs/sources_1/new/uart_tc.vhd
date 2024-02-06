library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity uart_tc is
--  Port ( );
port( 
      clk,rst,w_uart,r_uart       : in std_logic;
      tc_in                       : in std_logic_vector(7 downto 0);
      tc_out,tcdone,full_tc,empty_tc          : out std_logic);
end uart_tc;

architecture Behavioral of uart_tc is
--signals

signal tc_start                            : std_logic;
signal tcin_sig                            : std_logic_vector(7 downto 0);
signal tcdonesig                           : std_logic;
--components
--Transmitter component
component Uarttrans
--  Port ( );
port(
     clk,reset,tc_start   : in std_logic;
     din                 : in std_logic_vector(7 downto 0);
     tc_done_tick,tc       : out std_logic);    
end component;
-- FIFO component
component Fifo is
--generic
generic (
DEPTH: integer := 6;
DBITS: integer := 8
);
port(
     clk,reset      : in std_logic;
     din  : in std_logic_vector(7 downto 0);
     write,read   : in std_logic;
     izfull,izempty   : out std_logic;
     dout : out std_logic_vector(7 downto 0));
end component;

begin

tc_start      <= '1' when r_uart = '1' else
                  '0';

 Fifot : Fifo port map (clk => clk, reset => rst, din => tc_in, write => w_uart, read => r_uart, izfull => full_tc, 
                          izempty => empty_tc, dout => tcin_sig); 
 T       : Uarttrans port map (clk => clk, reset => rst, tc_start => tc_start, din => tcin_sig, tc_done_tick => tcdonesig, tc => tc_out);
  
--output logic
tcdone <= tcdonesig; 
end Behavioral;
