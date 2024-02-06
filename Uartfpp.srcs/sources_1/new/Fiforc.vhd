
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Fiforc is
generic (
DEPTH: integer := 6;
DBITS: integer := 8
); --Fifo Depth is 64 bytes of data

port(
 clk,reset : in std_logic;
 din : in std_logic_vector(DBITS-1 downto 0);
 write,read : in std_logic;
 izfull,izempty : out std_logic;
 dout : out std_logic_vector(DBITS-1 downto 0));

end Fiforc;

architecture Behavioral of Fiforc is
signal addrsigw,addrsigr : std_logic_vector((DEPTH - 1) downto 0);
signal ensigw, ensigr, izfullsig, izemptysig, read_sig, write_sig : std_logic;

--fifo controller component 
component Fifocounrc is
generic (DEPTH: integer := 6); --Fifo Depth is 64 bytes of data
port(
 clk,reset,read,write : in std_logic;
 izfull,izempty : out std_logic;
 waddr,raddr : out std_logic_vector((DEPTH - 1) downto 0)
 ); 
end component;

-- fifo buffer
component Regfilerc is
--generic
generic ( 
          DEPTH: integer := 6;
          DBITS: integer := 8
         ); 

port(
 clk,reset : in std_logic;
 din : in std_logic_vector(DBITS-1 downto 0);
 waddr,raddr : in std_logic_vector((DEPTH - 1) downto 0);
 w_en,r_en : in std_logic;
 dout : out std_logic_vector(DBITS-1 downto 0));
end component;
begin

Controller : Fifocounrc port map (clk => clk, reset => reset, read => read, write => write, izfull => izfullsig, izempty => 
izemptysig, waddr => addrsigw, raddr => addrsigr);

Reg : Regfilerc port map (clk => clk, reset => reset, din => din, waddr => addrsigw,
 raddr => addrsigr, w_en => ensigw, r_en => ensigr, dout => dout);

 -- r_en
 ensigr <= '1' when (read_sig = '1' and izemptysig = '0' ) 
 else
 '0'; 
 -- w_en
 ensigw <= '1' when (write_sig = '1' and izfullsig = '0')
  else
 '0';
 -- output logic
 izfull <= izfullsig;
 izempty <= izemptysig;
 read_sig <= read;
 write_sig <= write;
 
end Behavioral;
