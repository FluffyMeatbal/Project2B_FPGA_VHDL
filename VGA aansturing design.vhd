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
-- UART_Ontvangen.vhd
-- KlokDeler.vhd
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package VGA_Types is                                    --array voor input registers
    type FreqArray is array(8 downto 1) of std_logic_vector(7 downto 0);
end package VGA_Types;

-------------------------------------------------------------------------------------------
--In deze module wordt de navolging van het VGA protocol geregeld en de data wordt verwerkt in beeld
-------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_STD.ALL;
use work.VGA_Types.all;

entity VGA_aansturing is
Port (
clk: in std_logic;                                      --100MHz
f: in FreqArray;                                        --komt binnen via UART
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
constant BovenGrens:    integer := 95;                      --bovenkant blokjes

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
                    yTel <= yTel + 1;                       --verhoog yTel
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
    if xTel < 640 and yTel < 480 then                       --actief gebied bij een resolutie van 480p
        vid_ON <= '1';                                      --uitgang om het actieve video gebied aan te geven
    else
        vid_ON <= '0';
    end if;
end process video_ON_sync;

RGBsync: process(clk, enable, Red, Green, Blue, vid_ON)
begin                                                       --proces om te zorgen dat het onmogelijk is om 
    if rising_edge(clk) then                                --dingen te sturen op de RGB uitgangne
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
variable tempRed, tempGreen, tempBlue: std_logic_vector(3 downto 0) := (others => '0'); -- tijdelijke variabelen om problemen met overschrijven te voorkomen
begin
    if rising_edge(clk) then
        if enable = '1' then
            if vid_ON = '1' then
                tempRed := "0000";                              --achtergrond kleur = Zwart
                tempGreen := "0000";
                tempBlue := "0000";
                for i in 8 downto 1 loop                        --doorloop routine voor elke frequentie
                    if xTel >= BlokGrens(i).L and xTel < BlokGrens(i).R and yTel >= BovenGrens and yTel <= BlockBottom then  --als de x teller zich in het blokje bevind ga verder met de routine
                        if (255-unsigned(f(i))) <= yTel - BovenGrens then   -- de waarde in f wordt omgedraaid en vergeleken met yTel
                            tempRed     := "0000";                          -- als het niet omgedraaid wordt beginnen de balkjes bovenaan het scherm
                            tempGreen   := "1111";              -- kleur = groen
                            tempBlue    := "0000";
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

-------------------------------------------------------------------------------------------
--In deze module wordt de data van de UART gesynchroniseerd met de refreshrate van het VGA-scherm
--
--extra comments:
--om een 60Hz klok te maken moet de prescaler afgerond worden (100.000.000 / 60 = 1666666,666...)
--dit zorgt ervoor dat het overschrijven meestal op het goede moment gebeurt maar, uiteindelijk
--wordt de afwijking te groot en gaat het scherm flikkeren doordat de waarden veranderen halverwege
--een frame. Daarom heb ik een 25Mhz enable toegevoegd. De VGA processen werken ook op een 25MHz klok.
--in een ideale wereld zou de data overgeschreven worden wanneer 480<yTel<524. Omdat ik hier achteraf
--achter kwam was het lastig om dit zo te laten werken. Gelukkig werkt het met mijn niet perfecte
--oplossing ook. Er is nu geen flikkering op het scherm te zien. 
-------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_STD.ALL;
use work.VGA_Types.all;

entity AmplitudeSync is
    port(
            clk: in std_logic;
            enable: in std_logic;
            amp: in FreqArray;
            SyncAmp: out FreqArray
         );
end AmplitudeSync;
         
architecture Behavioral of AmplitudeSync is 
begin
AmpSync: process(clk, amp)
begin
if rising_edge(clk) then
    if enable = '1' then
        SyncAmp <= amp;
    end if;
end if;
end process AmpSync;
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

-------------------------------------------------------------------------------------------
--Met de volgende structuur beschrijving worden alle modules samengevoegd
--
--Dependencies:
--UART_Ontvangen.vhd
--KlokDeler.vhd
-------------------------------------------------------------------------------------------

architecture structural of VU_Meter_met_UART is
signal amp: FreqArray;                                          --signaal voor amplitudes
signal SyncAmp: FreqArray;                                      --gesynchroniseerd signaal voor amplitudes
signal Klok60Hz : std_logic;                                    --klok voor framerate
signal Klok25MHz : std_logic;                                   --klok voor synchronisatie met VGA processen
begin
UART : entity work.UART_IN
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
         
KlokDeler60Hz : entity work.KlokDeler
    generic map(
                Prescaler => 1666667
                )
    port map    (
                clk => clk,
                DeelClk => Klok60Hz
                );
                
KlokDeler25MHz : entity work.KlokDeler
    generic map(
                Prescaler => 4
                )
    port map    (
                clk => clk,
                DeelClk => Klok25MHz
                );
                
AmplitudeSync : entity work.AmplitudeSync
    port map    (
                clk => Klok60Hz,
                enable => Klok25MHz,
                amp => amp,
                SyncAmp => SyncAmp
                );

VGA : entity work.VGA_aansturing
    Port map    (
                f => SyncAmp,
                clk => clk,
                Hsync => Hsync,
                Vsync => Vsync,
                video_ON => video_ON,
                vgaRed => vgaRed,
                vgaGreen => vgaGreen,
                vgaBlue => vgaBlue
                );

end architecture;