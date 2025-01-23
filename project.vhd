-- Dit programma haalt 9 bytes binnen op een baudrate van 9600
-- Als het hele bericht is binnengehaald worden er waardes uitgezonden

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_std.all;

entity andpoort2 is
    Port ( klok, input : in std_logic; -- input is de seriele rx pin
           startbyte : out std_logic_vector(7 downto 0);
           testbyte : out std_logic_vector(7 downto 0);
           amp1 : out std_logic_vector(7 downto 0);
           amp2 : out std_logic_vector(7 downto 0);
           amp3 : out std_logic_vector(7 downto 0);
           amp4 : out std_logic_vector(7 downto 0);
           amp5 : out std_logic_vector(7 downto 0);
           amp6 : out std_logic_vector(7 downto 0);
           amp7 : out std_logic_vector(7 downto 0);
           amp8 : out std_logic_vector(7 downto 0)
         );
end andpoort2;

architecture Behavioral of andpoort2 is

    signal klok9600 : std_logic := '0'; --de klok die is afgesteld op de baudrate
    signal bitteller: Unsigned(3 downto 0) := (others => '0'); --deze telt tot het aantal bits wat verzonden wordt
    signal byteteller: Unsigned(3 downto 0) := (others => '0'); --deze telt tot het aantal bytes wat verzonden wordt
    
    constant klokdeler9600 : integer := 10416; --constante om de klok op de baudrate te krijgen
    signal klokteller9600 : integer := 0; --zorgt voor de vertraging van de klok
    
    signal startbyte_arc : unsigned(7 downto 0) := (others => '0'); --hier worden alle bytes in opgeslagen
    signal amp1_arc : unsigned(7 downto 0) := (others => '0');
    signal amp2_arc : unsigned(7 downto 0) := (others => '0');
    signal amp3_arc : unsigned(7 downto 0) := (others => '0');
    signal amp4_arc : unsigned(7 downto 0) := (others => '0');
    signal amp5_arc : unsigned(7 downto 0) := (others => '0');
    signal amp6_arc : unsigned(7 downto 0) := (others => '0');
    signal amp7_arc : unsigned(7 downto 0) := (others => '0');
    signal amp8_arc : unsigned(7 downto 0) := (others => '0');
    
    signal startbyte_arc_utz : unsigned(7 downto 0) := (others => '0'); --zelfde als hierboven, maar als het bericht nog niet is binnengehaald worden deze 0
    signal amp1_arc_utz : unsigned(7 downto 0) := (others => '0');
    signal amp2_arc_utz : unsigned(7 downto 0) := (others => '0');
    signal amp3_arc_utz : unsigned(7 downto 0) := (others => '0');
    signal amp4_arc_utz : unsigned(7 downto 0) := (others => '0');
    signal amp5_arc_utz : unsigned(7 downto 0) := (others => '0');
    signal amp6_arc_utz : unsigned(7 downto 0) := (others => '0');
    signal amp7_arc_utz : unsigned(7 downto 0) := (others => '0');
    signal amp8_arc_utz : unsigned(7 downto 0) := (others => '0');
    
    signal casenumber : unsigned(3 downto 0) := (others => '0'); --zorgt ervoor dat elke byte op de goede plek komt       
    
begin

process_klokdeler9600 : process(klok) --in dit proces wordt de klokdeling gedaan
begin
    if rising_edge(klok) then 
        if klokteller9600 = klokdeler9600 / 2 then
            klokteller9600 <= klokteller9600 + 1; klok9600 <= '1';
        else
            if klokteller9600 = klokdeler9600 then
                klok9600 <= '0'; klokteller9600 <= 0;
            else
                klokteller9600 <= klokteller9600 + 1;
            end if; 
        end if;
    end if;
end process;
 
