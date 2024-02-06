library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity Fifocontr is
generic (
           DEPTH: integer := 6
); --Fifo Depth is 64 bytes of data

port(
 clk,reset,read,write : in std_logic;
 izfull,izempty : out std_logic;
 waddr,raddr : out std_logic_vector((DEPTH - 1) downto 0)
 ); 

end Fifocontr;

architecture Behavioral of Fifocontr is
signal addrregr, addrnextr : unsigned (DEPTH downto 0); -- 0 to 64 
signal addrregw, addrnextw : unsigned (DEPTH downto 0); -- 0 to 64 
signal izfullflag, izemptyflag : std_logic;
begin
process(clk, reset)
 begin
 if(reset = '1') then
 addrregw <= (others =>'0');
 addrregr <= (others =>'0');
 elsif(rising_edge(clk)) then 
 addrregw <= addrnextw;
 addrregr <= addrnextr;
 end if;
 end process;
 
 -- write address next state logic 
 addrnextw <= addrregw + 1 when (write = '1' and izfullflag = '0') else
 addrregw;
 
 -- full flag logic
 izfullflag <= '1' when (addrregr(DEPTH) /= addrregw(DEPTH)) and (addrregr(DEPTH-1 downto 0) = addrregw(DEPTH-1 downto 0))
  else
 '0';
 
 -- write output logic
 waddr <= std_logic_vector(addrregw(DEPTH - 1 downto 0));
 
 -- full flag output
 izfull <= izfullflag;

 -- read address next state logic
 addrnextr <= addrregr + 1 when (read = '1' and izemptyflag = '0') 
 else
 addrregr;

 -- empty flag logic 
 izemptyflag <= '1' when (addrregr = addrregw) 
 else
 '0';
 
 -- read port output
 raddr <= std_logic_vector(addrregr(DEPTH - 1 downto 0));
 
 -- empty flag output
 izempty <= izemptyflag;
end Behavioral;


