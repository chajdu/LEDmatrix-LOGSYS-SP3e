----------------------------------------------------------------------------------
-- Company:         BME MIT
-- Engineer:        HAJDU Csaba (CH)
-- 
-- Create Date:     2017/09/04
-- Project Name:    LED_matrix_driver_SP3 
-- Module Name:     BRAM_top_B (behavioral)
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


ENTITY BRAM_top_B IS
    PORT (
        -- Clock
        clk         :   IN  STD_LOGIC;
        
        -- Memory read address
        ROM_addr    :   IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
        
        -- Memory data output
        ROM_dout    :   OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END BRAM_top_B;


ARCHITECTURE behavioral OF BRAM_top_B IS

    TYPE    ROM_type    IS  ARRAY (0 TO 1023) OF STD_LOGIC_VECTOR (7 downto 0);                 
    
    SIGNAL  ROM         :   ROM_TYPE := (
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FD", X"FB", X"FB", X"FD", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"AF", X"2B", X"24", X"87", X"F4", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"8C", X"03", X"03", X"54", X"EB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"F4", X"F1", X"F1", X"F1", X"F1", X"F1", X"F1", X"F1", X"F2", X"FE", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"90", X"03", X"03", X"57", X"EC", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"F1", X"76", X"72", X"72", X"72", X"72", X"72", X"72", X"72", X"70", X"CF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"90", X"03", X"03", X"57", X"EC", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D7", X"03", X"03", X"03", X"03", X"03", X"03", X"03", X"03", X"03", X"87", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"90", X"03", X"03", X"57", X"EC", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"03", X"03", X"03", X"03", X"03", X"03", X"03", X"8C", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"90", X"03", X"03", X"57", X"EC", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"0A", X"3C", X"5E", X"4E", X"12", X"03", X"03", X"8C", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"C8", X"B1", X"B2", X"F7", X"FF", X"FF", X"90", X"03", X"03", X"57", X"EC", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"23", X"B3", X"F0", X"E1", X"38", X"03", X"03", X"8C", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"48", X"2D", X"2E", X"C4", X"FF", X"FF", X"90", X"03", X"03", X"57", X"EC", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"2A", X"CE", X"FF", X"FF", X"41", X"03", X"03", X"90", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FE", X"26", X"16", X"13", X"B2", X"FF", X"FF", X"90", X"03", X"03", X"59", X"EE", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"29", X"CC", X"FF", X"FD", X"40", X"03", X"03", X"71", X"F2", X"F0", X"F0", X"F0", X"EF", X"FA", X"FF", X"FF", X"FF", X"52", X"2C", X"2C", X"CD", X"FF", X"FF", X"90", X"03", X"03", X"44", X"DA", X"F0", X"FB", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"29", X"CC", X"FF", X"FD", X"40", X"03", X"03", X"08", X"10", X"10", X"10", X"10", X"09", X"55", X"E3", X"FF", X"FF", X"F5", X"F2", X"F2", X"FC", X"FF", X"FF", X"90", X"03", X"03", X"06", X"0F", X"0F", X"23", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"29", X"CC", X"FF", X"FD", X"40", X"03", X"03", X"03", X"03", X"03", X"03", X"03", X"03", X"44", X"DC", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"90", X"03", X"03", X"03", X"03", X"03", X"0B", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"29", X"CC", X"FF", X"FD", X"40", X"03", X"03", X"04", X"07", X"07", X"05", X"03", X"03", X"44", X"DC", X"FF", X"FF", X"FB", X"FA", X"FA", X"FE", X"FF", X"FF", X"90", X"03", X"03", X"03", X"06", X"06", X"0F", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"29", X"CC", X"FF", X"FD", X"40", X"03", X"03", X"43", X"AA", X"A6", X"66", X"03", X"03", X"44", X"DC", X"FF", X"FF", X"73", X"50", X"54", X"D3", X"FF", X"FF", X"90", X"03", X"03", X"27", X"96", X"A8", X"BF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D8", X"03", X"03", X"29", X"CC", X"FF", X"FD", X"40", X"03", X"03", X"95", X"FF", X"FF", X"C3", X"03", X"03", X"44", X"DC", X"FF", X"FC", X"12", X"03", X"03", X"98", X"FF", X"FF", X"90", X"03", X"03", X"5C", X"F3", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF"
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