tellen : process(klok9600)
begin
    if falling_edge(klok9600) then --dit hele proces werkt op de klok die is afgesteld op de baudrate
        if input = '0' or bitteller < 8 then --startbit gedetecteerd, bit teller niet aan het tellen                
            if not(bitteller < 8) then --als de bitteller 8 is reset hem
                bitteller <= "0000";
                byteteller <= byteteller + 1; --bit is uitgelezen, dus naar volgende byte
                
                if not(byteteller < 8) then --alle bytes uitgelezen
                    byteteller <= "0000"; --reset de teller
                end if;
            else --als bitteller niet 8 is
                bitteller <= bitteller + 1;
            end if;
            
            if not(bitteller = 8) then --als bitteller niet 8 is
                case casenumber is --deze case zorgt ervoor dat de startbyte op de juiste plek komt
                    when "0000" =>
                        case byteteller is
                            when "0000" => startbyte_arc(7 downto 0) <= input & startbyte_arc(7 downto 1); --zet de input (de rx) in de juiste byte
                            when "0001" => amp1_arc(7 downto 0) <= input & amp1_arc(7 downto 1);
                            when "0010" => amp2_arc(7 downto 0) <= input & amp2_arc(7 downto 1);
                            when "0011" => amp3_arc(7 downto 0) <= input & amp3_arc(7 downto 1);
                            when "0100" => amp4_arc(7 downto 0) <= input & amp4_arc(7 downto 1);
                            when "0101" => amp5_arc(7 downto 0) <= input & amp5_arc(7 downto 1);
                            when "0110" => amp6_arc(7 downto 0) <= input & amp6_arc(7 downto 1);
                            when "0111" => amp7_arc(7 downto 0) <= input & amp7_arc(7 downto 1);
                            when "1000" => amp8_arc(7 downto 0) <= input & amp8_arc(7 downto 1);                                                            
                            when others  => null;
                        end case;
                    when "0001" =>
                        case byteteller is
                            when "0001" => startbyte_arc(7 downto 0) <= input & startbyte_arc(7 downto 1);
                            when "0010" => amp1_arc(7 downto 0) <= input & amp1_arc(7 downto 1);
                            when "0011" => amp2_arc(7 downto 0) <= input & amp2_arc(7 downto 1);
                            when "0100" => amp3_arc(7 downto 0) <= input & amp3_arc(7 downto 1);
                            when "0101" => amp4_arc(7 downto 0) <= input & amp4_arc(7 downto 1);
                            when "0110" => amp5_arc(7 downto 0) <= input & amp5_arc(7 downto 1);
                            when "0111" => amp6_arc(7 downto 0) <= input & amp6_arc(7 downto 1);
                            when "1000" => amp7_arc(7 downto 0) <= input & amp7_arc(7 downto 1);
                            when "0000" => amp8_arc(7 downto 0) <= input & amp8_arc(7 downto 1);                                                             
                            when others  => null;
                        end case;                    
                    when "0010" =>
                        case byteteller is
                            when "0010" => startbyte_arc(7 downto 0) <= input & startbyte_arc(7 downto 1);
                            when "0011" => amp1_arc(7 downto 0) <= input & amp1_arc(7 downto 1);
                            when "0100" => amp2_arc(7 downto 0) <= input & amp2_arc(7 downto 1);
                            when "0101" => amp3_arc(7 downto 0) <= input & amp3_arc(7 downto 1);
                            when "0110" => amp4_arc(7 downto 0) <= input & amp4_arc(7 downto 1);
                            when "0111" => amp5_arc(7 downto 0) <= input & amp5_arc(7 downto 1);
                            when "1000" => amp6_arc(7 downto 0) <= input & amp6_arc(7 downto 1);
                            when "0000" => amp7_arc(7 downto 0) <= input & amp7_arc(7 downto 1);
                            when "0001" => amp8_arc(7 downto 0) <= input & amp8_arc(7 downto 1);                                                             
                            when others  => null;
                        end case;                    
                    when "0011" =>
                        case byteteller is
                            when "0011" => startbyte_arc(7 downto 0) <= input & startbyte_arc(7 downto 1);
                            when "0100" => amp1_arc(7 downto 0) <= input & amp1_arc(7 downto 1);
                            when "0101" => amp2_arc(7 downto 0) <= input & amp2_arc(7 downto 1);
                            when "0110" => amp3_arc(7 downto 0) <= input & amp3_arc(7 downto 1);
                            when "0111" => amp4_arc(7 downto 0) <= input & amp4_arc(7 downto 1);
                            when "1000" => amp5_arc(7 downto 0) <= input & amp5_arc(7 downto 1);
                            when "0000" => amp6_arc(7 downto 0) <= input & amp6_arc(7 downto 1);
                            when "0001" => amp7_arc(7 downto 0) <= input & amp7_arc(7 downto 1);
                            when "0010" => amp8_arc(7 downto 0) <= input & amp8_arc(7 downto 1);                                                             
                            when others  => null;
                        end case;                    
                    when "0100" =>
                        case byteteller is
                            when "0100" => startbyte_arc(7 downto 0) <= input & startbyte_arc(7 downto 1);
                            when "0101" => amp1_arc(7 downto 0) <= input & amp1_arc(7 downto 1);
                            when "0110" => amp2_arc(7 downto 0) <= input & amp2_arc(7 downto 1);
                            when "0111" => amp3_arc(7 downto 0) <= input & amp3_arc(7 downto 1);
                            when "1000" => amp4_arc(7 downto 0) <= input & amp4_arc(7 downto 1);
                            when "0000" => amp5_arc(7 downto 0) <= input & amp5_arc(7 downto 1);
                            when "0001" => amp6_arc(7 downto 0) <= input & amp6_arc(7 downto 1);
                            when "0010" => amp7_arc(7 downto 0) <= input & amp7_arc(7 downto 1);
                            when "0011" => amp8_arc(7 downto 0) <= input & amp8_arc(7 downto 1);                                                             
                            when others  => null;
                        end case;                    
                    when "0101" =>
                         case byteteller is
                            when "0101" => startbyte_arc(7 downto 0) <= input & startbyte_arc(7 downto 1);
                            when "0110" => amp1_arc(7 downto 0) <= input & amp1_arc(7 downto 1);
                            when "0111" => amp2_arc(7 downto 0) <= input & amp2_arc(7 downto 1);
                            when "1000" => amp3_arc(7 downto 0) <= input & amp3_arc(7 downto 1);
                            when "0000" => amp4_arc(7 downto 0) <= input & amp4_arc(7 downto 1);
                            when "0001" => amp5_arc(7 downto 0) <= input & amp5_arc(7 downto 1);
                            when "0010" => amp6_arc(7 downto 0) <= input & amp6_arc(7 downto 1);
                            when "0011" => amp7_arc(7 downto 0) <= input & amp7_arc(7 downto 1);
                            when "0100" => amp8_arc(7 downto 0) <= input & amp8_arc(7 downto 1);                                                             
                            when others  => null;
                        end case;                   
                    when "0110" =>
                         case byteteller is
                            when "0110" => startbyte_arc(7 downto 0) <= input & startbyte_arc(7 downto 1);
                            when "0111" => amp1_arc(7 downto 0) <= input & amp1_arc(7 downto 1);
                            when "1000" => amp2_arc(7 downto 0) <= input & amp2_arc(7 downto 1);
                            when "0000" => amp3_arc(7 downto 0) <= input & amp3_arc(7 downto 1);
                            when "0001" => amp4_arc(7 downto 0) <= input & amp4_arc(7 downto 1);
                            when "0010" => amp5_arc(7 downto 0) <= input & amp5_arc(7 downto 1);
                            when "0011" => amp6_arc(7 downto 0) <= input & amp6_arc(7 downto 1);
                            when "0100" => amp7_arc(7 downto 0) <= input & amp7_arc(7 downto 1);
                            when "0101" => amp8_arc(7 downto 0) <= input & amp8_arc(7 downto 1);                                                             
                            when others  => null;
                        end case;                   
                    when "0111" =>
                        case byteteller is
                            when "0111" => startbyte_arc(7 downto 0) <= input & startbyte_arc(7 downto 1);
                            when "1000" => amp1_arc(7 downto 0) <= input & amp1_arc(7 downto 1);
                            when "0000" => amp2_arc(7 downto 0) <= input & amp2_arc(7 downto 1);
                            when "0001" => amp3_arc(7 downto 0) <= input & amp3_arc(7 downto 1);
                            when "0010" => amp4_arc(7 downto 0) <= input & amp4_arc(7 downto 1);
                            when "0011" => amp5_arc(7 downto 0) <= input & amp5_arc(7 downto 1);
                            when "0100" => amp6_arc(7 downto 0) <= input & amp6_arc(7 downto 1);
                            when "0101" => amp7_arc(7 downto 0) <= input & amp7_arc(7 downto 1);
                            when "0110" => amp8_arc(7 downto 0) <= input & amp8_arc(7 downto 1);                                                            
                            when others  => null;
                        end case;
                     when "1000" =>
                        case byteteller is
                            when "1000" => startbyte_arc(7 downto 0) <= input & startbyte_arc(7 downto 1);
                            when "0000" => amp1_arc(7 downto 0) <= input & amp1_arc(7 downto 1);
                            when "0001" => amp2_arc(7 downto 0) <= input & amp2_arc(7 downto 1);
                            when "0010" => amp3_arc(7 downto 0) <= input & amp3_arc(7 downto 1);
                            when "0011" => amp4_arc(7 downto 0) <= input & amp4_arc(7 downto 1);
                            when "0100" => amp5_arc(7 downto 0) <= input & amp5_arc(7 downto 1);
                            when "0101" => amp6_arc(7 downto 0) <= input & amp6_arc(7 downto 1);
                            when "0110" => amp7_arc(7 downto 0) <= input & amp7_arc(7 downto 1);
                            when "0111" => amp8_arc(7 downto 0) <= input & amp8_arc(7 downto 1);                                                             
                            when others  => null;
                        end case;                     
                      when others  => null;                    
                end case;
            end if;   
        end if;
        
        if bitteller = 8 and byteteller = 0 and input = '0' then --zorgt ervoor dat de alle bytes op de juiste plek komen
            if not (startbyte_arc = "11111111") then
                if casenumber = 9 then
                    casenumber <= "0000";
                else
                    casenumber <= casenumber + 1;
                end if;
            end if;
        end if;
        
        if bitteller = 8 and input = '1' and startbyte_arc = "11111111" then -- als het bericht goed is uitgelezen
            startbyte_arc_utz <= startbyte_arc; --zend de goede waardes uit
            amp1_arc_utz <= amp1_arc;
            amp2_arc_utz <= amp2_arc;
            amp3_arc_utz <= amp3_arc;
            amp4_arc_utz <= amp4_arc;
            amp5_arc_utz <= amp5_arc;
            amp6_arc_utz <= amp6_arc;
            amp7_arc_utz <= amp7_arc;
            amp8_arc_utz <= amp8_arc; 
        else --als het bericht niet goed is
            startbyte_arc_utz <= (others => '0'); --zend niks uit
            amp1_arc_utz <= (others => '0');
            amp2_arc_utz <= (others => '0');
            amp3_arc_utz <= (others => '0');
            amp4_arc_utz <= (others => '0');
            amp5_arc_utz <= (others => '0');
            amp6_arc_utz <= (others => '0');
            amp7_arc_utz <= (others => '0');
            amp8_arc_utz <= (others => '0');
        end if;
    end if;
