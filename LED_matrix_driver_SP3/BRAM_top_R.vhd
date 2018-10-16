----------------------------------------------------------------------------------
-- Company:         BME MIT
-- Engineer:        HAJDU Csaba (CH)
-- 
-- Create Date:     2017/09/04
-- Project Name:    LED_matrix_driver_SP3 
-- Module Name:     BRAM_top_R (behavioral)
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


ENTITY BRAM_top_R IS
    PORT (
        -- Clock
        clk         :   IN  STD_LOGIC;
        
        -- Memory read address
        ROM_addr    :   IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
        
        -- Memory data output
        ROM_dout    :   OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END BRAM_top_R;


ARCHITECTURE behavioral OF BRAM_top_R IS

    TYPE    ROM_type    IS  ARRAY (0 TO 1023) OF STD_LOGIC_VECTOR (7 downto 0);                 
    
    SIGNAL  ROM         :   ROM_TYPE := (
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FD", X"FC", X"FC", X"FD", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D1", X"84", X"80", X"B9", X"F8", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"BC", X"6D", X"6D", X"9B", X"F3", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"F8", X"F6", X"F6", X"F6", X"F6", X"F6", X"F6", X"F6", X"F7", X"FE", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"BE", X"6D", X"6D", X"9E", X"F4", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"F6", X"AF", X"AD", X"AD", X"AD", X"AD", X"AD", X"AD", X"AD", X"AC", X"E3", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"BE", X"6D", X"6D", X"9E", X"F4", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"6D", X"6D", X"6D", X"6D", X"6D", X"6D", X"6D", X"B9", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"BE", X"6D", X"6D", X"9E", X"F4", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"6D", X"6D", X"6D", X"6D", X"6D", X"6D", X"6D", X"BC", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"BE", X"6D", X"6D", X"9E", X"F4", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"71", X"8E", X"A2", X"98", X"76", X"6D", X"6D", X"BC", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"CA", X"B2", X"B4", X"F7", X"FF", X"FF", X"BE", X"6D", X"6D", X"9E", X"F4", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"7F", X"D3", X"F6", X"ED", X"8B", X"6D", X"6D", X"BC", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"4D", X"34", X"35", X"C6", X"FF", X"FF", X"BE", X"6D", X"6D", X"9E", X"F4", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"83", X"E2", X"FF", X"FF", X"91", X"6D", X"6D", X"BE", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FE", X"2C", X"1E", X"1B", X"B5", X"FF", X"FF", X"BE", X"6D", X"6D", X"9F", X"F5", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"83", X"E1", X"FF", X"FD", X"90", X"6D", X"6D", X"AD", X"F7", X"F6", X"F6", X"F6", X"F5", X"FC", X"FF", X"FF", X"FF", X"58", X"33", X"33", X"CF", X"FF", X"FF", X"BE", X"6D", X"6D", X"92", X"E9", X"F6", X"FC", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"83", X"E1", X"FF", X"FD", X"90", X"6D", X"6D", X"70", X"75", X"75", X"75", X"75", X"71", X"9C", X"EE", X"FF", X"FF", X"F5", X"F2", X"F3", X"FC", X"FF", X"FF", X"BE", X"6D", X"6D", X"6F", X"74", X"74", X"7F", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"83", X"E1", X"FF", X"FD", X"90", X"6D", X"6D", X"6D", X"6D", X"6D", X"6D", X"6D", X"6D", X"92", X"EA", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"BE", X"6D", X"6D", X"6D", X"6D", X"6D", X"72", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"83", X"E1", X"FF", X"FD", X"90", X"6D", X"6D", X"6E", X"6F", X"6F", X"6E", X"6D", X"6D", X"92", X"EA", X"FF", X"FF", X"FC", X"FC", X"FC", X"FE", X"FF", X"FF", X"BE", X"6D", X"6D", X"6D", X"6F", X"6F", X"74", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"83", X"E1", X"FF", X"FD", X"90", X"6D", X"6D", X"92", X"CD", X"CB", X"A6", X"6D", X"6D", X"92", X"EA", X"FF", X"FF", X"AE", X"99", X"9B", X"E5", X"FF", X"FF", X"BE", X"6D", X"6D", X"82", X"C2", X"CC", X"DA", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"83", X"E1", X"FF", X"FD", X"90", X"6D", X"6D", X"C1", X"FF", X"FF", X"DC", X"6D", X"6D", X"92", X"EA", X"FF", X"FD", X"76", X"6D", X"6D", X"C3", X"FF", X"FF", X"BE", X"6D", X"6D", X"A1", X"F8", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF"
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
