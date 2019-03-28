----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2019 07:35:26 PM
-- Design Name: 
-- Module Name: debounce - Behavioral
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
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce is
    Port ( 
            btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           dbnc : out STD_LOGIC);
end debounce;

architecture Behavioral of debounce is
    signal counter : std_logic_vector(22 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if clk'event and clk='1' then
          if(btn='1') then
            if(unsigned(counter)>=2500000) then
                counter <= counter;
            else
                counter <= std_logic_vector(unsigned(counter) + 1);
            end if;
          else 
            counter <= "00000000000000000000000";
          end if;
          if(unsigned(counter)>=2500000) then
            dbnc <= '1';
          else 
            dbnc <= '0';
          end if;
        end if;
    end process;

end Behavioral;