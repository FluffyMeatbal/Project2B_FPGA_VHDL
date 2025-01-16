----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2025 14:39:03
-- Design Name: 
-- Module Name: KlokDeler - Behavioral
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

entity KlokDeler is
    generic(
            PreScaler : integer := 1
            );
            
    port    (
            clk : in std_logic;
            DeelClk : out std_logic
            );
end KlokDeler;

architecture Behavioral of KlokDeler is
begin
DelerProces: process(clk)
variable Deler : integer := 1;
begin
    if rising_edge(clk) then
        if deler = PreScaler / 2 then                           --50% van periode voorbij 
            DeelClk <= '1';
        else
            DeelClk <= '0';
        end if;
        
        if deler = PreScaler then                               --100% van periode voorbij 
            deler := 1;
        else
            deler := deler + 1;
        end if;
    end if;
end process DelerProces;

end Behavioral;
