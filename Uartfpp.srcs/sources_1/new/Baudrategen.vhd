library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Baudrategen is
generic(
          Q: integer := 27  -- for baud rate of 115200 
          -- 115200*16 = 1843200   (50MHz/1843200)=27
        );  
port(
     clk,reset: in std_logic;
     s_tick: out std_logic);
end Baudrategen;

architecture Behavioral of Baudrategen is
signal regr,nextr : integer range 0 to Q-1;
begin
    --process block
    process(clk,reset)
    begin
        if(reset = '1') then
            regr <= 0;
        elsif(clk'event and clk='1') then 
            regr <= nextr;
        end if;      
    end process;
--next state logic
    nextr <= 0 when regr = Q else
                 regr + 1;
--output logic
    s_tick <= '1' when regr = Q else
              '0';
end Behavioral;


