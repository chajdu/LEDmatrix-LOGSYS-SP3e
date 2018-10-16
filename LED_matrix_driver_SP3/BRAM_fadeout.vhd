----------------------------------------------------------------------------------
-- Company:         BME MIT
-- Engineer:        HAJDU Csaba (CH)
-- 
-- Create Date:     2017/09/06
-- Project Name:    LED_matrix_driver_SP3 
-- Module Name:     BRAM_fadeout (behavioral)
-- Target Devices:  Spartan 3E XC3S250E-4TQ144C 
-- Tool versions: 
-- Description:
--      This module instantiates a memory block to store multiplier values
--      to implement a fade-out/fade-in effect in driving the LED matrix.
--
--
-- Changelog:
--      Date        Author      Description
--      2017/09/06  CH          File created
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
 USE IEEE.NUMERIC_STD.ALL;


ENTITY BRAM_fadeout IS
    PORT (
        -- Clock
        clk         :   IN  STD_LOGIC;
        
        -- Memory read address
        ROM_addr    :   IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        
        -- Memory data output
        ROM_dout    :   OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END BRAM_fadeout;


ARCHITECTURE behavioral OF BRAM_fadeout IS

    TYPE    ROM_type    IS  ARRAY (0 TO 255) OF STD_LOGIC_VECTOR (7 downto 0);                 
    
    SIGNAL  ROM         :   ROM_TYPE := (
        X"FF", X"FC", X"F9", X"F7", X"F4", X"F2", X"EF", X"ED", X"EA", X"E8", X"E5", X"E2", X"E0", X"DD", X"DB", X"D8",
        X"D6", X"D3", X"D1", X"CE", X"CB", X"C9", X"C6", X"C4", X"C1", X"BF", X"BC", X"BA", X"B7", X"B5", X"B2", X"AF",
        X"AD", X"AA", X"A8", X"A5", X"A3", X"A0", X"9E", X"9B", X"98", X"96", X"93", X"91", X"8E", X"8C", X"89", X"87",
        X"84", X"82", X"7F", X"7C", X"7A", X"77", X"75", X"72", X"70", X"6D", X"6B", X"68", X"65", X"63", X"60", X"5E",
        X"5B", X"59", X"56", X"54", X"51", X"4F", X"4C", X"49", X"47", X"44", X"42", X"3F", X"3D", X"3A", X"38", X"35",
        X"32", X"30", X"2D", X"2B", X"28", X"26", X"23", X"21", X"1E", X"1C", X"19", X"16", X"14", X"11", X"0F", X"0C",
        X"0A", X"07", X"05", X"02", X"00", X"02", X"05", X"07", X"0A", X"0C", X"0F", X"11", X"14", X"16", X"19", X"1C",
        X"1E", X"21", X"23", X"26", X"28", X"2B", X"2D", X"30", X"32", X"35", X"38", X"3A", X"3D", X"3F", X"42", X"44",
        X"47", X"49", X"4C", X"4F", X"51", X"54", X"56", X"59", X"5B", X"5E", X"60", X"63", X"65", X"68", X"6B", X"6D",
        X"70", X"72", X"75", X"77", X"7A", X"7C", X"7F", X"82", X"84", X"87", X"89", X"8C", X"8E", X"91", X"93", X"96",
        X"98", X"9B", X"9E", X"A0", X"A3", X"A5", X"A8", X"AA", X"AD", X"AF", X"B2", X"B5", X"B7", X"BA", X"BC", X"BF",
        X"C1", X"C4", X"C6", X"C9", X"CB", X"CE", X"D1", X"D3", X"D6", X"D8", X"DB", X"DD", X"E0", X"E2", X"E5", X"E8",
        X"EA", X"ED", X"EF", X"F2", X"F4", X"F7", X"F9", X"FC", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
        X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
        X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",
        X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00"
    );

    SIGNAL  ROM_rdata   :   STD_LOGIC_VECTOR(7 DOWNTO 0);
    
    -- The EN signal is unused in my design...
    SIGNAL  EN          :   STD_LOGIC := '1';


BEGIN

    ROM_rdata <= ROM(TO_INTEGER(UNSIGNED(ROM_addr)));


    PROCESS (clk) IS
    BEGIN
        IF RISING_EDGE(clk) THEN
            IF (EN = '1') THEN
                ROM_dout <= ROM_rdata;
            END IF;
        END IF;
    END PROCESS;


END behavioral;
