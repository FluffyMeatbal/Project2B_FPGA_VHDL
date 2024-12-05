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
signal vgaRed, vgaGreen, vgaBlue: std_logic_vector(3 downto 0)

begin

uut : VGA_aansturing port map(
clk => clk,
Red => Red,
Green => Green,
Blue => Blue,
Hsync => Hsync,
Vsync => Vsync,
video_ON => video_ON,


end Behavioral;
