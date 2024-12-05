----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Remco Pieper
-- Studentnummer: 1859875
-- Create Date: 20.11.2024 19:32:54
-- Design Name: 
-- Module Name: VGA aansturing design - Behavioral
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
-- Eisen:
-- Lijnkleur is rood
-- Achtergrond is geel
-- Breedte van de lijn is 4 pixels
-- De afstand tussen de lijnen is 16 pixels
-- Horizontale lijnen
-- Er worden 3 lijnen afgebeeld
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_aansturing is
Port (
clk: in std_logic;
f1, f2, f3, f4, f5, f6, f7, f8: in std_logic_vector(1 downto 0);
Hsync, Vsync, video_ON: out std_logic;
vgaRed, vgaGreen, vgaBlue: out std_logic_vector(3 downto 0)
);
end VGA_aansturing;

architecture Behavioral of VGA_aansturing is
signal enable: std_logic;                               --gedeelde klok 
constant prscl : integer := 4;                          --prescaler

signal xTel : integer range 0 to 1023 := 0;
signal yTel : integer range 0 to 1023 := 0;

signal H_sync : std_logic;
signal V_sync : std_logic;
signal vid_ON : std_logic;

signal Red, Green, Blue: std_logic_vector(3 downto 0);

begin

delerBlok: process(clk)
variable deler : integer range 0 to 511 := 1;          --variabele voor de deler

begin
    if rising_edge(clk) then
        if deler = prscl / 4 then                   --25% van periode voorbij 
            enable <= '1';
        else
            enable <= '0';
        end if;
        
        if deler = prscl then                           --100% van periode voorbij 
            deler := 1;
        else
            deler := deler + 1;
        end if;
    end if;
end process delerBlok;

X_teller: process(clk, enable, xTel)
begin
    if rising_edge(clk) then
        if enable = '1' then
            if xTel < 799 then
                xTel <= xTel + 1;                       --verhoog xTel
            else
                xTel <= 0;                              --xTel gaat terug naar het begin
            end if;
        end if;
    end if;
end process X_teller;

Y_Teller: process(clk, enable, yTel)
begin
    if rising_edge(clk) then
        if enable = '1' then
            if xTel = 799 then                          --xTel is aan het eind
                if yTel < 524 then
                    yTel <= yTel + 1;
                else 
                    yTel <= 0;
                end if;
            end if;
        end if;
    end if;
end process Y_teller;

HORsync: process(xTel)
begin
    if xTel > 655 and xTel < 752 then           --Horizontale puls 96 lijnen breed
        H_sync <= '0';
    elsif xTel < 640 then
        H_sync <= '1';
    else
        H_sync <= '1';
    end if;
end process HORsync;

VERTsync: process(yTel)
begin
    if yTel > 489 and yTel < 492 then           --Verticale puls 2 lijnen breed
        V_sync <= '0';
    elsif yTel < 480 then
        V_sync <= '1';
    else
        V_sync <= '1';
    end if;
end process VERTsync;

video_ON_sync: process(xTel, yTel)
begin
    if xTel < 640 and yTel < 480 then
        vid_ON <= '1';
    else
        vid_ON <= '0';
    end if;
end process video_ON_sync;

RGBsync: process(clk, enable, Red, Green, Blue, vid_ON)
begin
    if rising_edge(clk) then
        if enable = '1' then
            if vid_ON = '1' then
                vgaRed <= Red;
                vgaGreen <= Green;
                vgaBlue <= Blue;
            else
                vgaRed <= "0000";
                vgaGreen <= "0000";
                vgaBlue <= "0000";
            end if;
        end if;
    end if;
end process RGBsync;

Hsync <= H_sync;
Vsync <= V_sync;
video_ON <= vid_ON;

