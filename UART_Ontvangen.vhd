----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Gijs De Vries
-- 
-- Create Date: 15.01.2025 13:01:42
-- Design Name: 
-- Module Name: UART_Ontvangen - Behavioral
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
use IEEE.Numeric_std.all;

entity andpoort2 is
    Port ( 
          klok : in STD_LOGIC;
          input : in STD_LOGIC;
          
          startbyte : out std_logic_vector(7 downto 0);
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

    signal klok9600 : std_logic := '0'; --de klok voor het binnenhalen van de bytes
    signal bitteller: Unsigned(3 downto 0) := (others => '0'); --teller van 0 tot 8 om bits binnen te halen
    signal byteteller: Unsigned(3 downto 0) := (others => '0');
    
    constant klokdeler9600 : integer := 10416;
    signal klokteller9600 : integer := 0;
    
    signal startbyte_arc : unsigned(7 downto 0) := (others => '0');
    signal amp1_arc : unsigned(7 downto 0) := (others => '0');
    signal amp2_arc : unsigned(7 downto 0) := (others => '0');
    signal amp3_arc : unsigned(7 downto 0) := (others => '0');
    signal amp4_arc : unsigned(7 downto 0) := (others => '0');
    signal amp5_arc : unsigned(7 downto 0) := (others => '0');
    signal amp6_arc : unsigned(7 downto 0) := (others => '0');
    signal amp7_arc : unsigned(7 downto 0) := (others => '0');
    signal amp8_arc : unsigned(7 downto 0) := (others => '0');
    
    signal casenumber : unsigned(3 downto 0) := (others => '0');       
    
begin

process_klokdeler1 : process(klok)
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
    if falling_edge(klok9600) then
        if input = '0' or bitteller < 8 then                
            
            if not(bitteller < 8) then
                bitteller <= "0000";
                byteteller <= byteteller + 1;
                if not(byteteller < 8) then
                    byteteller <= "0000";
                end if;
            else
                bitteller <= bitteller + 1;
            end if;
            
            if not(bitteller = 8) then
                case casenumber is
                    when "0000" =>
                        case byteteller is
                            when "0000" => startbyte_arc(7 downto 0) <= startbyte_arc(6 downto 0) & input;
                            when "0001" => amp1_arc(7 downto 0) <= amp1_arc(6 downto 0) & input;
                            when "0010" => amp2_arc(7 downto 0) <= amp2_arc(6 downto 0) & input;
                            when "0011" => amp3_arc(7 downto 0) <= amp3_arc(6 downto 0) & input;
                            when "0100" => amp4_arc(7 downto 0) <= amp4_arc(6 downto 0) & input;
                            when "0101" => amp5_arc(7 downto 0) <= amp5_arc(6 downto 0) & input;
                            when "0110" => amp6_arc(7 downto 0) <= amp6_arc(6 downto 0) & input;
                            when "0111" => amp7_arc(7 downto 0) <= amp7_arc(6 downto 0) & input;
                            when "1000"=> amp8_arc(7 downto 0) <= amp8_arc(6 downto 0) & input;                                                             
                            when others  => null;
                        end case;
                    when "0001" =>
                        case byteteller is
                            when "0001" => startbyte_arc(7 downto 0) <= startbyte_arc(6 downto 0) & input;
                            when "0010" => amp1_arc(7 downto 0) <= amp1_arc(6 downto 0) & input;
                            when "0011" => amp2_arc(7 downto 0) <= amp2_arc(6 downto 0) & input;
                            when "0100" => amp3_arc(7 downto 0) <= amp3_arc(6 downto 0) & input;
                            when "0101" => amp4_arc(7 downto 0) <= amp4_arc(6 downto 0) & input;
                            when "0110" => amp5_arc(7 downto 0) <= amp5_arc(6 downto 0) & input;
                            when "0111" => amp6_arc(7 downto 0) <= amp6_arc(6 downto 0) & input;
                            when "1000" => amp7_arc(7 downto 0) <= amp7_arc(6 downto 0) & input;
                            when "0000" => amp8_arc(7 downto 0) <= amp8_arc(6 downto 0) & input;                                                             
                            when others  => null;
                        end case;                    
                    when "0010" =>
                        case byteteller is
                            when "0010" => startbyte_arc(7 downto 0) <= startbyte_arc(6 downto 0) & input;
                            when "0011" => amp1_arc(7 downto 0) <= amp1_arc(6 downto 0) & input;
                            when "0100" => amp2_arc(7 downto 0) <= amp2_arc(6 downto 0) & input;
                            when "0101" => amp3_arc(7 downto 0) <= amp3_arc(6 downto 0) & input;
                            when "0110" => amp4_arc(7 downto 0) <= amp4_arc(6 downto 0) & input;
                            when "0111" => amp5_arc(7 downto 0) <= amp5_arc(6 downto 0) & input;
                            when "1000" => amp6_arc(7 downto 0) <= amp6_arc(6 downto 0) & input;
                            when "0000" => amp7_arc(7 downto 0) <= amp7_arc(6 downto 0) & input;
                            when "0001"=> amp8_arc(7 downto 0) <= amp8_arc(6 downto 0) & input;                                                             
                            when others  => null;
                        end case;                    
                    when "0011" =>
                        case byteteller is
                            when "0011" => startbyte_arc(7 downto 0) <= startbyte_arc(6 downto 0) & input;
                            when "0100" => amp1_arc(7 downto 0) <= amp1_arc(6 downto 0) & input;
                            when "0101" => amp2_arc(7 downto 0) <= amp2_arc(6 downto 0) & input;
                            when "0110" => amp3_arc(7 downto 0) <= amp3_arc(6 downto 0) & input;
                            when "0111" => amp4_arc(7 downto 0) <= amp4_arc(6 downto 0) & input;
                            when "1000" => amp5_arc(7 downto 0) <= amp5_arc(6 downto 0) & input;
                            when "0000" => amp6_arc(7 downto 0) <= amp6_arc(6 downto 0) & input;
                            when "0001" => amp7_arc(7 downto 0) <= amp7_arc(6 downto 0) & input;
                            when "0010"=> amp8_arc(7 downto 0) <= amp8_arc(6 downto 0) & input;                                                             
                            when others  => null;
                        end case;                    
                    when "0100" =>
                        case byteteller is
                            when "0100" => startbyte_arc(7 downto 0) <= startbyte_arc(6 downto 0) & input;
                            when "0101" => amp1_arc(7 downto 0) <= amp1_arc(6 downto 0) & input;
                            when "0110" => amp2_arc(7 downto 0) <= amp2_arc(6 downto 0) & input;
                            when "0111" => amp3_arc(7 downto 0) <= amp3_arc(6 downto 0) & input;
                            when "1000" => amp4_arc(7 downto 0) <= amp4_arc(6 downto 0) & input;
                            when "0000" => amp5_arc(7 downto 0) <= amp5_arc(6 downto 0) & input;
                            when "0001" => amp6_arc(7 downto 0) <= amp6_arc(6 downto 0) & input;
                            when "0010" => amp7_arc(7 downto 0) <= amp7_arc(6 downto 0) & input;
                            when "0011"=> amp8_arc(7 downto 0) <= amp8_arc(6 downto 0) & input;                                                             
                            when others  => null;
                        end case;                    
                    when "0101" =>
                         case byteteller is
                            when "0101" => startbyte_arc(7 downto 0) <= startbyte_arc(6 downto 0) & input;
                            when "0110" => amp1_arc(7 downto 0) <= amp1_arc(6 downto 0) & input;
                            when "0111" => amp2_arc(7 downto 0) <= amp2_arc(6 downto 0) & input;
                            when "1000" => amp3_arc(7 downto 0) <= amp3_arc(6 downto 0) & input;
                            when "0000" => amp4_arc(7 downto 0) <= amp4_arc(6 downto 0) & input;
                            when "0001" => amp5_arc(7 downto 0) <= amp5_arc(6 downto 0) & input;
                            when "0010" => amp6_arc(7 downto 0) <= amp6_arc(6 downto 0) & input;
                            when "0011" => amp7_arc(7 downto 0) <= amp7_arc(6 downto 0) & input;
                            when "0100"=> amp8_arc(7 downto 0) <= amp8_arc(6 downto 0) & input;                                                             
                            when others  => null;
                        end case;                   
                    when "0110" =>
                         case byteteller is
                            when "0110" => startbyte_arc(7 downto 0) <= startbyte_arc(6 downto 0) & input;
                            when "0111" => amp1_arc(7 downto 0) <= amp1_arc(6 downto 0) & input;
                            when "1000" => amp2_arc(7 downto 0) <= amp2_arc(6 downto 0) & input;
                            when "0000" => amp3_arc(7 downto 0) <= amp3_arc(6 downto 0) & input;
                            when "0001" => amp4_arc(7 downto 0) <= amp4_arc(6 downto 0) & input;
                            when "0010" => amp5_arc(7 downto 0) <= amp5_arc(6 downto 0) & input;
                            when "0011" => amp6_arc(7 downto 0) <= amp6_arc(6 downto 0) & input;
                            when "0100" => amp7_arc(7 downto 0) <= amp7_arc(6 downto 0) & input;
                            when "0101"=> amp8_arc(7 downto 0) <= amp8_arc(6 downto 0) & input;                                                             
                            when others  => null;
                        end case;                   
                    when "0111" =>
                        case byteteller is
                            when "0111" => startbyte_arc(7 downto 0) <= startbyte_arc(6 downto 0) & input;
                            when "1000" => amp1_arc(7 downto 0) <= amp1_arc(6 downto 0) & input;
                            when "0000" => amp2_arc(7 downto 0) <= amp2_arc(6 downto 0) & input;
                            when "0001" => amp3_arc(7 downto 0) <= amp3_arc(6 downto 0) & input;
                            when "0010" => amp4_arc(7 downto 0) <= amp4_arc(6 downto 0) & input;
                            when "0011" => amp5_arc(7 downto 0) <= amp5_arc(6 downto 0) & input;
                            when "0100" => amp6_arc(7 downto 0) <= amp6_arc(6 downto 0) & input;
                            when "0101" => amp7_arc(7 downto 0) <= amp7_arc(6 downto 0) & input;
                            when "0110"=> amp8_arc(7 downto 0) <= amp8_arc(6 downto 0) & input;                                                             
                            when others  => null;
                        end case;
                     when "1000" =>
                        case byteteller is
                            when "1000" => startbyte_arc(7 downto 0) <= startbyte_arc(6 downto 0) & input;
                            when "0000" => amp1_arc(7 downto 0) <= amp1_arc(6 downto 0) & input;
                            when "0001" => amp2_arc(7 downto 0) <= amp2_arc(6 downto 0) & input;
                            when "0010" => amp3_arc(7 downto 0) <= amp3_arc(6 downto 0) & input;
                            when "0011" => amp4_arc(7 downto 0) <= amp4_arc(6 downto 0) & input;
                            when "0100" => amp5_arc(7 downto 0) <= amp5_arc(6 downto 0) & input;
                            when "0101" => amp6_arc(7 downto 0) <= amp6_arc(6 downto 0) & input;
                            when "0110" => amp7_arc(7 downto 0) <= amp7_arc(6 downto 0) & input;
                            when "0111"=> amp8_arc(7 downto 0) <= amp8_arc(6 downto 0) & input;                                                             
                            when others  => null;
                        end case;                     
                      when others  => null;                    
                end case;
            end if;
            
        end if;
        if bitteller = 8 and byteteller = 0 and input = '0' then
        if not (startbyte_arc = "11111111") then
            if casenumber = 9 then
                casenumber <= "0000";
            else
                casenumber <= casenumber + 1;
            end if;
        else
            
        end if;
        end if;
    end if;
end process;          
end Behavioral;