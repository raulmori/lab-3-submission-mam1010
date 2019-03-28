----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2019 07:30:42 PM
-- Design Name: 
-- Module Name: sender - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sender is
    Port ( 
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           btn : in STD_LOGIC;
           ready : in STD_LOGIC;
           send : out STD_LOGIC;
           char : out STD_LOGIC_VECTOR (7 downto 0));
end sender;

architecture Behavioral of sender is
    type state is (idle, busyA, busyB, busyC);
    signal curr : state := idle;
    signal i : std_logic_vector(2 downto 0) := (others => '0');
    type Bibble is array (0 to 6) of std_logic_vector (7 downto 0);
    signal NETID : Bibble := (x"60", x"61", x"60", x"31", x"30", x"31", x"30");
    
begin
    process(clk) begin
    if rising_edge(clk) then

        -- resets the state machine and its outputs
        if rst = '1' then

            i <= "000";
            send <= '0';
            char <= "00000000";
            curr <= idle;
            

        -- usual operation
        elsif en = '1' then
            case curr is

                when idle =>
                        if(ready='1' and btn='1' and unsigned(i)<7) then
                            char <= NETID(to_integer(unsigned(i)));
                            i <= std_logic_vector(unsigned(i) + 1);
                            send <= '1';
                            curr <= busyA;
                        else
                            i <= "000";
                            curr <= idle;
                        end if;
                when busyA =>
                    curr <= busyB;
                
                when busyB =>
                    send <= '0';
                    curr <= busyC;
                
                when busyC =>
                    if(ready='1' and btn='0') then
                        curr <= idle;
                    end if;
                
                when others =>
                    curr <= idle;

            end case;
        end if;

    end if;
    end process;

end Behavioral;
