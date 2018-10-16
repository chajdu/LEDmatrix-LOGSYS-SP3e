----------------------------------------------------------------------------------
-- Company:         BME MIT
-- Engineer:        HAJDU Csaba (CH)
-- 
-- Create Date:     2017/09/04
-- Project Name:    LED_matrix_driver_SP3 
-- Module Name:     BRAM_bot_G (behavioral)
-- Target Devices:  Spartan 3E XC3S250E-4TQ144C 
-- Tool versions: 
-- Description:
--      This module instantiates one of the 6 memory blocks used to store
--      the pixel color depth values. The memory blocks are instantiated in
--      read-only mode (write signals unconnected).
--
--
-- Changelog:
--      Date        Author      Description
--      2017/09/04  CH          File created
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
 USE IEEE.NUMERIC_STD.ALL;


ENTITY BRAM_bot_G IS
    PORT (
        -- Clock
        clk         :   IN  STD_LOGIC;
        
        -- Memory read address
        ROM_addr    :   IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
        
        -- Memory data output
        ROM_dout    :   OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END BRAM_bot_G;


ARCHITECTURE behavioral OF BRAM_bot_G IS

    TYPE    ROM_type    IS  ARRAY (0 TO 1023) OF STD_LOGIC_VECTOR (7 downto 0);                 
    
    SIGNAL  ROM         :   ROM_TYPE := (
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"01", X"01", X"27", X"CC", X"FF", X"FD", X"3E", X"01", X"01", X"8D", X"FF", X"FE", X"BB", X"01", X"01", X"42", X"DC", X"FF", X"FE", X"18", X"01", X"03", X"9C", X"FF", X"FF", X"8F", X"01", X"01", X"55", X"EB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"01", X"01", X"28", X"CC", X"FF", X"FD", X"3E", X"01", X"01", X"8C", X"FF", X"FF", X"BB", X"01", X"01", X"42", X"DC", X"FF", X"FE", X"18", X"01", X"03", X"9C", X"FF", X"FF", X"8F", X"01", X"01", X"55", X"EB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"01", X"01", X"28", X"CD", X"FF", X"FD", X"3E", X"01", X"01", X"8D", X"FF", X"FF", X"BB", X"01", X"01", X"42", X"DC", X"FF", X"FD", X"18", X"01", X"03", X"9C", X"FF", X"FF", X"8F", X"01", X"01", X"55", X"EB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"01", X"01", X"28", X"CD", X"FF", X"FC", X"3E", X"01", X"01", X"8B", X"FF", X"FF", X"BB", X"01", X"01", X"42", X"DC", X"FF", X"FD", X"18", X"01", X"03", X"9D", X"FF", X"FF", X"8F", X"01", X"01", X"55", X"EB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"01", X"01", X"28", X"CD", X"FF", X"FC", X"3D", X"01", X"01", X"8B", X"FF", X"FE", X"BA", X"01", X"01", X"42", X"DC", X"FF", X"FD", X"18", X"01", X"03", X"9D", X"FF", X"FF", X"8F", X"01", X"01", X"54", X"EB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"01", X"01", X"28", X"CD", X"FF", X"FC", X"3D", X"01", X"01", X"8D", X"FF", X"FE", X"BA", X"01", X"01", X"42", X"DC", X"FF", X"FD", X"18", X"01", X"03", X"9D", X"FF", X"FF", X"8F", X"01", X"01", X"55", X"EB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"01", X"01", X"28", X"CD", X"FF", X"FB", X"3B", X"01", X"01", X"8C", X"FF", X"FE", X"BA", X"01", X"01", X"43", X"DE", X"FF", X"FF", X"18", X"01", X"04", X"9F", X"FF", X"FF", X"91", X"01", X"01", X"55", X"EB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"01", X"01", X"28", X"CD", X"FF", X"FF", X"4D", X"02", X"01", X"A2", X"FF", X"FE", X"BA", X"01", X"01", X"36", X"CF", X"FF", X"EA", X"15", X"01", X"03", X"83", X"FF", X"F3", X"7D", X"01", X"01", X"55", X"EB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"01", X"01", X"28", X"CD", X"FF", X"FF", X"F6", X"F0", X"F0", X"FB", X"FF", X"FE", X"BA", X"01", X"01", X"02", X"0C", X"10", X"0D", X"01", X"01", X"01", X"06", X"0D", X"0C", X"06", X"01", X"01", X"55", X"EB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"01", X"01", X"28", X"CD", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FE", X"BA", X"01", X"01", X"01", X"01", X"01", X"01", X"01", X"01", X"01", X"01", X"01", X"01", X"01", X"01", X"01", X"55", X"EB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"01", X"01", X"28", X"CD", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"BD", X"01", X"06", X"06", X"06", X"06", X"06", X"06", X"06", X"06", X"06", X"06", X"06", X"06", X"06", X"01", X"5A", X"EC", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"01", X"01", X"28", X"CD", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"F1", X"A7", X"A3", X"A4", X"A4", X"A4", X"A4", X"A4", X"A4", X"A4", X"A4", X"A4", X"A4", X"A4", X"A4", X"A0", X"D4", X"FC", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"01", X"01", X"27", X"CC", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"DB", X"01", X"01", X"27", X"D0", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"F0", X"68", X"65", X"84", X"E9", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF"
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