end process;
    startbyte <= std_logic_vector(startbyte_arc_utz);
    amp1 <= std_logic_vector(amp1_arc_utz);
    amp2 <= std_logic_vector(amp2_arc_utz);
    amp3 <= std_logic_vector(amp3_arc_utz);
    amp4 <= std_logic_vector(amp4_arc_utz);
    amp5 <= std_logic_vector(amp5_arc_utz);
    amp6 <= std_logic_vector(amp6_arc_utz);
    amp7 <= std_logic_vector(amp7_arc_utz);
    amp8 <= std_logic_vector(amp8_arc_utz);  
    
    
test_procesje : process(klok)
begin
    if amp1_arc_utz = 2 then testbyte(3) <= '1'; else testbyte(0) <= '0'; end if;
    if amp2_arc_utz = 4 then testbyte(2) <= '1'; else testbyte(1) <= '0'; end if;
    if amp3_arc_utz = 8 then testbyte(1) <= '1'; else testbyte(2) <= '0'; end if;
    if amp4_arc_utz = 16 then testbyte(0) <= '1'; else testbyte(3) <= '0'; end if;
    if amp5_arc_utz = 32 then testbyte(3) <= '1'; else testbyte(4) <= '0'; end if;
    if amp6_arc_utz = 64 then testbyte(2) <= '1'; else testbyte(5) <= '0'; end if;
    if amp7_arc_utz = 128 then testbyte(1) <= '1'; else testbyte(6) <= '0'; end if;
    if amp8_arc_utz = 101 then testbyte(0) <= '1'; else testbyte(7) <= '0'; end if;
        
end process;



  
end Behavioral;

