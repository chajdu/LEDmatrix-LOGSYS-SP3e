----------------------------------------------------------------------------------
-- Company:         BME MIT
-- Engineer:        HAJDU Csaba (CH)
-- 
-- Create Date:     2017/09/04
-- Project Name:    LED_matrix_driver_SP3 
-- Module Name:     BRAM_bot_B (behavioral)
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


ENTITY BRAM_bot_B IS
    PORT (
        -- Clock
        clk         :   IN  STD_LOGIC;
        
        -- Memory read address
        ROM_addr    :   IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
        
        -- Memory data output
        ROM_dout    :   OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END BRAM_bot_B;


ARCHITECTURE behavioral OF BRAM_bot_B IS

    TYPE    ROM_type    IS  ARRAY (0 TO 1023) OF STD_LOGIC_VECTOR (7 downto 0);                 
    
    SIGNAL  ROM         :   ROM_TYPE := (
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"29", X"CC", X"FF", X"FD", X"40", X"03", X"03", X"8E", X"FF", X"FE", X"BB", X"03", X"03", X"44", X"DC", X"FF", X"FE", X"1A", X"03", X"05", X"9D", X"FF", X"FF", X"90", X"03", X"03", X"57", X"EB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"2A", X"CC", X"FF", X"FD", X"40", X"03", X"03", X"8D", X"FF", X"FF", X"BB", X"03", X"03", X"44", X"DC", X"FF", X"FE", X"1A", X"03", X"05", X"9D", X"FF", X"FF", X"90", X"03", X"03", X"57", X"EB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"2A", X"CD", X"FF", X"FD", X"40", X"03", X"03", X"8E", X"FF", X"FF", X"BB", X"03", X"03", X"44", X"DC", X"FF", X"FD", X"1A", X"03", X"05", X"9D", X"FF", X"FF", X"90", X"03", X"03", X"57", X"EB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"2A", X"CD", X"FF", X"FC", X"40", X"03", X"03", X"8C", X"FF", X"FF", X"BB", X"03", X"03", X"44", X"DC", X"FF", X"FD", X"1A", X"03", X"05", X"9E", X"FF", X"FF", X"90", X"03", X"03", X"57", X"EB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"2A", X"CD", X"FF", X"FC", X"3F", X"03", X"03", X"8C", X"FF", X"FE", X"BA", X"03", X"03", X"44", X"DC", X"FF", X"FD", X"1A", X"03", X"05", X"9E", X"FF", X"FF", X"90", X"03", X"03", X"56", X"EB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"2A", X"CD", X"FF", X"FC", X"3F", X"03", X"03", X"8E", X"FF", X"FE", X"BA", X"03", X"03", X"44", X"DC", X"FF", X"FD", X"1A", X"03", X"05", X"9E", X"FF", X"FF", X"90", X"03", X"03", X"57", X"EB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"2A", X"CD", X"FF", X"FB", X"3D", X"03", X"03", X"8D", X"FF", X"FE", X"BA", X"03", X"03", X"45", X"DE", X"FF", X"FF", X"1A", X"03", X"06", X"A0", X"FF", X"FF", X"92", X"03", X"03", X"57", X"EB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"2A", X"CD", X"FF", X"FF", X"4F", X"04", X"03", X"A3", X"FF", X"FE", X"BA", X"03", X"03", X"38", X"CF", X"FF", X"EA", X"17", X"03", X"05", X"84", X"FF", X"F3", X"7E", X"03", X"03", X"57", X"EB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"2A", X"CD", X"FF", X"FF", X"F6", X"F0", X"F0", X"FB", X"FF", X"FE", X"BA", X"03", X"03", X"04", X"0E", X"12", X"0F", X"03", X"03", X"03", X"08", X"0F", X"0E", X"08", X"03", X"03", X"57", X"EB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"2A", X"CD", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FE", X"BA", X"03", X"03", X"03", X"03", X"03", X"03", X"03", X"03", X"03", X"03", X"03", X"03", X"03", X"03", X"03", X"57", X"EB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"2A", X"CD", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"BD", X"03", X"08", X"08", X"08", X"08", X"08", X"08", X"08", X"08", X"08", X"08", X"08", X"08", X"08", X"03", X"5B", X"EC", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"2A", X"CD", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"F1", X"A8", X"A4", X"A5", X"A5", X"A5", X"A5", X"A5", X"A5", X"A5", X"A5", X"A5", X"A5", X"A5", X"A5", X"A1", X"D4", X"FC", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"29", X"CC", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"DB", X"03", X"03", X"29", X"D0", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"F0", X"69", X"66", X"85", X"E9", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
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
