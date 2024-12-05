----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.11.2024 16:13:33
-- Design Name: 
-- Module Name: VGA_aansturing_tb - Behavioral
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

entity VGA_aansturing_tb is
--  Port ( );
end VGA_aansturing_tb;

architecture Behavioral of VGA_aansturing_tb is

    component VGA_aansturing is
    Port (
        clk: in std_logic;
        Red, Green, Blue: in std_logic_vector(3 downto 0);
        Hsync, Vsync, video_ON: out std_logic;
        vgaRed, vgaGreen, vgaBlue: out std_logic_vector(3 downto 0)
    );
    end component;

    signal clk: std_logic;
    signal Red, Green, Blue: std_logic_vector(3 downto 0);
    signal Hsync, Vsync, video_ON: std_logic;
    signal vgaRed, vgaGreen, vgaBlue: std_logic_vector(3 downto 0);
    
    signal verify : boolean:= true; 

begin

clk_gen: process
begin
    clk <= '0';
    wait for 1 ns;
    clk <= '1';
    wait for 1 ns;
end process;

tb: process
begin
    Red <= "0000"; Green <= "0000"; Blue <= "0000";    --Zwart
    wait for 1 ms;

    Red <= "1111"; Green <= "0000"; Blue <= "0000";    --Rood
    wait for 1 ms;
    
    Red <= "1111"; Green <= "1111"; Blue <= "0000";    --Geel
    wait for 1 ms;

    Red <= "0000"; Green <= "1111"; Blue <= "0000";    --Groen
    wait for 1 ms;
    
    Red <= "0000"; Green <= "1111"; Blue <= "1111";    --Cyaan
    wait for 1 ms; 
    
    Red <= "0000"; Green <= "0000"; Blue <= "1111";    --Blauw
    wait for 1 ms;
    
    Red <= "1111"; Green <= "0000"; Blue <= "1111";    --Magenta
    wait for 1 ms;
    
    Red <= "1111"; Green <= "1111"; Blue <= "1111";    --Wit
    wait for 1 ms;
    
    wait;                                               --Einde van de simulatie
end process;

validation: process
begin
wait until rising_edge(clk);
if video_ON = '1' then
    verify <= true when 
        (vgaRed = Red) 
        and (vgaGreen = Green) 
        and (vgaBlue = Blue) 
    else false;
end if;

end process;

end Behavioral;
