library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


use IEEE.NUMERIC_STD.ALL;


entity Uart_rc is
--  Port ( );
port(
     clk,reset,rc_in,read: in std_logic;
     empty : out std_logic;
     rc_out : out std_logic_vector(7 downto 0));
end Uart_rc;

architecture Behavioral of Uart_rc is
--signals 
signal rc_done  : std_logic;
signal full  : std_logic;
signal dout_sig,tcin_sig     : std_logic_vector(7 downto 0);
--components
--Receiver component
component uart_reci
--  Port ( );
port(
     clk,reset,rc : in std_logic; 
     rc_done_tick     : out std_logic;
     dout      : out std_logic_vector(7 downto 0));
end component;


-- FIFO component
component Fiforc is
--generic
generic (DEPTH: integer :=6); --Fifo Depth is 32 bytes of data
--  Port ( );
port(
     clk,reset      : in std_logic;
     din  : in std_logic_vector(7 downto 0);
     write,read        : in std_logic;
     izfull,izempty   : out std_logic;
     dout : out std_logic_vector(7 downto 0));
end component;
begin

Z : uart_reci port map(clk => clk, reset => reset, rc => rc_in,  rc_done_tick => rc_done,
                           dout => dout_sig); 
FifoZ : Fiforc port map (clk => clk, reset => reset, din => dout_sig, write => rc_done, read => read,
                         izfull => full, izempty => empty, dout => rc_out);
end Behavioral;