RegDecoder: process(clk, enable, xTel, yTel, f1, f2, f3, f4, f5, f6, f7, f8)
constant Blok1L: integer := 0;      --blok 1 meest linkse punt
constant Blok1R: integer := 0;      --blok 1 meest rechtse punt
constant Blok1U: integer := 0;      --blok 1 hoogste punt
constant Blok1D: integer := 0;      --blok 1 laagste punt
constant Blok2L: integer := 0;      --blok 2 meest linkse punt
constant Blok2R: integer := 0;      --blok 2 meest rechtse punt
constant Blok2U: integer := 0;      --blok 2 hoogste punt
constant Blok2D: integer := 0;      --blok 2 laagste punt
constant Blok3L: integer := 0;      --blok 3 meest linkse punt
constant Blok3R: integer := 0;      --blok 3 meest rechtse punt
constant Blok3U: integer := 0;      --blok 3 hoogste punt
constant Blok3D: integer := 0;      --blok 3 laagste punt
constant Blok4L: integer := 0;      --blok 4 meest linkse punt
constant Blok4R: integer := 0;      --blok 4 meest rechtse punt
constant Blok4U: integer := 0;      --blok 4 hoogste punt
constant Blok4D: integer := 0;      --blok 4 laagste punt
constant Blok5L: integer := 0;      --blok 5 meest linkse punt
constant Blok5R: integer := 0;      --blok 5 meest rechtse punt
constant Blok5U: integer := 0;      --blok 5 hoogste punt
constant Blok5D: integer := 0;      --blok 5 laagste punt
constant Blok6L: integer := 0;      --blok 6 meest linkse punt
constant Blok6R: integer := 0;      --blok 6 meest rechtse punt
constant Blok6U: integer := 0;      --blok 6 hoogste punt
constant Blok6D: integer := 0;      --blok 6 laagste punt
constant Blok7L: integer := 0;      --blok 7 meest linkse punt
constant Blok7R: integer := 0;      --blok 7 meest rechtse punt
constant Blok7U: integer := 0;      --blok 7 hoogste punt
constant Blok7D: integer := 0;      --blok 7 laagste punt
constant Blok8L: integer := 0;      --blok 8 meest linkse punt
constant Blok8R: integer := 0;      --blok 8 meest rechtse punt
constant Blok8U: integer := 0;      --blok 8 hoogste punt
constant Blok8D: integer := 0;      --blok 8 laagste punt
constant LaagLVL: integer := 0;
constant MediumLVL: integer := 0;
constant HighLVL: integer := 0;
begin
    if rising_edge(clk) then
        if enable = '1' then
            if xTel >= Blok1L and xTel <= Blok1R and yTel >= Blok1D and yTel <= Blok1U then     --VU blok voor frequentie 1
                if yTel <= LaagLVL and f1 = "01" then
                    Red <= "0000";
                    Green <= "1111";
                    Blue <= "0000";
                elsif yTel <= MediumLVL and f1 = "10" then
                    Red <= "0000";
                    Green <= "1111";
                    Blue <= "1111";
                elsif yTel <= HighLVL and f1 = "11" then
                    Red <= "1111";
                    Green <= "0000";
                    Blue <= "0000";
                end if;
            elsif xTel >= Blok2L and xTel <= Blok2R and yTel >= Blok2D and yTel <= Blok2U then  --VU blok voor frequentie 2
            
            elsif xTel >= Blok3L and xTel <= Blok3R and yTel >= Blok3D and yTel <= Blok3U then  --VU blok voor frequentie 3
            
            elsif xTel >= Blok4L and xTel <= Blok4R and yTel >= Blok4D and yTel <= Blok4U then  --VU blok voor frequentie 4
            
            elsif xTel >= Blok5L and xTel <= Blok5R and yTel >= Blok5D and yTel <= Blok5U then  --VU blok voor frequentie 5
            
            elsif xTel >= Blok6L and xTel <= Blok6R and yTel >= Blok6D and yTel <= Blok6U then  --VU blok voor frequentie 6
            
            elsif xTel >= Blok7L and xTel <= Blok7R and yTel >= Blok7D and yTel <= Blok7U then  --VU blok voor frequentie 7
            
            elsif xTel >= Blok8L and xTel <= Blok8R and yTel >= Blok8D and yTel <= Blok8U then  --VU blok voor frequentie 8
        end if;
    end if;
end process RegDecoder:

end Behavioral;

