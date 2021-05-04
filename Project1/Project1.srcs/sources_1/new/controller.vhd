
-- timer_enable
---------------------------------------------------------------------------

library ieee;               -- Standard library
use ieee.std_logic_1164.all;-- Package for data types and logic operations
use ieee.numeric_std.all;   -- Package for arithmetic operations

------------------------------------------------------------------------
-- Entity declaration for clock enable
------------------------------------------------------------------------
entity timer_enable is
    port(
        clk          : in  std_logic;    -- Main clock
        reset        : in  std_logic;    -- Synchronous reset
        start        : in  std_logic;    --input timer
        starting     : out integer       --out time
    );
end entity timer_enable;

------------------------------------------------------------------------
-- Architecture body for clock enable
------------------------------------------------------------------------
architecture Behavioral of timer_enable is

    signal s_strating       : integer:=0;
    signal clock_nam        : integer:=0; 

begin

    p_time_ena : process(clk)
    begin
    
        if(clock_nam < 100 and reset = '0') then
            clock_nam <= clock_nam + 1;
        elsif(clock_nam = 100 and reset = '0') then 
            s_strating <= s_strating + 1;
            clock_nam <= 0;
        elsif (reset = '1') then
                s_strating <= 0;
                clock_nam <= 0;
        end if;
        
        starting <= s_strating;
        
    end process p_time_ena;

end architecture Behavioral;
