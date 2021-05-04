----------------------------------------------------------------------------------
-- driver_7seg
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
-- Entity declaration for display driver
------------------------------------------------------------------------
entity driver_7seg is
    port(
        clk     : in  std_logic;                        -- main clock
        reset   : in  std_logic;                        -- synchronous reset
        

        decimal : in integer range 0 to 9999;           -- number to display
        -- decimal point for specific digit
        dp_o    : out std_logic;                       
        -- cathode output for individual segments
        seg_o   : out std_logic_vector(7 - 1 downto 0); 
        -- 4 bit value input for decimal point
        dp_i    : in  std_logic_vector(4 - 1 downto 0); 
        -- common anode signals output to individual displays
        dig0_o   : out std_logic_vector;
		dig1_o   : out std_logic_vector
    );
end entity driver_7seg;

------------------------------------------------------------------------
-- Architecture with signals declaration
------------------------------------------------------------------------
architecture Behavioral of driver_7seg is

    signal s_en  : std_logic;                        -- internal clock enable
    signal s_cnt : std_logic_vector(2 - 1 downto 0); -- internal 2-bit counter for multiplexing 4 digits

    signal s_hex     : integer range 0 to 9999;      -- internal integer value for 7 segment decoder
    signal s_decimal : integer range 0 to 9999;      -- internal integer value for displaying digits
    
    signal s_data0_i : integer range 0 to 9999; --(for 4 numbers)
    signal s_data1_i : integer range 0 to 9999; --(for 4 numbers)
    signal s_data2_i : integer range 0 to 9999; --(for 4 numbers)
    signal s_data3_i : integer range 0 to 9999; --(for 4 numbers)
    
    signal buf1      : integer:=0;
    signal buf2      : integer:=0;
    signal first     : integer:=0;
    signal second    : integer:=0;
    signal third     : integer:=0;
    signal fourth    : integer:=0;  
   -----------------------------------------------------------------------
   
    
    

begin

    s_decimal <= decimal;
    
    -- instance copy of clock_enable entity
    clk_en : entity work.clock_enable
        generic map(
            g_MAX => 4
        )
        port map(
            clk   => clk,
            reset => reset,
            ce_o  => s_en
        );

    -- instance copy of hex_7seg entity
    hex2seg : entity work.hex_7seg
        port map(
            num_i => s_hex,
            seg_o => seg_o
        );
        
    -- instance copy of cnt_up_down entity
    bin_cnt : entity work.cnt_up_down
        generic map(
            g_CNT_WIDTH => 2
       )
        port map(
            clk  => clk,
            reset  => reset,
            en_i  => s_en,
            cnt_up_i  => '0',
            cnt_o  => s_cnt
        );

------------------------------------------------------------------------
-- Process p_mux_dec:
-- s_decimal integer number split to digits
-- writing digits to s_data and display them on 7 segment display using hex_7seg
------------------------------------------------------------------------
    p_mux_dec : process(clk, s_decimal)    
    begin
        if(buf2 /= s_decimal) then
            buf2 <= s_decimal;
            buf1 <= 0;
        end if;

        if(s_decimal >= (buf1 + 1000)) then
            buf1 <= buf1 + 1000;
            fourth <= fourth + 1;
            
        elsif(s_decimal >= (buf1 + 100)) then 
            buf1 <= buf1 + 100;
            third <= third + 1;
            
        elsif(s_decimal >= (buf1 + 10)) then 
            buf1 <= buf1 + 10;
            second <= second + 1;
            
        elsif(s_decimal >= (buf1 + 1)) then 
            buf1 <= buf1 + 1;
            first <= first + 1;
            
        end if;


        
        if(s_decimal = buf1) then
            
            s_data3_i <= fourth;   --write fourth number to data3
            s_data2_i <= third;    --write third number to data2
            s_data1_i <= second;   --write second number to data1
            s_data0_i <= first;    --write first number to data0
            
            -- clear buffer and digits
            buf1 <= 0;  
            fourth <= 0;
            third <= 0;
            second <= 0;
            first <= 0;
        end if;
        
    end process p_mux_dec;
    
--------------------------------------------------------------------
-- Process p_mux:
-- A combinational process that implements a multiplexer for
-- selecting data for a single digit, a decimal point signal, and 
-- switches the common anodes of each display.
--------------------------------------------------------------------
    p_mux : process(s_cnt, data0_i, data1_i, data2_i, data3_i, dp_i)
    begin
        case s_cnt is
            when "11"  =>
                s_hex  <= data3_i;
                dp_o   <= dp_i(3);
                dig1_o <= "1";
				

            when "10" =>
                s_hex <= data2_i;
                dp_o  <= dp_i(2);
                dig1_o <= "0";

            when "01" =>
                s_hex <= data1_i;
                dp_o  <= dp_i(1);
				dig0_o <= "1";

            when others =>
                s_hex <= data0_i;
                dp_o  <= dp_i(0);
                dig0_o <= "0";
                
        end case;

end architecture Behavioral;
