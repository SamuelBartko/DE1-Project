----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2021 11:23:49 AM
-- Design Name: 
-- Module Name: timer_enable - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity timer_enable is
    port(
        clk        : in  std_logic;
        reset      : in  std_logic;
        run        : in  std_logic;
        runtime    : out integer
    );
end entity timer_enable;

------------------------------------------------------------------------
-- Architecture body for clock enable
------------------------------------------------------------------------
architecture Behavioral of timer_enable is

    signal s_runtime : integer;
    signal timing : integer:=0;

begin

    p_time_ena : process(clk)
    begin
         if(timing < 100 and reset = '0') then
            timing <= timing + 1;
        elsif(timing = 100 and reset = '0') then 
            s_runtime <= s_runtime + 1;
            timing <= 0;
        elsif (reset = '1') then
                s_runtime <= 0;
                timing <= 0;
        end if;
        runtime <= s_runtime;
    end process p_time_ena;

end architecture Behavioral;