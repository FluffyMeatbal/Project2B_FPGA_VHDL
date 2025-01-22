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
    Port ( klok, input : in STD_LOGIC;
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

    signal klok19200 : std_logic := '0';
    signal teller: Unsigned(3 downto 0) := (others => '0');
    signal teller2: Unsigned(3 downto 0) := (others => '0');
    
    signal testbyte_arc : Unsigned(7 downto 0) := (others => '0');
    signal testbyte2_arc : Unsigned(7 downto 0) := (others => '0');
    
    constant klokdeler1 : integer := 10416;
    signal klokteller1 : integer := 0;
    
    signal startbyte_arc : unsigned(7 downto 0) := (others => '0');
    signal amp1_arc : unsigned(7 downto 0) := (others => '0');
    signal amp2_arc : unsigned(7 downto 0) := (others => '0');
    signal amp3_arc : unsigned(7 downto 0) := (others => '0');
    signal amp4_arc : unsigned(7 downto 0) := (others => '0');
    signal amp5_arc : unsigned(7 downto 0) := (others => '0');
    signal amp6_arc : unsigned(7 downto 0) := (others => '0');
    signal amp7_arc : unsigned(7 downto 0) := (others => '0');
    signal amp8_arc : unsigned(7 downto 0) := (others => '0');
    
    signal startbyte_arc_utz : unsigned(7 downto 0) := (others => '0');
    signal amp1_arc_utz : unsigned(7 downto 0) := (others => '0');
    signal amp2_arc_utz : unsigned(7 downto 0) := (others => '0');
    signal amp3_arc_utz : unsigned(7 downto 0) := (others => '0');
    signal amp4_arc_utz : unsigned(7 downto 0) := (others => '0');
    signal amp5_arc_utz : unsigned(7 downto 0) := (others => '0');
    signal amp6_arc_utz : unsigned(7 downto 0) := (others => '0');
    signal amp7_arc_utz : unsigned(7 downto 0) := (others => '0');
    signal amp8_arc_utz : unsigned(7 downto 0) := (others => '0');
    
    signal casenumber : unsigned(3 downto 0) := (others => '0');       
    
begin

process_klokdeler1 : process(klok)
begin
    if rising_edge(klok) then
        if klokteller1 = klokdeler1 / 2 then
            klokteller1 <= klokteller1 + 1; klok19200 <= '1';
        else
            if klokteller1 = klokdeler1 then
                klok19200 <= '0'; klokteller1 <= 0;
            else
                klokteller1 <= klokteller1 + 1;
            end if; 
        end if;
    end if;
end process;
 
tellen : process(klok19200)
begin
    if falling_edge(klok19200) then
        if input = '0' or teller < 8 then                
            
            if not(teller < 8) then
                teller <= "0000";
                teller2 <= teller2 + 1;
                if not(teller2 < 8) then
                    teller2 <= "0000";
                end if;
            else
                teller <= teller + 1;
            end if;
            
            if not(teller = 8) then
                case casenumber is
                    when "0000" =>
                        case teller2 is
                            when "0000" => startbyte_arc(7 downto 0) <= input & startbyte_arc(7 downto 1);
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
                        case teller2 is
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
                        case teller2 is
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
                        case teller2 is
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
                        case teller2 is
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
                         case teller2 is
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
                         case teller2 is
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
                        case teller2 is
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
                        case teller2 is
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
        
        if teller = 8 and teller2 = 0 and input = '0' then
            if not (startbyte_arc = "11111111") then
                if casenumber = 9 then
                    casenumber <= "0000";
                else
                    casenumber <= casenumber + 1;
                end if;
             else
                
            end if;
        end if;
        if startbyte_arc = "11111111"then
               startbyte_arc_utz <= startbyte_arc;
               amp1_arc_utz <= amp1_arc;
               amp2_arc_utz <= amp2_arc;
               amp3_arc_utz <= amp3_arc;
               amp4_arc_utz <= amp4_arc;
               amp5_arc_utz <= amp5_arc;
               amp6_arc_utz <= amp6_arc;
               amp7_arc_utz <= amp7_arc;
               amp8_arc_utz <= amp8_arc; 
             else 
               startbyte_arc_utz <= (others => '0'); 
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
    amp1 <= std_logic_vector(amp1_arc_utz);
    amp2 <= std_logic_vector(amp2_arc_utz);
    amp3 <= std_logic_vector(amp3_arc_utz);
    amp4 <= std_logic_vector(amp4_arc_utz);
    amp5 <= std_logic_vector(amp5_arc_utz);
    amp6 <= std_logic_vector(amp6_arc_utz);
    amp7 <= std_logic_vector(amp7_arc_utz);
    amp8 <= std_logic_vector(amp8_arc_utz);      
end Behavioral;