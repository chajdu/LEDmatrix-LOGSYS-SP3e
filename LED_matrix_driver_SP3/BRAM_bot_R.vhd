----------------------------------------------------------------------------------
-- Company:         BME MIT
-- Engineer:        HAJDU Csaba (CH)
-- 
-- Create Date:     2017/09/04
-- Project Name:    LED_matrix_driver_SP3 
-- Module Name:     BRAM_bot_R (behavioral)
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


ENTITY BRAM_bot_R IS
    PORT (
        -- Clock
        clk         :   IN  STD_LOGIC;
        
        -- Memory read address
        ROM_addr    :   IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
        
        -- Memory data output
        ROM_dout    :   OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END BRAM_bot_R;


ARCHITECTURE behavioral OF BRAM_bot_R IS

    TYPE    ROM_type    IS  ARRAY (0 TO 1023) OF STD_LOGIC_VECTOR (7 downto 0);                 
    
    SIGNAL  ROM         :   ROM_TYPE := (
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"83", X"E1", X"FF", X"FD", X"90", X"6D", X"6D", X"BD", X"FF", X"FE", X"D8", X"6D", X"6D", X"92", X"EA", X"FF", X"FE", X"7A", X"6D", X"6E", X"C6", X"FF", X"FF", X"BE", X"6D", X"6D", X"9D", X"F3", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"83", X"E1", X"FF", X"FD", X"90", X"6D", X"6D", X"BD", X"FF", X"FF", X"D8", X"6D", X"6D", X"92", X"EA", X"FF", X"FE", X"7A", X"6D", X"6E", X"C6", X"FF", X"FF", X"BE", X"6D", X"6D", X"9D", X"F3", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"83", X"E2", X"FF", X"FD", X"90", X"6D", X"6D", X"BD", X"FF", X"FF", X"D8", X"6D", X"6D", X"92", X"EA", X"FF", X"FD", X"7A", X"6D", X"6E", X"C6", X"FF", X"FF", X"BE", X"6D", X"6D", X"9D", X"F3", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"83", X"E2", X"FF", X"FD", X"90", X"6D", X"6D", X"BC", X"FF", X"FF", X"D8", X"6D", X"6D", X"92", X"EA", X"FF", X"FD", X"7A", X"6D", X"6E", X"C6", X"FF", X"FF", X"BE", X"6D", X"6D", X"9D", X"F3", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"83", X"E2", X"FF", X"FD", X"8F", X"6D", X"6D", X"BC", X"FF", X"FE", X"D7", X"6D", X"6D", X"92", X"EA", X"FF", X"FD", X"7A", X"6D", X"6E", X"C6", X"FF", X"FF", X"BE", X"6D", X"6D", X"9D", X"F3", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"83", X"E2", X"FF", X"FD", X"8F", X"6D", X"6D", X"BD", X"FF", X"FE", X"D7", X"6D", X"6D", X"92", X"EA", X"FF", X"FD", X"7A", X"6D", X"6E", X"C6", X"FF", X"FF", X"BE", X"6D", X"6D", X"9D", X"F3", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"83", X"E2", X"FF", X"FC", X"8E", X"6D", X"6D", X"BD", X"FF", X"FE", X"D7", X"6D", X"6D", X"93", X"EC", X"FF", X"FF", X"7A", X"6D", X"6F", X"C8", X"FF", X"FF", X"C0", X"6D", X"6D", X"9D", X"F3", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"83", X"E2", X"FF", X"FF", X"99", X"6E", X"6D", X"C9", X"FF", X"FE", X"D7", X"6D", X"6D", X"8B", X"E3", X"FF", X"F2", X"79", X"6D", X"6E", X"B8", X"FF", X"F8", X"B4", X"6D", X"6D", X"9D", X"F3", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"83", X"E2", X"FF", X"FF", X"F9", X"F6", X"F6", X"FC", X"FF", X"FE", X"D7", X"6D", X"6D", X"6E", X"73", X"76", X"74", X"6D", X"6D", X"6D", X"70", X"74", X"73", X"70", X"6D", X"6D", X"9D", X"F3", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"83", X"E2", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FE", X"D7", X"6D", X"6D", X"6D", X"6D", X"6D", X"6D", X"6D", X"6D", X"6D", X"6D", X"6D", X"6D", X"6D", X"6D", X"6D", X"9D", X"F3", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"83", X"E2", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"D9", X"6D", X"70", X"70", X"70", X"70", X"70", X"70", X"70", X"70", X"70", X"70", X"70", X"70", X"70", X"6D", X"A0", X"F4", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"83", X"E2", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"F6", X"CC", X"CA", X"CA", X"CA", X"CA", X"CA", X"CA", X"CA", X"CA", X"CA", X"CA", X"CA", X"CA", X"CA", X"C8", X"E6", X"FD", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"E8", X"6D", X"6D", X"83", X"E1", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"EA", X"6D", X"6D", X"83", X"E4", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
        X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"F6", X"A8", X"A6", X"B8", X"F2", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF", X"FF",
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
