----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2019 02:43:51 PM
-- Design Name: 
-- Module Name: sender_top - Structural
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sender_top is
    Port ( TXD : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (1 downto 0);
           clk : in STD_LOGIC;
           RXD : out STD_LOGIC;
           RTS : out STD_LOGIC;
           CTS : out STD_LOGIC);
end sender_top;

architecture Structural of sender_top is
    component debounce port
    (
        btn : in STD_LOGIC;
        clk : in STD_LOGIC;
        dbnc : out STD_LOGIC
    );
    end component;

    component sender port
    (
        rst : in STD_LOGIC;
        clk : in STD_LOGIC;
        en : in STD_LOGIC;
        btn : in STD_LOGIC;
        ready : in STD_LOGIC;
        send : out STD_LOGIC;
        char : out STD_LOGIC_VECTOR (7 downto 0)
    );
    end component;
    
    component uart port
    (
        clk, en, send, rx, rst      : in std_logic;
        charSend                    : in std_logic_vector (7 downto 0);
        ready, tx, newChar          : out std_logic;
        charRec                     : out std_logic_vector (7 downto 0)
    );
    end component;
    
    component clock_div port
    (
        CLK_IN : in STD_LOGIC;
        CLK_OUT : out STD_LOGIC
    );
    end component;
    
    signal result : std_logic_vector(2 downto 0);
    signal charac : std_logic_vector(7 downto 0);
    signal snd : std_logic; 
    signal rdy : std_logic;
    signal garbo : std_logic_vector(8 downto 0);
begin
    u1: debounce port map(
        btn => btn(0),
        clk => clk,
        dbnc => result(0));

    u2: debounce port map(
        btn => btn(1),
        clk => clk,
        dbnc => result(1));
        
    u3: clock_div port map(
        CLK_IN => clk,
        CLK_OUT => result(2));

    u4: sender port map(
        rst => result(0),
        clk => clk,
        en => result(2),
        btn => result(1),
        ready => rdy,
        send => snd,
        char => charac);

    u5: uart port map(
        clk => clk,
        en => result(2),
        send => snd,
        rx => TXD,
        rst => result(0),
        charSend => charac,
        ready => rdy,
        tx => RXD,
        newChar => garbo(8),
        charRec => garbo(7 downto 0));
     garbo <= "000000000";
     CTS <= '0';
     RTS <= '0';
end Structural;
