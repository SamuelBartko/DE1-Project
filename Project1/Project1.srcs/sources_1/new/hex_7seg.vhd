
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
