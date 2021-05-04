# Console for exercise bike/bike

### Team members

* Mohamad Alkanan
* Tarik Alkanan
* Dominik Baláž
* Samuel Bartko

[Link to your GitHub project folder](https://github.com/SamuelBartko/DE1-Project/blob/main/README.md)

### Project objectives

Project goal is to implement console for exercise bike or bike onto board Arty A7-35T. It should be using hall sensor to messure rotations of bike wheel. From rotation we should count and display  speed, distance traveled. The information of the speed and distance should shown on connect 7 segment displays.

## Hardware description

### (1).Board used for this is Arty A7: Artix-7. The picture under shows the board with marked components. 
![Board](Images/arty-a7.png)

<div class="table sectionedit3"><table class="inline">
	<thead>
	<tr class="row0">
		<th class="col0 leftalign"> Callout  </th><th class="col1 leftalign"> Description                              </th><th class="col2 leftalign"> Callout  </th><th class="col3 leftalign"> Description                           </th><th class="col4 leftalign"> Callout  </th><th class="col5 leftalign"> Description                               </th>
	</tr>
	</thead>
	<tr class="row1">
		<td class="col0 leftalign"> 1        </td><td class="col1 leftalign"> FPGA programming DONE <abbr title="Light Emitting Diode">LED</abbr>                </td><td class="col2 leftalign"> 8        </td><td class="col3 leftalign"> User RGB LEDs                         </td><td class="col4 leftalign"> 15       </td><td class="col5 leftalign"> chipKIT processor reset                   </td>
	</tr>
	<tr class="row2">
		<td class="col0 leftalign"> 2        </td><td class="col1 leftalign"> Shared USB JTAG / UART port              </td><td class="col2 leftalign"> 9        </td><td class="col3 leftalign"> User slide switches                   </td><td class="col4 leftalign"> 16       </td><td class="col5 leftalign"> Pmod connectors                           </td>
	</tr>
	<tr class="row3">
		<td class="col0 leftalign"> 3        </td><td class="col1 leftalign"> Ethernet connector                       </td><td class="col2 leftalign"> 10       </td><td class="col3 leftalign"> User push buttons                     </td><td class="col4 leftalign"> 17       </td><td class="col5 leftalign"> FPGA programming reset button             </td>
	</tr>
	<tr class="row4">
		<td class="col0 leftalign"> 4        </td><td class="col1 leftalign"> MAC address sticker                      </td><td class="col2 leftalign"> 11       </td><td class="col3 leftalign"> Arduino/chipKIT shield connectors     </td><td class="col4 leftalign"> 18       </td><td class="col5 leftalign"> SPI flash memory                          </td>
	</tr>
	<tr class="row5">
		<td class="col0 leftalign"> 5        </td><td class="col1 leftalign"> Power jack for optional external supply  </td><td class="col2 leftalign"> 12       </td><td class="col3 leftalign"> Arduino/chipKIT shield SPI connector  </td><td class="col4 leftalign"> 19       </td><td class="col5 leftalign"> Artix FPGA                                </td>
	</tr>
	<tr class="row6">
		<td class="col0 leftalign"> 6        </td><td class="col1 leftalign"> Power good <abbr title="Light Emitting Diode">LED</abbr>                           </td><td class="col2 leftalign"> 13       </td><td class="col3 leftalign"> chipKIT processor reset jumper        </td><td class="col4 leftalign"> 20       </td><td class="col5 leftalign"> Micron DDR3 memory                        </td>
	</tr>
	<tr class="row7">
		<td class="col0 leftalign"> 7        </td><td class="col1 leftalign"> User LEDs                                </td><td class="col2 leftalign"> 14       </td><td class="col3 leftalign"> FPGA programming mode                 </td><td class="col4 leftalign"> 21       </td><td class="col5 leftalign"> Dialog Semiconductor DA9062 power supply  </td>
	</tr>
</table></div>

### (2).Hall sensor (module KY-024)                   (3). Seven segmet display.


[link for hall sensor](https://dratek.cz/arduino/7702-halluv-senzor-modul-ky-024.html?gclid=Cj0KCQjwvr6EBhDOARIsAPpqUPFmX-NV1Sm-jNOxffSL-m0-NFdAKmShf-2nILrmdBjUIOiNXTs1npMaAtw9EALw_wcB)\
[Link for display ](https://store.digilentinc.com/pmod-ssd-seven-segment-display/)

![Sensor](https://github.com/SamuelBartko/DE1-Project/blob/main/Images/2562.jpg)   

The board Arty A7-35T doesn't have 7 digit display to display infromation or the hall sensor needed for detecing rotations of the bike wheel.
So we added these componnents moduls. They are connected to the board through pins show on diagram or in the table.

## The wiring diagram looks like this.
![Board](https://github.com/SamuelBartko/DE1-Project/blob/main/Images/12.jpg)
### Tables with connections on Board
| **Hall sensor connector** | **Pin on board** |
| :-: | :-: |
| Digital Out | IO1 |
| Analog Out | A2 |
| VCC | 5V0 |
| Ground | GND |

***On animation below, you can see how does hall sensor work*** \
![](https://github.com/SamuelBartko/DE1-Project/blob/main/Images/Webp.net-gifmaker_1.gif)

### Tables with connections for Seven segment display on Board
| 7 segment connectors | Pin on board |
| :-: | :-: |
| AA | D13 |
| AB | B18 |
| AC | K16 |
| AD | J17 |
| UCC | VCC |
| GND| GND |
| AE | J17 |
| AF | J18 |
| AG | K15 |
| CAT | J15 |
| CAT | G2 |

## VHDL modules description and simulations

### (1.) Modul `clock_enable`
```vhdl

---------------------------------------------------------------------------
---clock_enable
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_enable is
    generic(
        g_MAX : natural := 10       -- Number of clk pulses to generate                                   
    );  
    port(
        clk    : in  std_logic;      -- Main clock
        reset  : in  std_logic;      -- Synchronous reset
        ce_o   : out std_logic       -- Clock enable pulse signal
    );
end entity clock_enable;

------------------------------------------------------------------------
-- Architecture body for clock enable
------------------------------------------------------------------------
architecture behavioral of clock_enable is
     -- Local counter
    signal s_cnt_local : natural;

begin
    --------------------------------------------------------------------
    -- p_clk_ena:
    -- Generate clock enable signal. By default, enable signal is low 
    -- and generated pulse is always one clock long.
    --------------------------------------------------------------------
    p_clk_ena : process(clk)
    begin
        if rising_edge(clk) then                        -- Synchronous process

            if (reset = '1') then                       -- High active reset
                s_cnt_local <= 0;                       -- Clear local counter
                ce_o        <= '0';                     -- Set output to low

           -- Test number of clock periods
            elsif (s_cnt_local >= (g_MAX - 1)) then
                s_cnt_local  <= 0;                      -- Clear local counter
                ce_o         <= '1';                    -- Generate clock enable pulse

            else
                s_cnt_local <= s_cnt_local + 1;
                ce_o        <= '0';
            end if;
        end if;
    end process p_clk_ena;

end architecture behavioral;
```

### (2.) Modul `driver_7seg_4digits`
```vhdl

------------------------------------------------------------------------
--
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
-- Entity declaration for display driver
------------------------------------------------------------------------
entity driver_7seg_4digits is
    port(
        clk     : in  std_logic;        -- Main clock
        reset   : in  std_logic;        -- Synchronous reset
        -- 4-bit input values for individual digits
        data0_i : in  std_logic_vector(4 - 1 downto 0);
        data1_i : in  std_logic_vector(4 - 1 downto 0);
        data2_i : in  std_logic_vector(4 - 1 downto 0);
        data3_i : in  std_logic_vector(4 - 1 downto 0);
        -- 4-bit input value for decimal points
        dp_i    : in  std_logic_vector(4 - 1 downto 0);
        -- Decimal point for specific digit
        dp_o    : out std_logic;
        -- Cathode values for individual segments
        seg_o   : out std_logic_vector(7 - 1 downto 0);
        -- Common anode signals to individual displays
        dig0_o   : out std_logic_vector;
		dig1_o   : out std_logic_vector
    );
end entity driver_7seg_4digits;

------------------------------------------------------------------------
-- Architecture declaration for display driver
------------------------------------------------------------------------
architecture Behavioral of driver_7seg_4digits is

    -- Internal clock enable
    signal s_en  : std_logic;
    -- Internal 2-bit counter for multiplexing 4 digits
    signal s_cnt : std_logic_vector(2 - 1 downto 0);
    -- Internal 4-bit value for 7-segment decoder
    signal s_hex : std_logic_vector(4 - 1 downto 0);

begin
    --------------------------------------------------------------------
    -- Instance (copy) of clock_enable entity generates an enable pulse
    -- every 4 ms
    clk_en0 : entity work.clock_enable
        generic map(
            g_MAX  => 4
                   )
        port map(
            clk    =>  clk,
            reset  =>  reset,
            ce_o   =>  s_en
        );

    --------------------------------------------------------------------
    -- Instance (copy) of cnt_up_down entity performs a 2-bit down
    -- counter
    bin_cnt0 : entity work.cnt_up_down
        generic map(
            g_CNT_WIDTH  => 2 
        )
        port map(
            clk          => clk,     
            reset        => reset, 
            en_i         => s_en, 
            cnt_up_i     => '0',
            cnt_o        => s_cnt 
        );

    --------------------------------------------------------------------
    -- Instance (copy) of hex_7seg entity performs a 7-segment display
    -- decoder
    hex2seg : entity work.hex_7seg
        port map(
            hex_i => s_hex,
            seg_o => seg_o
        );

    --------------------------------------------------------------------
    -- p_mux:
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
    end process p_mux;
    end architecture Behavioral;
```

### (3.) Modul `cnt_up_down`
```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
-- Entity declaration for n-bit counter
------------------------------------------------------------------------
entity cnt_up_down is
    generic(
        g_CNT_WIDTH : natural := 4      -- Number of bits for counter
    );
    port(
        clk      : in  std_logic;       -- Main clock
        reset    : in  std_logic;       -- Synchronous reset
        en_i     : in  std_logic;       -- Enable input
        cnt_up_i : in  std_logic;       -- Direction of the counter
        cnt_o    : out std_logic_vector(g_CNT_WIDTH - 1 downto 0)
    );
end entity cnt_up_down;

------------------------------------------------------------------------
-- Architecture body for n-bit counter
------------------------------------------------------------------------
architecture behavioral of cnt_up_down is

    -- Local counter
    signal s_cnt_local : unsigned(g_CNT_WIDTH - 1 downto 0);

begin
    --------------------------------------------------------------------
    -- p_cnt_up_down:
    -- Clocked process with synchronous reset which implements n-bit 
    -- up/down counter.
    --------------------------------------------------------------------
    p_cnt_up_down : process(clk)
    begin
        if rising_edge(clk) then
        
            if (reset = '1') then               -- Synchronous reset
                s_cnt_local <= (others => '0'); -- Clear all bits

            elsif (en_i = '1') then       -- Test if counter is enabled


            if (cnt_up_i = '1') then
                s_cnt_local <= s_cnt_local + 1;
                    
            elsif (cnt_up_i = '0') then
                s_cnt_local <= s_cnt_local - 1;
                
             end if;

            end if;
        end if;
    end process p_cnt_up_down;

    -- Output must be retyped from "unsigned" to "std_logic_vector"
    cnt_o <= std_logic_vector(s_cnt_local);

end architecture behavioral;



```

### (4.) Modul `hex_7seg`
```vhdl
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------
-- Entity declaration for 2-bit binary comparator
------------------------------------------------------------------------
entity hex_7seg is
    port
    (
        num_i         :  in  integer range 0 to 9999;               --input 
        seg_o         :  out std_logic_vector(6 downto 0)       --output for cathode      
    );
end entity hex_7seg;

------------------------------------------------------------------------
-- Architecture body for 2-bit binary comparator
------------------------------------------------------------------------
architecture Behavioral of hex_7seg is
begin

    p_7seg_decoder : process(num_i)
    begin
    
        case num_i is
            when 0 =>
                seg_o <= "0000001";     -- for 0
            when 1 =>
                seg_o <= "1001111";     -- for 1
            when 2 =>
                seg_o <= "0010010";     -- for 2
            when 3 =>
                seg_o <= "0000110";     -- for 3
            when 4 =>
                seg_o <= "1001100";     -- for 4 
            when 5 =>
                seg_o <= "0100100";     -- for 5
            when 6 =>
                seg_o <= "0100000";     -- for 6 
            when 7 =>
                seg_o <= "0001111";     -- for 7
            when 8 =>
                seg_o <= "0000000";     -- for 8
            when 9 =>
                seg_o <= "0000100";     -- for 9
                
             -------|We do not need this |---
          --when "1010" =>
              --seg_o <= "0001000";     -- A
          --when "1011" =>
              --seg_o <= "1100000";     -- b
          --when "1100" =>
              --seg_o <= "0110001";     -- C
         -- when "1101" =>
             --seg_o <= "1000010";     -- d
          --when "1110" =>
             --seg_o <= "0110000";     -- E
          --when others =>
             --seg_o <= "0111000";     -- 
           ----------------------------------
            when others =>
                seg_o <= "1111111";
        end case;
        
    end process p_7seg_decoder;

end architecture Behavioral;


```

### (5.) Modul `timer_enable`
```vhdl

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


```

### (6).Modul `hall_sensor`
```vhdl
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



```
### Code of the `top.vhdl` 
```vhdl
----------------------------------------------------------------------------------
-- top
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

entity top is
Port ( 
    
           CLK100MHZ         : in STD_LOGIC;
           button             : in STD_LOGIC_VECTOR (3 downto 0);
           hall_sensor1        : in STD_LOGIC;
           
           CA          : out STD_LOGIC;
           CB          : out STD_LOGIC;
           CC          : out STD_LOGIC;
           CD          : out STD_LOGIC;
           CE          : out STD_LOGIC;
           CF          : out STD_LOGIC;
           CG          : out STD_LOGIC;
           
           DP          : out STD_LOGIC;
           
           AN          : out STD_LOGIC_VECTOR (3 downto 0)
           
    );
end top;

architecture Behavioral of top is
    signal s_start  : std_logic;
    signal s_number : integer;
    

begin        
    driver_seg_4 : entity work.driver_7seg
        port map(
            clk        => CLK100MHZ,
            reset      => button(2),

            decimal => s_number,

            dp_i => "1110",
            dp_o => DP,
            
            seg_o(6) => CA,
            seg_o(5) => CB,
            seg_o(4) => CC,
            seg_o(3) => CD,
            seg_o(2) => CE,
            seg_o(1) => CF,
            seg_o(0) => CG,
            
            dig_o => AN(4 - 1 downto 0)
        );
        
    hall_sensor : entity work.hall_sensor
        port map(
            clk              => CLK100MHZ,
            hall_sensor      => hall_sensor1,
            wheel            => 250,                   --250 cm      
            button_mod       => button(0),
            button_reset     => button(1),
            

            output_o         => s_number
        );

end architecture Behavioral;



```

## Tests
### (1).test `tb_hall_sensor `


```vhdl
---------------------------------------------------------------------------------
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
```
### Simulation  `tb_hall_sensor `
![](https://github.com/SamuelBartko/DE1-Project/blob/main/Images/hall%20sensor%20all.png)
![](https://github.com/SamuelBartko/DE1-Project/blob/main/Images/hall%20sensor%20part.png)
### (2.) test `tb_driver `
```vhdl
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
    signal s_dig        : std_logic_vector(4 - 1 downto 0);
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

```
### Simulation  `tb_driver `
![](https://github.com/SamuelBartko/DE1-Project/blob/main/Images/driver.png)
### (3).test `tb_top `
```vhdl
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

```
### Simulation  `tb_top `
![](https://github.com/SamuelBartko/DE1-Project/blob/main/Images/test%20top.png)
 

### What can be added in Future?
***If we want add something to the console of the stationary bike it can be Heart Pulse Sensor. This sensor will detect pulses of heart, and display it on 7 segment display after some button is clicked.
The principle of the heart sensor is shown on picture bellow.  Under the picture there is another one which shows new connection of the sensor to the board.
And we can add function that will display burned calories. It would be counted form distance traveled.
***

![](https://github.com/SamuelBartko/DE1-Project/blob/main/Images/tep_dokopyyy.jpg)
![](https://github.com/SamuelBartko/DE1-Project/blob/main/Images/projekt_-_schema__srdce_tep.jpg)



## Video
[Our video Link](https://www.youtube.com/watch?v=-a7UKXwctU4)
## References
Most of the things we learned from the exercises from Digital Electronics 1.
---------------------------------------------------------------------------------
https://reference.digilentinc.com/reference/programmable-logic/arty-a7/reference-manual
---------------------------------------------------------------------------------
https://store.digilentinc.com/pmod-ssd-seven-segment-display/
---------------------------------------------------------------------------------
https://www.reichelt.com/de/en/developer-boards-magnetic-hall-sensor-a3141-debo-sens-hall-p239090.html
---------------------------------------------------------------------------------
https://www.aristutorf.com/index.php?main_page=product_info&products_id=338449
---------------------------------------------------------------------------------
https://extremeelectronics.co.in/microchip-pic-tutorials/using-multiplexed-7-segment-displays-%E2%80%93-pic-microcontroller-tutorial/
---------------------------------------------------------------------------------
https://www.rohm.com/electronics-basics/sensor/pulse-sensor
---------------------------------------------------------------------------------
https://community.createlabz.com/knowledgebase/heart-beat-counter-on-raspberry-pi-zero-using-pulse-sensor-and-lcd-display/
---------------------------------------------------------------------------------
