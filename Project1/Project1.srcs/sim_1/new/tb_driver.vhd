----------------------------------------------------------------------------------
--tb_driver
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------------------
entity tb_driver is
    -- Entity of testbench is always empty
end entity tb_driver;

------------------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------------------
architecture testbench of tb_driver is

    -- Local constants
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;

    --Local signals
    signal s_clk_100MHz : std_logic;
     -- signal s_clk
            
    signal s_reset      : std_logic;    
    signal s_dp_i       : std_logic_vector(4 - 1 downto 0);
    signal s_seg_o      : std_logic_vector(7 - 1 downto 0);
    signal s_dig0       : std_logic_vector(0 downto 0);
    signal s_dig1       : std_logic_vector(0 downto 0);
    signal s_dp_o       : std_logic;
    signal s_decimal    : integer range 0 to 9999;
    
begin
    -- Connecting testbench signals with driver_7seg_4digits entity
    -- (Unit Under Test)
    --- WRITE YOUR CODE HERE
        
    uut_driver_7seg_4digits : entity work.driver_7seg
        port map(
            clk   => s_clk_100MHz,
            reset => s_reset,
            dp_i  => s_dp_i,
            dp_o  => s_dp_o,
            seg_o => s_seg_o,
            dig_o => s_dig,
            
            decimal => s_decimal
        );

    --------------------------------------------------------------------
    -- Clock generation process
    --------------------------------------------------------------------
    p_clk_gen : process
    begin
        while now < 5 ms loop         -- 75 periods of 100MHz clock
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
        -- Reset deactivated   
        s_reset <= '0';
        wait for 60 ns;
     
        -- Reset activated
        s_reset <= '1';
        wait for 15 ns;
        -- Reset deactivated
        s_reset <= '0';
        wait;
        
    end process p_reset_gen;

    --------------------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------------------
    p_stimulus : process
    begin
        report "Stimulus process started" severity note;
        

        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;
end architecture testbench;
