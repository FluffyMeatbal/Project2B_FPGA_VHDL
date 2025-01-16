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
use work.VGA_Types.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VU_Meter_met_UART_tb is
--  Port ( );
end VU_Meter_met_UART_tb;

architecture Behavioral of VU_Meter_met_UART_tb is

    component VU_Meter_met_UART is
    Port (
        clk, UART_IN: in std_logic;
        Hsync, Vsync, video_ON: out std_logic;
        vgaRed, vgaGreen, vgaBlue: out std_logic_vector(3 downto 0)
    );
    end component;

    signal clk, UART_IN: std_logic;
    signal f: FreqArray;
    signal Hsync, Vsync, video_ON: std_logic;
    signal vgaRed, vgaGreen, vgaBlue: std_logic_vector(3 downto 0);
    
    type IntArray is array(8 downto 0) of integer range 0 to 255;
    signal TestByte: IntArray;
    constant TijdPerBit : time:= 104 us;                -- Wachttijd per bit bij een baudrate van 9600
    
--    signal verify : boolean:= true; 

begin

uut: VU_Meter_met_UART port map(
    clk => clk,
    UART_IN => UART_IN,
    Hsync => Hsync,
    Vsync => Vsync,
    video_ON => video_ON,
    vgaRed => vgaRed,
    vgaGreen => vgaGreen,
    vgaBlue => vgaBlue
);

clk_gen: process
begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
end process;

tb: process
begin
    TestByte(0) <= 255;     -- Startbyte
    TestByte(1) <= 64;      -- Byte 1
    TestByte(2) <= 128;     -- Byte 2
    TestByte(3) <= 255;     -- Byte 3
    TestByte(4) <= 128;     -- Byte 4
    TestByte(5) <= 64;      -- Byte 5
    TestByte(6) <= 32;      -- Byte 6
    TestByte(7) <= 16;      -- Byte 7
    TestByte(8) <= 8;       -- Byte 8
    
    UART_IN <= '1';
    wait for TijdPerBit;
    
    for i in 0 to 8 loop                                -- index voor TestByte
    UART_IN <= '0';
    wait for TijdPerBit;
    
        for j in 7 downto 0 loop                        -- index voor bit van TestByte
            UART_IN <= to_unsigned(TestByte(i),8)(j);   -- conversie integer i naar unsigned
            wait for TijdPerBit;                        -- bit j wordt toegewezen aan UART_IN
        end loop;
        
    UART_IN <= '1';
    wait for TijdPerBit;
    end loop;
    
    wait;                                               --Einde van de simulatie
end process;

--validation: process
--begin
--wait until rising_edge(clk);
--if video_ON = '1' then
--    verify <= true when 
--        (vgaRed = Red) 
--        and (vgaGreen = Green) 
--        and (vgaBlue = Blue) 
--    else false;
--end if;

--end process;

end Behavioral;
