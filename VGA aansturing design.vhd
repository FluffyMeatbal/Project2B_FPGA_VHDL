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
constant Blok1L:        integer := 0;      --blok 1 meest linkse punt
constant Blok1R:        integer := 0;      --blok 1 meest rechtse punt
constant Blok2L:        integer := 0;      --blok 2 meest linkse punt
constant Blok2R:        integer := 0;      --blok 2 meest rechtse punt
constant Blok3L:        integer := 0;      --blok 3 meest linkse punt
constant Blok3R:        integer := 0;      --blok 3 meest rechtse punt
constant Blok4L:        integer := 0;      --blok 4 meest linkse punt
constant Blok4R:        integer := 0;      --blok 4 meest rechtse punt
constant Blok5L:        integer := 0;      --blok 5 meest linkse punt
constant Blok5R:        integer := 0;      --blok 5 meest rechtse punt
constant Blok6L:        integer := 0;      --blok 6 meest linkse punt
constant Blok6R:        integer := 0;      --blok 6 meest rechtse punt
constant Blok7L:        integer := 0;      --blok 7 meest linkse punt
constant Blok7R:        integer := 0;      --blok 7 meest rechtse punt
constant Blok8L:        integer := 0;      --blok 8 meest linkse punt
constant Blok8R:        integer := 0;      --blok 8 meest rechtse punt
constant BlockBottom:   integer := 0;      --onderkant blokjes
constant LaagLVL:       integer := 0;
constant MediumLVL:     integer := 0;
constant HighLVL:       integer := 0;
begin
    if rising_edge(clk) then
        if enable = '1' then
            if xTel >= Blok1L and xTel <= Blok1R and yTel >= BlockBottom then     --VU blok voor frequentie 1
                if unsigned(f1) > 0 then                    --vergelijk numerieke waarde van register f1
                    if yTel <= LaagLVL then                 --onderste deel van het blokje
                        Red <= "0000";                      --kleur = Groen
                        Green <= "1111";
                        Blue <= "0000";
                    end if;
                    
                    if unsigned(f1) > 1 then
                        if yTel <= MediumLVL then           --middelste deel van het blokje
                            Red <= "0000";                  --kleur = Geel
                            Green <= "1111";
                            Blue <= "1111";
                        end if;
                        
                        if unsigned(f1) > 2 then
                            if yTel <= HighLVL then         --hoogste deel van het blokje
                                Red <= "1111";              --kleur = Rood
                                Green <= "0000";
                                Blue <= "0000";
                            end if;
                    end if;
                end if;
                
            elsif xTel >= Blok2L and xTel <= Blok2R and yTel >= BlockBottom then  --VU blok voor frequentie 2
                if unsigned(f2) > 0 then                    --vergelijk numerieke waarde van register f2
                    if yTel <= LaagLVL then
                        Red <= "0000";
                        Green <= "1111";
                        Blue <= "0000";
                    end if;
                    
                    if unsigned(f2) > 1 then
                        if yTel <= MediumLVL then
                            Red <= "0000";
                            Green <= "1111";
                            Blue <= "1111";
                        end if;
                        
                        if unsigned(f2) > 2 then
                            if yTel <= HighLVL then
                                Red <= "1111";
                                Green <= "0000";
                                Blue <= "0000";
                            end if;
                    end if;
                end if;
            
            elsif xTel >= Blok3L and xTel <= Blok3R and yTel >= BlockBottom then  --VU blok voor frequentie 3
                if unsigned(f3) > 0 then                    --vergelijk numerieke waarde van register f3
                    if yTel <= LaagLVL then
                        Red <= "0000";
                        Green <= "1111";
                        Blue <= "0000";
                    end if;
                    
                    if unsigned(f3) > 1 then
                        if yTel <= MediumLVL then
                            Red <= "0000";
                            Green <= "1111";
                            Blue <= "1111";
                        end if;
                        
                        if unsigned(f3) > 2 then
                            if yTel <= HighLVL then
                                Red <= "1111";
                                Green <= "0000";
                                Blue <= "0000";
                            end if;
                    end if;
                end if;
            
            elsif xTel >= Blok4L and xTel <= Blok4R and yTel >= BlockBottom then  --VU blok voor frequentie 4
                if unsigned(f4) > 0 then                    --vergelijk numerieke waarde van register f4
                    if yTel <= LaagLVL then
                        Red <= "0000";
                        Green <= "1111";
                        Blue <= "0000";
                    end if;
                    
                    if unsigned(f4) > 1 then
                        if yTel <= MediumLVL then
                            Red <= "0000";
                            Green <= "1111";
                            Blue <= "1111";
                        end if;
                        
                        if unsigned(f4) > 2 then
                            if yTel <= HighLVL then
                                Red <= "1111";
                                Green <= "0000";
                                Blue <= "0000";
                            end if;
                    end if;
                end if;
            
            elsif xTel >= Blok5L and xTel <= Blok5R and yTel >= BlockBottom then  --VU blok voor frequentie 5
                if unsigned(f5) > 0 then                    --vergelijk numerieke waarde van register f5
                    if yTel <= LaagLVL then
                        Red <= "0000";
                        Green <= "1111";
                        Blue <= "0000";
                    end if;
                    
                    if unsigned(f5) > 1 then
                        if yTel <= MediumLVL then
                            Red <= "0000";
                            Green <= "1111";
                            Blue <= "1111";
                        end if;
                        
                        if unsigned(f5) > 2 then
                            if yTel <= HighLVL then
                                Red <= "1111";
                                Green <= "0000";
                                Blue <= "0000";
                            end if;
                    end if;
                end if;
            
            elsif xTel >= Blok6L and xTel <= Blok6R and yTel >= BlockBottom then  --VU blok voor frequentie 6
                if unsigned(f6) > 0 then                    --vergelijk numerieke waarde van register f6
                    if yTel <= LaagLVL then
                        Red <= "0000";
                        Green <= "1111";
                        Blue <= "0000";
                    end if;
                    
                    if unsigned(f6) > 1 then
                        if yTel <= MediumLVL then
                            Red <= "0000";
                            Green <= "1111";
                            Blue <= "1111";
                        end if;
                        
                        if unsigned(f6) > 2 then
                            if yTel <= HighLVL then
                                Red <= "1111";
                                Green <= "0000";
                                Blue <= "0000";
                            end if;
                    end if;
                end if;
            
            elsif xTel >= Blok7L and xTel <= Blok7R and yTel >= BlockBottom then  --VU blok voor frequentie 7
                if unsigned(f7) > 0 then                    --vergelijk numerieke waarde van register f7
                    if yTel <= LaagLVL then
                        Red <= "0000";
                        Green <= "1111";
                        Blue <= "0000";
                    end if;
                    
                    if unsigned(f7) > 1 then
                        if yTel <= MediumLVL then
                            Red <= "0000";
                            Green <= "1111";
                            Blue <= "1111";
                        end if;
                        
                        if unsigned(f7) > 2 then
                            if yTel <= HighLVL then
                                Red <= "1111";
                                Green <= "0000";
                                Blue <= "0000";
                            end if;
                    end if;
                end if;
            
            elsif xTel >= Blok8L and xTel <= Blok8R and yTel >= BlockBottom then  --VU blok voor frequentie 8
                if unsigned(f8) > 0 then                    --vergelijk numerieke waarde van register f8
                    if yTel <= LaagLVL then
                        Red <= "0000";
                        Green <= "1111";
                        Blue <= "0000";
                    end if;
                    
                    if unsigned(f8) > 1 then
                        if yTel <= MediumLVL then
                            Red <= "0000";
                            Green <= "1111";
                            Blue <= "1111";
                        end if;
                        
                        if unsigned(f8) > 2 then
                            if yTel <= HighLVL then
                                Red <= "1111";
                                Green <= "0000";
                                Blue <= "0000";
                            end if;
                    end if;
                end if;
            else 
                Red <= "0000";
                Green <= "0000";
                Blue <= "0000";
            end if;
        end if;
    end if;
end process RegDecoder;

end Behavioral;

