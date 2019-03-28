----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2019 06:22:33 PM
-- Design Name: 
-- Module Name: uart_tx - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_misc;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_tx is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           send : in STD_LOGIC;
           rst : in STD_LOGIC;
           char : in STD_LOGIC_VECTOR (7 downto 0);
           ready : out STD_LOGIC;
           tx : out STD_LOGIC);
end uart_tx;

architecture Behavioral of uart_tx is
    signal reg : std_logic_vector(7 downto 0) := (others => '0');
    signal counter : std_logic_vector(3 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            if(rst='1') then
                ready <= '1';
                tx <= '1';
                reg <= "00000000";
            else
                if(send='1' and en='1') then
                    reg <= char;
                    ready <= '0';
                    counter <= "0000";
                    tx <= '0';
                elsif(send='0' and en='1') then
                    if(unsigned(counter) < 8) then
                        tx <= reg(to_integer(unsigned(counter)));
                        counter <= std_logic_vector(unsigned(counter) + 1);
                    else
                        ready <= '1';
                        tx <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
