----------------------------------------------------------------------------------
-- hall_sensor
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-----------------------------------------
entity hall_sensor is
    port(
            clk              : in std_logic;  -- Main clock
            hall_sensor      : in std_logic;  -- hall signal
           
            button_mod       : in std_logic;  -- change mode between speed and distance
            button_reset     : in std_logic;  -- reset button
            
            wheel    : in integer;
            output_o         : out integer
        );
end hall_sensor;

architecture Behavioral of hall_sensor is
    signal s_speed      : integer:=0;
    signal s_distance   : integer:=0;           
    signal s_time       : integer;              --time for rotation
    signal s_mode       : std_logic;            --mode 0 or 1
    signal s_reset      : std_logic;            --reset
    signal s_run        : std_logic;
      

begin

    time_stop : entity work.timer_enable
        port map(
            
            clk     => clk,
            reset   => s_reset,
            runtime => s_time,
            run     => s_run
        );
    measure_distance : process(clk, hall_sensor)    --calculate distance using signal from hall sensor
    begin
    
        if (rising_edge(hall_sensor)) then
        
            s_distance <= s_distance + (wheel );
            
        end if;
        
        if (rising_edge(button_reset)) then
            s_distance <= 0;
        end if;
        
    end process;
    measure_speed : process(clk)       --calculate speed using 
    begin
    
        if (s_reset = '1') then 
            s_reset <= '0';
        end if;
    
        if (rising_edge(hall_sensor)) then
            s_speed <= (wheel*1000) / (s_time + 1); 
                 
            s_reset <= '1';
        end if;
        
    end process;
    

    change_mod : process(clk)
    begin
    
        if (rising_edge(button_mod)) then
            s_mode <= not(s_mode);
        end if;
  
        case s_mode is
            when '1' =>
                output_o <= s_distance;      
            when '0' =>
                output_o <= s_speed;
            when others =>
                output_o <= s_distance;
        end case;
        
    end process;

end Behavioral;
