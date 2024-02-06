library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity Uarttrans is
generic(
DBIT: integer := 8;
SB_TICK: integer := 16
);
 Port (
        clk,reset,tc_start : in std_logic;
        din: in std_logic_vector(DBIT-1 downto 0);
        tc_done_tick, tc: out std_logic
  );
end Uarttrans;

architecture Behavioral of Uarttrans is
type state_type is (idle, start, data, stop);
signal reg_state, next_state: state_type;
signal regs, nexts : integer range 0 to SB_TICK-1; -- ticks = 16
signal regn, nextn : integer range 0 to DBIT-1; -- data bits count = 8
signal regb, nextb: std_logic_vector(7 downto 0);
signal tc_reg, tc_next: std_logic;
signal s_tick : std_logic; 

component Baudrategen is
-- Port ( );
port(
 clk,reset: in std_logic;
 s_tick: out std_logic);
end component;
begin
Baudrate: Baudrategen port map (clk => clk, reset => reset, s_tick => s_tick);
--process FSMD state and data registers
 process(clk,reset)
 begin
 if(reset = '1') then
 reg_state <= idle;
 regs <= 0;
 regn <= 0;
 regb <= (others => '0');
 tc_reg <= '1';
 elsif(rising_edge(clk)) then
 reg_state <= next_state;
 regs <= nexts;
 regn <= nextn;
 regb <= nextb;
 tc_reg <= tc_next;
 
 end if;
 end process;
 
 --next state logic
process (reg_state, regs, regn, regb, s_tick, tc_reg, tc_start, din)
 begin
 next_state <= reg_state;
 nexts <= regs;
 nextn <= regn;
 nextb <= regb;
 tc_next<= tc_reg; 
 tc_done_tick <= '0';
 
 case reg_state is
 -- idle state
 when idle =>
 tc_next <= '1'; 
 if(tc_start = '1') then
 next_state <= start;
 nexts <= 0;
 nextb <= din;
 else
 next_state <= idle;
 end if;
 --start state
 when start =>
 tc_next <= '0'; 
 if(s_tick = '0') then
 next_state <= start;
 else
 if(regs = (SB_TICK-1)) then --slowing down the baud tick
 next_state <= data;
 nexts <= 0;
 nextn <= 0;
 else
 next_state <= start;
 nexts <= regs + 1;
 end if;
 end if;
 
 -- data state
 when data =>
 tc_next <= regb(0);
 
 if(s_tick = '0') then
 next_state <= data;
 else
 if(regs = (SB_TICK-1)) then
 nexts <= 0;
 nextb <= '0' & regb(7 downto 1);
 if(regn =(DBIT - 1) ) then 
 next_state <= stop;
 nextn <= 0;
 else
 next_state <= data;
 nextn <= regn + 1;
 end if;
 else
 nexts <= regs + 1;
 end if;
 end if;
 
-- stop state
 when stop =>
 tc_next <= '1'; 
 if(s_tick = '0') then
 next_state <= stop;
 else
 if(regs = (SB_TICK-1)) then 
 next_state <= idle;
 tc_done_tick <= '1';  -- Tx done bit
 nexts <= 0; 
 else
 next_state <= stop;
 nexts <= regs + 1;
 end if;
 end if;
end case;
end process;
 
 -- output logic
 tc <= tc_reg; 
end Behavioral;

