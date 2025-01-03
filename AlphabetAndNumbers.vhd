----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.12.2024 13:23:37
-- Design Name: 
-- Module Name: AlphabetAndNumbers - Behavioral
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

entity AlphabetAndNumbers is
  Port ( 
  clk: in std_logic;
  character: in integer range 0 to 127;
  X_cord, Y_cord: in integer range 0 to 1023
  );
end AlphabetAndNumbers;

architecture Behavioral of AlphabetAndNumbers is
type CharArray is array (6 downto 0) of array (11 downto 0)
begin


end Behavioral;
