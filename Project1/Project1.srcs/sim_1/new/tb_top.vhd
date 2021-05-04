----------------------------------------------------------------------------------
-- tb_top
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

entity tb_top is
--  Port ( );
end tb_top;

architecture Behavioral of tb_top is

    -- Local constants
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;

    --Local signals
    signal s_clk_100MHz  : std_logic;
            
    signal s_reset       : std_logic;
    signal s_mode        : std_logic;
    signal s_dis_reset   : std_logic;
    
    signal s_dp_i        : std_logic_vector(4 - 1 downto 0);
    signal s_dp_o        : std_logic;
    signal s_seg_o       : std_logic_vector(7 - 1 downto 0);
    signal s_dig         : std_logic_vector(4 - 1 downto 0);
    
    signal s_number     : integer range 0 to 9999;
    
    signal s_hall        : std_logic;

begin

    -- Connecting testbench signals with driver_7seg_4digits entity
    uut_driver_7seg: entity work.driver_7seg
        port map(
            clk => s_clk_100MHz,
            reset => s_reset,

            dp_i => "1110",

            dp_o  => s_dp_o,
            seg_o => s_seg_o,
            dig_o => s_dig,
            
            decimal => s_number
        );
      
    -- Connecting testbench signals with hall entity  
    uut_hall : entity work.hall_sensor
        port map(
            clk => s_clk_100MHz,
            
            hall_sensor      => s_hall,
            wheel            => 250,              --250cm
            button_mod       => s_mode,
            button_reset     => s_dis_reset,
            
            output_o => s_number
        );

    --------------------------------------------------------------------
    -- Clock generation process
    --------------------------------------------------------------------
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

    --------------------------------------------------------------------
    -- Reset generation process
    --------------------------------------------------------------------
    p_reset_gen : process
    begin
        s_reset <= '0';
        wait for 28 ns;
        
        -- Reset activated
        s_reset <= '1';
        wait for 53 ns;

        s_reset <= '0';
        wait;
        
    end process p_reset_gen;
    
    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
      p_stimulus : process
    begin
        report "Stimulus process started" severity note;

        -- reset all local signals
        s_hall <= '0';
        s_mode <= '0';
        s_dis_reset <= '0';
        wait for 20 ns;

       --set speed 
        while(now < 70 ms) loop
            
            s_hall <= '1';
            wait for 35 ns;
            s_hall <= '0';
            wait for 4 ms;
            
        end loop; 
        
        -- change mode
        s_mode <= '1';
        wait for 25 ns;
        s_mode <= '0';
        
      
        while(now < 800 ms) loop
            
            s_hall <= '1';
            wait for 50 ns;
            s_hall <= '0';
            wait for 7 ms;
            
        end loop; 
        
        -- change mode
        s_mode <= '1';
        wait for 20 ns;
        s_mode <= '0';
        
        -- set speed
        while(now < 100 ms) loop
            
            s_hall <= '1';
            wait for 40 ns;
            s_hall <= '0';
            wait for 8 ms;
            
        end loop;
        
       
        s_dis_reset <= '1';
        wait for 25 ns;
        s_dis_reset <= '0';
        
        --set speed
        while(now < 150 ms) loop
            
            s_hall <= '1';
            wait for 20 ns;
            s_hall <= '0';
            wait for 4 ms;
            
        end loop;
         
      
        s_hall <= '1';
        wait for 30 ns;
        s_hall <= '0';
        wait for 10 ms;
        

        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;

end Behavioral;
