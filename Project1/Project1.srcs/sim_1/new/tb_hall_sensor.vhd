----------------------------------------------------------------------------------
-- tb_hall_sensor
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_hall_sensor is
--  Port ( );
end tb_hall_sensor;

architecture Behavioral of tb_hall_sensor is

    -- Local constants
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;
    --Local signals
    signal s_clk_100MHz        : std_logic;            
    signal s_hall_sensor       : std_logic;
    signal s_mode              : std_logic;
    signal s_reset             : std_logic;
begin

    uut_hall_sensor : entity work.hall_sensor
        port map(
             clk            =>  s_clk_100MHz, 
             hall_sensor    =>  s_hall_sensor,
             wheel          =>  250,
             button_mod     =>  s_mode,
             button_reset   =>  s_reset
       );
        

    p_clk_gen : process
    begin
        while now < 2000 ms loop         -- 75 periods of 100MHz clock
            s_clk_100MHz <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_clk_100MHz <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;


        
    
    p_stimulus : process
    begin
        report "Stimulus process started" severity note;
        s_mode <='0';
        s_reset <='0';
        s_hall_sensor <= '0'; wait for 10 ms; 
        s_hall_sensor <= '1'; wait for 30 ns;
        s_hall_sensor <= '0'; wait for 10 ms; 
        s_hall_sensor <= '1'; wait for 30 ns;
        s_hall_sensor <= '0'; wait for 10 ms; 
        s_hall_sensor <= '1'; wait for 30 ns;
        s_hall_sensor <= '0'; wait for 10 ms; 
        s_hall_sensor <= '1'; wait for 30 ns;
        s_hall_sensor <= '0'; wait for 10 ms; 
        s_hall_sensor <= '1'; wait for 30 ns;
        s_hall_sensor <= '0'; wait for 10 ms; 
        s_hall_sensor <= '1'; wait for 30 ns;
        s_hall_sensor <= '0'; 
         
         wait for 8 ms; 
        s_hall_sensor <= '1'; wait for 25 ns;
        s_hall_sensor <= '0'; wait for 8 ms; 
        s_hall_sensor <= '1'; wait for 25 ns;
        s_hall_sensor <= '0'; wait for 8 ms; 
        s_hall_sensor <= '1'; wait for 25 ns;
        s_hall_sensor <= '0'; wait for 8 ms; 
        s_hall_sensor <= '1'; wait for 25 ns;
        s_hall_sensor <= '0'; wait for 8 ms; 
        s_hall_sensor <= '1'; wait for 25 ns;
        s_hall_sensor <= '0'; wait for 8 ms; 
        s_hall_sensor <= '1'; wait for 25 ns;
        s_hall_sensor <= '0'; wait for 8 ms; 
        s_hall_sensor <= '1'; wait for 25 ns;
        s_hall_sensor <= '0'; wait for 8 ms; 
        s_hall_sensor <= '1'; wait for 25 ns;
        s_hall_sensor <= '0'; wait for 8 ms; 
        s_hall_sensor <= '1'; wait for 25 ns;
        s_hall_sensor <= '0'; 
        wait for 5 ms; 
        
        s_hall_sensor <= '1'; wait for 15 ns;
        s_hall_sensor <= '0'; wait for 5 ms; 
        s_hall_sensor <= '1'; wait for 15 ns;
        s_hall_sensor <= '0'; wait for 5 ms; 
        s_hall_sensor <= '1'; wait for 15 ns;
        s_hall_sensor <= '0'; wait for 5 ms; 
        s_hall_sensor <= '1'; wait for 15 ns;
        s_hall_sensor <= '0'; wait for 5 ms; 
        s_hall_sensor <= '1'; wait for 15 ns;
        s_hall_sensor <= '0'; wait for 5 ms; 
        s_hall_sensor <= '1'; wait for 15 ns;
        s_hall_sensor <= '0'; wait for 5 ms; 
        s_hall_sensor <= '1'; wait for 15 ns;
        s_hall_sensor <= '0'; wait for 5 ms; 
        s_hall_sensor <= '1'; wait for 15 ns;
        s_hall_sensor <= '0'; wait for 5 ms; 
        s_hall_sensor <= '1'; wait for 15 ns;
        s_hall_sensor <= '0'; wait for 5 ms; 
        s_hall_sensor <= '1'; wait for 15 ns;
        s_hall_sensor <= '0'; wait for 5 ms; 
        s_hall_sensor <= '1'; wait for 15 ns;
        s_hall_sensor <= '0'; wait for 5 ms; 
        s_hall_sensor <= '1'; wait for 15 ns;
        s_hall_sensor <= '0'; 
         wait for 5 ms; 
         
       
         
        
            
        report "Stimulus process finished" severity note;
    end process p_stimulus;

end Behavioral;