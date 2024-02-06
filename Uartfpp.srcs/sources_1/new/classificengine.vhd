library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity classificengine is
generic(
         W : integer:= 8 );
  Port (
          clk, reset : in std_logic;
          din : in std_logic_vector(W-1 downto 0);
          dout : out std_logic_vector(w-1 downto 0)
  );
end classificengine;
architecture Behavioral of classificengine is
signal regs, nexts: std_logic_vector(W-1 downto 0);
begin
process(clk,reset)
begin
if (reset='1') then
regs <= (others => '0');
end if;
if (clk'event and clk = '1') then
  regs <= nexts;
end if;  
end process;
-- next state
process(din)
begin
if (din >= "00110000" and din <= "00111001") then  -- 0 to 9
  nexts <= "00000001"; 
elsif( din = "00100101" or din = "00101010" or din = "00101011" or din = "00101101" or din = "00101111") then -- %,*,+, -, /
  nexts <= "00000011";
elsif((din >= "01100001" and din <= "01111010") or ( din>= "01000001" and din <= "01011010")) then -- a to z and A to Z
  nexts <= "00000010"; 
else
  nexts <= "00000100";
end if;
end process;
-- output logic    
dout <= regs;
end Behavioral;