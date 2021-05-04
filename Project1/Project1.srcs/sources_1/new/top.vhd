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


