library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity uart_reci is
generic(
          DBITS: integer:=8;
          TICK: integer:=16
        );  
--  Port ( );
port(
     clk,reset,rc : in std_logic; 
     rc_done_tick     : out std_logic;
     dout      : out std_logic_vector(DBITS-1 downto 0));
end uart_reci;

architecture Behavioral of uart_reci is
--signal
type state_type is (idle, start, data, stop);   -- states
signal reg_state, next_state : state_type;      
signal regs, nexts : integer range 0 to TICK-1;   -- ticks = 16
signal regn, nextn : integer range 0 to DBITS-1;    -- data bits count = 8
signal regb, nextb : std_logic_vector( DBITS-1 downto 0);    -- data byte buffer containing 8 bits of data
signal s_tick        : std_logic;    -- s_tick from output of baud generator passed as signal into UART_rc
--component Baud Generator
component Baudrategen is
--  Port ( );
port(
     clk,reset: in std_logic;
     s_tick: out std_logic);
end component;
begin
--mod 163 Baud Generator [Calculated from System Clock 50MHz, Baud rate 19200 and number of ticks 16 (50M/(16*19200) = 163)] 
B: Baudrategen port map (clk => clk, reset => reset, s_tick => s_tick);

--process FSMD state and data registers
    process(clk,reset)
    begin
        if(reset = '1') then
            reg_state <= idle;
            regs     <= 0;
            regn     <= 0;
            regb     <= (others => '0');
        elsif(clk'event and clk='1') then
            reg_state <= next_state;
            regs     <= nexts;
            regn     <= nextn;
            regb     <= nextb;
        end if;
    end process;
--next state logic
    process(reg_state, regs, regn, regb, s_tick, rc)
    begin
        nexts <= regs;
        nextn <= regn;
        nextb <= regb;
        rc_done_tick <= '0';
        case reg_state is
            -- idle state
            when idle =>
                if(rc = '0') then
                    next_state <= start;
                    nexts     <= 0;
                else
                    next_state <= idle;
                end if;
            
            -- start state
            when start =>
                if(s_tick = '0') then
                    next_state <= start;
                else
                    if(regs = 7) then
                        next_state <= data;
                        nexts     <= 0;
                    else
                        next_state <= start;
                        nexts     <= regs + 1;
                    end if;
                end if;
            -- data state 
            when data =>
                if(s_tick = '0') then
                    next_state <= data;
                else
                    if(regs = 15) then
                        nexts <= 0;
                        nextb <= rc & regb(7 downto 1);
                        if(regn = 7) then 
                            next_state <= stop;
                            nextn     <= 0;
                        else
                            next_state <= data;
                            nextn     <= regn + 1;
                        end if;
                    else
                        next_state <= data;
                        nexts <= regs + 1;
                    end if;
                end if;
            when stop =>
                if(s_tick = '0') then
                    next_state <= stop;
                else
                    if(regs = 15) then 
                        next_state <= idle;
                        nexts     <= 0;
                        rc_done_tick     <= '1';   -- Rx done bit
                    else
                        next_state <= stop;
                        nexts     <= regs + 1;
                    end if;
                end if;
        end case;
    end process;
    dout <= regb;
end Behavioral;
