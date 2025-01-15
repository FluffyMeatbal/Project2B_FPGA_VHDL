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

package VGA_Types is                                    --array voor input registers
    type FreqArray is array(8 downto 1) of std_logic_vector(7 downto 0);
end package VGA_Types;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_STD.ALL;
use work.VGA_Types.all;

entity VGA_aansturing is
Port (
clk: in std_logic;
f: in FreqArray;
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

type BlokLimiet is record
    L: integer;
    R: integer;
end record;

type BlokArray is array(1 to 8) of BlokLimiet;

constant BlokGrens: BlokArray := (                          --Array met randwaarden van de blokjes
(L => 0, R => 640/8),                                       --Blok 1
(L => 640/8+1, R => 640/8*2),                               --Blok 2
(L => 640/8*2+1, R => 640/8*3),                             --Blok 3
(L => 640/8*3+1, R => 640/8*4),                             --Blok 4
(L => 640/8*4+1, R => 640/8*5),                             --Blok 5
(L => 640/8*5+1, R => 640/8*6),                             --Blok 6
(L => 640/8*6+1, R => 640/8*7),                             --Blok 7
(L => 640/8*7+1, R => 640)                                  --Blok 8
);
constant BlockBottom:   integer := 350;                     --onderkant blokjes

begin

delerBlok: process(clk)
variable deler : integer range 0 to 511 := 1;               --variabele voor de deler

begin
    if rising_edge(clk) then
        if deler = prscl / 4 then                           --25% van periode voorbij 
            enable <= '1';
        else
            enable <= '0';
        end if;
        
        if deler = prscl then                               --100% van periode voorbij 
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
                xTel <= xTel + 1;                           --verhoog xTel
            else
                xTel <= 0;                                  --xTel gaat terug naar het begin
            end if;
        end if;
    end if;
end process X_teller;

Y_Teller: process(clk, enable, yTel)
begin
    if rising_edge(clk) then
        if enable = '1' then
            if xTel = 799 then                              --xTel is aan het eind
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
    if xTel > 655 and xTel < 752 then                       --Horizontale puls 96 lijnen breed
        H_sync <= '0';
    elsif xTel < 640 then
        H_sync <= '1';
    else
        H_sync <= '1';
    end if;
end process HORsync;

VERTsync: process(yTel)
begin
    if yTel > 489 and yTel < 492 then                       --Verticale puls 2 lijnen breed
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

RegDecoder: process(clk, enable, xTel, yTel,f)
variable tempRed, tempGreen, tempBlue: std_logic_vector(3 downto 0) := (others => '0');
begin
    if rising_edge(clk) then
        if enable = '1' then
            if vid_ON = '1' then
                tempRed := "0000";                          --achtergrond kleur = Zwart
                tempGreen := "0000";
                tempBlue := "0000";
                for i in 8 downto 1 loop                        --doorloop routine voor elke frequentie
                    if xTel >= BlokGrens(i).L and xTel < BlokGrens(i).R and yTel <= BlockBottom then  --als de x teller zich in het blokje bevind ga verder met de routine
                        if unsigned(f(i)) >= yTel - 95 then
                            tempRed := "0000";
                            tempGreen := "1111";
                            tempBlue := "0000";
                        end if;
                    end if;
                end loop;
                Red <= tempRed;
                Green <= tempGreen;
                Blue <= tempBlue;
            end if;
        end if;
    end if;
end process RegDecoder;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_STD.ALL;
use work.VGA_Types.all;

entity VU_Meter_met_UART is
    port(
            clk, UART_IN : in std_logic;
            Hsync, Vsync, video_ON: out std_logic;
            vgaRed, vgaGreen, vgaBlue: out std_logic_vector(3 downto 0)
         );
end VU_Meter_met_UART;

architecture structural of VU_Meter_met_UART is
signal amp: FreqArray;
begin
UART : entity work.andpoort2
    Port map( 
            klok => clk,
            input => UART_IN,
            amp1 => amp(1),
            amp2 => amp(2),
            amp3 => amp(3), 
            amp4 => amp(4), 
            amp5 => amp(5),
            amp6 => amp(6), 
            amp7 => amp(7), 
            amp8 => amp(8) 
         );

VGA : entity work.VGA_aansturing
    Port map(
            f => amp,
            clk => clk,
            Hsync => Hsync,
            Vsync => Vsync,
            video_ON => video_ON,
            vgaRed => vgaRed,
            vgaGreen => vgaGreen,
            vgaBlue => vgaBlue
    );

end architecture;