# Console for exercise bike/bike

### Team members

* Mohamad Alkanan
* Tarik Alkanan
* Dominik Baláž
* Samuel Bartko

[Link to your GitHub project folder]( http://github.com/xxx)

### Project objectives

Console for exercise bike/bike, hall sensor, measuring and displaying speed, distance traveled, etc.


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

The board Arty A7-35T doesn't have 7 digit display to display infromation or the hall sensor needed for detecing ratations of the bike wheel.
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


## VHDL modules description and simulations

### Modul `hex_7_seg`
```vhdl

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hex_7seg is
    Port ( 
           hex_i : in STD_LOGIC_VECTOR  (4 - 1 downto 0); --Input binary data
           seg_o : out STD_LOGIC_VECTOR (7 - 1 downto 0)  --Cathode values in the order A, B, C, D, E, F, G
         );
end hex_7seg;

architecture Behavioral of hex_7seg is

begin

--------------------------------------------------------------------
    -- p_7seg_decoder:
    -- A combinational process for 7-segment display decoder. 
    -- Any time "hex_i" is changed, the process is "executed".
    -- Output pin seg_o(6) corresponds to segment A, seg_o(5) to B, etc.
    --------------------------------------------------------------------
    p_7seg_decoder : process(hex_i)
    begin
        case hex_i is
            when "0000" =>
                seg_o <= "0000001";     -- 0
            when "0001" =>
                seg_o <= "1001111";     -- 1
            when "0010" =>
                seg_o <= "0010010";     -- 2
            when "0011" =>
                seg_o <= "0000110";     -- 3
            when "0100" =>
                seg_o <= "1001100";     -- 4
            when "0101" =>
                seg_o <= "0100100";     -- 5
            when "0110" =>
                seg_o <= "0100000";     -- 6
            when "0111" =>
                seg_o <= "0011111";     -- 7
            when "1000" =>
                seg_o <= "0000000";     -- 8
            when "1001" =>
                seg_o <= "0000100";     -- 9
            when "1010" =>
                seg_o <= "0001000";     -- A
            when "1011" =>
                seg_o <= "1100000";     -- B
            when "1100" =>
                seg_o <= "0110001";     -- C
            when "1101" =>
                seg_o <= "1000010";     -- D        
            when "1110" =>
                seg_o <= "0110000";     -- E
            when others =>
                seg_o <= "0111000";     -- F
        end case;
    end process p_7seg_decoder;

end Behavioral;

```

### Modul `driver_7seg_4digits`
```vhdl

------------------------------------------------------------------------
--
-- Driver for 4-digit 7-segment display.
-- Nexys A7-50T, Vivado v2020.1.1, EDA Playground
--
-- Copyright (c) 2020 Tomas Fryza
-- Dept. of Radio Electronics, Brno University of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
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
        dig_o   : out std_logic_vector(4 - 1 downto 0)
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
            when "11" =>
                s_hex <= data3_i;
                dp_o  <= dp_i(3);
                dig_o <= "0111";

            when "10" =>
                s_hex <= data2_i;
                dp_o  <= dp_i(2);
                dig_o <= "1011";

            when "01" =>
                s_hex <= data1_i;
                dp_o  <= dp_i(1);
                dig_o <= "1101";

            when others =>
                s_hex <= data0_i;
                dp_o  <= dp_i(0);
                dig_o <= "1110";
                
        end case;
    end process p_mux;
    end architecture Behavioral;


```

### Modul `average`
```vhdl



```

### Modul `console`
```vhdl



```

### Modul `distance`
```vhdl



```

### Modul `velocity`
```vhdl



```

## TOP module description and simulations

The top module implements all modules onto Arty A7-35T board. 

### Schematic of the Top module

![TOP](Images/top.png)


### Code of the `top.vhdl` 
```vhdl



```

### Screenshot with simulated time waveforms

![Graph](Images/topsim.png)

## Video
