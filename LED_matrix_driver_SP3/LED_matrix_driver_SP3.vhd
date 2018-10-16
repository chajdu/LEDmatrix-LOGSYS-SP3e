----------------------------------------------------------------------------------
-- Company:         BME MIT
-- Engineer:        HAJDU Csaba (CH)
-- 
-- Create Date:     2017/09/04
-- Project Name:    LED_matrix_driver_SP3 
-- Module Name:     LED_matrix_driver_SP3 (behavioral)
-- Target Devices:  Spartan 3E XC3S250E-4TQ144C 
-- Tool versions: 
-- Description:
--      The project drives a 64x32 RGB LED matrix (passive) in true color
--      using a bitmap saved in on-board memory.
--
--
-- Changelog:
--      Date        Author      Description
--      2017/09/04  CH          File created
--      2017/09/20  CH          Color mixing modified: the RGB components are now time-multiplexed instead of being driven
--                              simultaneously
--                              MOTIVATION: when R is mixed to G or B simultaneously, the resulting color isn't always
--                              uniform across the screen. This is probably due to the different forward voltages of the
--                              RGB LEDs. This is an attempt to remedy this problem
--                              The ROM read address is now generated from the row and column counters
--      2017/09/21  CH          BUGFIX: the column counter is now incremented in DrawRow_LEDAssertData instead of DrawRow_LEDAssertClock.
--                              This compensates the 1 c.c. additional latency caused by registering the ROM outputs, so the first column
--                              is no longer asserted twice
--                              BUGFIX: comparison to PWM_cnt no longer allows equality so pixels set to 0 are completely dark
--      2017/09/22  CH          New feature: image now rotates instead of fading in and out
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY LED_matrix_driver_SP3 IS
    PORT (
        -- Oscillator output
        clk16M  :   IN  STD_LOGIC;
        
        -- Reset button
        rstbt   :   IN  STD_LOGIC;
        
        -- I/O headers (output-capable pins only, as outputs)
        aio     :   OUT STD_LOGIC_VECTOR (14 DOWNTO 4);
        bio     :   OUT STD_LOGIC_VECTOR (14 DOWNTO 4);
        
        -- 7-segment and dot matrix digit and column selectors (only to disable them)
        seg_n   :   OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        dig_n   :   OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        col_n   :   OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
    );
END LED_matrix_driver_SP3;


ARCHITECTURE behavioral OF LED_matrix_driver_SP3 IS

    -- Number of screen refreshes before fadeout memory address advance
    CONSTANT    FadeOutCnt_max          :   NATURAL := 2;
    
    -- Number of samples in fadeout memory
    CONSTANT    FadeOut_SampleNo        :   NATURAL := 200;

    -- Number of screen refreshes before LED column rotation
    CONSTANT    ColumnRotateCnt_max     :   NATURAL := 5;
    
    -- Pulse stretching duration for the LED strobe pulse (clock cycles)
    CONSTANT    PulseStretchDuration    :   NATURAL := 5;


    -- System clock
    SIGNAL      sys_clk                 :   STD_LOGIC;
    
    -- DCM locked output
    SIGNAL      DCM_locked              :   STD_LOGIC;
    
    
    -- ROM read address
    SIGNAL      ROM_addr                :   STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '0');
    
    -- ROM output signals
    SIGNAL      ROM_top_R_dout          :   STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL      ROM_top_G_dout          :   STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL      ROM_top_B_dout          :   STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL      ROM_bot_R_dout          :   STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL      ROM_bot_G_dout          :   STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL      ROM_bot_B_dout          :   STD_LOGIC_VECTOR(7 DOWNTO 0);

    -- Fadeout ROM signals
    SIGNAL      ROM_fadeout_addr        :   STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL      ROM_fadeout_dout        :   STD_LOGIC_VECTOR(7 DOWNTO 0);   

    -- Fadeout signals
    SIGNAL      ROM_top_R_mult          :   UNSIGNED(15 DOWNTO 0);
    SIGNAL      ROM_top_G_mult          :   UNSIGNED(15 DOWNTO 0);
    SIGNAL      ROM_top_B_mult          :   UNSIGNED(15 DOWNTO 0);
    SIGNAL      ROM_bot_R_mult          :   UNSIGNED(15 DOWNTO 0);
    SIGNAL      ROM_bot_G_mult          :   UNSIGNED(15 DOWNTO 0);
    SIGNAL      ROM_bot_B_mult          :   UNSIGNED(15 DOWNTO 0);

    SIGNAL      ROM_top_R_fade          :   UNSIGNED(7 DOWNTO 0);
    SIGNAL      ROM_top_G_fade          :   UNSIGNED(7 DOWNTO 0);
    SIGNAL      ROM_top_B_fade          :   UNSIGNED(7 DOWNTO 0);
    SIGNAL      ROM_bot_R_fade          :   UNSIGNED(7 DOWNTO 0);
    SIGNAL      ROM_bot_G_fade          :   UNSIGNED(7 DOWNTO 0);
    SIGNAL      ROM_bot_B_fade          :   UNSIGNED(7 DOWNTO 0);
    
    -- PWM done signal to fadeout ROM
    SIGNAL      PWM_done                :   STD_LOGIC := '0';

    
    -- LED matrix control signals
    SIGNAL      LED_CLK                 :   STD_LOGIC := '0';
    SIGNAL      LED_OEn                 :   STD_LOGIC := '1';
    SIGNAL      LED_STB                 :   STD_LOGIC := '0';
    SIGNAL      LED_DCBA                :   STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL      LED_R0                  :   STD_LOGIC := '0';
    SIGNAL      LED_R1                  :   STD_LOGIC := '0';
    SIGNAL      LED_G0                  :   STD_LOGIC := '0';
    SIGNAL      LED_G1                  :   STD_LOGIC := '0';
    SIGNAL      LED_B0                  :   STD_LOGIC := '0';
    SIGNAL      LED_B1                  :   STD_LOGIC := '0';
    
          
    -- Control FSM state type and signal
    TYPE        ControlFSM_state_type   IS  ( Idle, DrawRow, DrawRow_LEDAssertData, DrawRow_LEDAssertClock, RowDone_DisableOutput, RowDone_StrobeNewData, RowDone_Wait, RowDone_EnableOutput);
    SIGNAL      ControlFSM_state        :   ControlFSM_state_type := Idle;
    
    
    -- Type for storing current color
    TYPE        LED_color_type          IS  ( Red, Green, Blue );
    
    
    -- LED column base address
    -- Set by a timed process in order to rotate image
    SIGNAL      LED_col_addr_base       :   UNSIGNED(5 DOWNTO 0) := (OTHERS => '0');
       

BEGIN

-- ----------------------------
--  Logic
-- ----------------------------

    -- Control FSM
    PControlFSM : PROCESS(sys_clk) IS   
        -- LED row and column counters (2x16 rows, 64 columns)
        VARIABLE    LED_row_cnt             :   UNSIGNED(3 DOWNTO 0) := (OTHERS => '0');
        VARIABLE    LED_col_cnt             :   UNSIGNED(5 DOWNTO 0) := (OTHERS => '0');
        
        -- LED column address
        -- Separate from column counter to allow rotating image
        VARIABLE    LED_col_addr            :   UNSIGNED(5 DOWNTO 0) := (OTHERS => '0');

        -- PWM counter
        VARIABLE    PWM_cnt                 :   UNSIGNED(7 DOWNTO 0) := TO_UNSIGNED(255, 8);
        
        -- Pulse stretch counter
        VARIABLE    PulseStretch_cnt        :   NATURAL RANGE 0 TO 5;
        
        -- Current LED color
        VARIABLE    LED_color               :   LED_color_type := Red;
        
    BEGIN
        IF DCM_locked = '1' AND RISING_EDGE(sys_clk) THEN
            -- Default values
            PWM_done <= '0';
            LED_CLK <= '0';
            LED_STB <= '0';
            
            CASE ControlFSM_state IS
            
                -- The state machine starts in Idle. It shouldn't linger here...
                WHEN Idle =>
                    -- Start processing the rows of the display
                    ControlFSM_state <= DrawRow;
                
                
                -- Initiate the processing of a row
                WHEN DrawRow =>
                    -- If we're at the first row, increment PWM counter
                    IF LED_row_cnt = TO_UNSIGNED(0, 4) THEN
                        PWM_cnt := PWM_cnt + 1;

                        -- When the PWM counter has overflowed, send a signal to the process controlling the fadeout memory
                        IF PWM_cnt = 0 THEN
                            PWM_done <= '1';
                        END IF;
                    END IF;
                    
                    -- Load base column address into counter
                    LED_col_addr := LED_col_addr_base;
                    
                    -- Switch to asserting LED data lines
                    --   - The initial ROM address is already correctly set
                    ControlFSM_state <= DrawRow_LEDAssertData;
                
                
                -- Drive LED control lines based on the pixel values read from the memory and the current value of the PWM counter
                -- Also increment column counter which will be used in the generation of the ROM read address
                WHEN DrawRow_LEDAssertData =>
                    -- Increment column counter
                    LED_col_cnt := LED_col_cnt + 1;
                    
                    -- Also increment column address
                    -- This value is used as the LSBs for the ROM read address. It is incremented here because the output
                    -- of the ROMs is registered -> one additional c.c. of latency
                    LED_col_addr := LED_col_addr + 1;


                    CASE LED_color IS
                        WHEN Red =>
                            -- Top half, red LEDs
                            IF ROM_top_R_fade > PWM_cnt THEN
                                LED_R0 <= '1';
                            ELSE
                                LED_R0 <= '0';
                            END IF;

                            -- Bottom half, red LEDs
                            IF ROM_bot_R_fade > PWM_cnt THEN
                                LED_R1 <= '1';
                            ELSE
                                LED_R1 <= '0';
                            END IF;
                            
                            -- Disable everything else
                            LED_G0 <= '0';
                            LED_G1 <= '0';
                            LED_B0 <= '0';
                            LED_B1 <= '0';
                            
                        WHEN Green =>
                            -- Top half, green LEDs
                            IF ROM_top_G_fade > PWM_cnt THEN
                                LED_G0 <= '1';
                            ELSE
                                LED_G0 <= '0';
                            END IF;

                            -- Bottom half, green LEDs
                            IF ROM_bot_G_fade > PWM_cnt THEN
                                LED_G1 <= '1';
                            ELSE
                                LED_G1 <= '0';
                            END IF;

                            -- Disable everything else
                            LED_R0 <= '0';
                            LED_R1 <= '0';
                            LED_B0 <= '0';
                            LED_B1 <= '0';
                            
                        WHEN Blue =>
                            -- Top half, blue LEDs
                            IF ROM_top_B_fade > PWM_cnt THEN
                                LED_B0 <= '1';
                            ELSE
                                LED_B0 <= '0';
                            END IF;

                            -- Bottom half, blue LEDs
                            IF ROM_bot_B_fade > PWM_cnt THEN
                                LED_B1 <= '1';
                            ELSE
                                LED_B1 <= '0';
                            END IF;

                            -- Disable everything else
                            LED_R0 <= '0';
                            LED_R1 <= '0';
                            LED_G0 <= '0';
                            LED_G1 <= '0';

                    END CASE;
                    
                    -- Clock out the data into the shift registers
                    ControlFSM_state <= DrawRow_LEDAssertClock;
                

                -- Assert LED clock
                WHEN DrawRow_LEDAssertClock =>
                    -- Assert LED clock
                    LED_CLK <= '1';
                                        
                    -- If the column counter (incremented in DrawRow_LEDAssertData) has overflowed, this row is done
                    IF LED_col_cnt = TO_UNSIGNED(0, 6) THEN
                        ControlFSM_state <= RowDone_DisableOutput;
                    ELSE
                        -- Otherwise, switch back to asserting data
                        ControlFSM_state <= DrawRow_LEDAssertData;
                    END IF;

            
                -- Processing of row done, disable LED drivers to get ready for driving the next row
                WHEN RowDone_DisableOutput =>
                    -- Disable LED driver output
                    LED_OEn <= '1';
                    
                    -- Reset pulse stretching counter to stretch out the Strobe pulse
                    PulseStretch_cnt := 0;

                    -- Switch to next state
                    ControlFSM_state <= RowDone_StrobeNewData;
                
                
                -- Copy the control signals from the shift registers onto the outputs
                WHEN RowDone_StrobeNewData =>
                    -- Assert strobe to shift registers
                    LED_STB <= '1';
                    
                    -- Increment pulse stretch counter
                    PulseStretch_cnt := PulseStretch_cnt + 1;
                    
                    IF PulseStretch_cnt = PulseStretchDuration THEN
                        -- Select LED row for shift register output
                        LED_DCBA <= STD_LOGIC_VECTOR(LED_row_cnt);

                        -- Reset pulse stretching counter for the Wait state
                        PulseStretch_cnt := 0;                        
                        
                        -- Switch to next state
                        ControlFSM_state <= RowDone_Wait;
                    END IF;


                -- Wait a couple of clock cycles before enabling the LED drivers
                WHEN RowDone_Wait =>
                    -- Increment pulse stretch counter
                    PulseStretch_cnt := PulseStretch_cnt + 1;

                    IF PulseStretch_cnt = PulseStretchDuration THEN
                        -- Switch to next state
                        ControlFSM_state <= RowDone_EnableOutput;
                    END IF;
                    

                -- Enable LED drivers
                WHEN RowDone_EnableOutput =>
                    -- Enable LED drivers
                    LED_OEn <= '0';

                    CASE LED_color IS
                        WHEN Red =>
                            LED_color := Green;
                            
                        WHEN Green =>
                            LED_color := Blue;
                            
                        WHEN Blue =>
                            LED_color := Red;
                            
                            -- In this case, also switch to next row by incrementing row counter
                            -- No need for overflow handling. Drawing the screen starts over in case of overflow
                            LED_row_cnt := LED_row_cnt + 1;
                    END CASE;
                    
                    -- Start drawing the new row (or the next color for the same row)
                    ControlFSM_state <= DrawRow;
                    
            END CASE;
            
            -- Generate ROM address from the row and column counters
            ROM_addr <= STD_LOGIC_VECTOR(LED_row_cnt) & STD_LOGIC_VECTOR(LED_col_addr);
        END IF;
    END PROCESS;
    
    
    -- Address generation for fadeout ROM
    PFadeoutAddrGen : PROCESS(sys_clk) IS
        VARIABLE    FadeOutCnt              :   NATURAL := 0;
        VARIABLE    FadeOutMemAddr          :   UNSIGNED(7 DOWNTO 0) := (OTHERS => '0');
        
        
    BEGIN
        IF DCM_locked = '1' AND RISING_EDGE(sys_clk) THEN
            IF PWM_done = '1' THEN
                -- Increment counter
                FadeOutCnt := FadeOutCnt + 1;
                
                -- Has it reached the preset value?
                IF FadeOutCnt = FadeOutCnt_max THEN
                    -- Reset counter
                    FadeOutCnt := 0;
                    
                    -- Increment memory address
                    FadeOutMemAddr := FadeOutMemAddr + 1;
                    
                    -- If we'd exceed the size of the memory block, reset address
                    IF FadeOutMemAddr = FadeOut_SampleNo THEN
                        FadeOutMemAddr := (OTHERS => '0');
                    END IF;
                END IF;
            END IF;
            
            -- Assert read address to memory block
            ROM_fadeout_addr <= STD_LOGIC_VECTOR(FadeOutMemAddr);
        END IF;
    END PROCESS;
    
    
    -- Column base address generator for image rotation
    PRotate : PROCESS(sys_clk) IS
        VARIABLE    ColumnRotateCnt         :   NATURAL := 0;
    
    
    BEGIN
        IF DCM_locked = '1' AND RISING_EDGE(sys_clk) THEN
            IF PWM_done = '1' THEN
                -- Increment counter
                ColumnRotateCnt := ColumnRotateCnt + 1;
                
                -- Has it reached the preset value?
                IF ColumnRotateCnt = ColumnRotateCnt_max THEN
                    -- Reset counter
                    ColumnRotateCnt := 0;
                    
                    -- Increment memory address
                    LED_col_addr_base <= LED_col_addr_base + 1;                    
                END IF;
            END IF;
        END IF;
    END PROCESS;
    
    -- Disable image rotation
--    LED_col_addr_base <= (OTHERS => '0');
    
    
    -- Implement multiplication for fadeout
    ROM_top_R_mult <= UNSIGNED(ROM_top_R_dout) * UNSIGNED(ROM_fadeout_dout);
    ROM_top_R_fade <= ROM_top_R_mult(15 DOWNTO 8);

    ROM_top_G_mult <= UNSIGNED(ROM_top_G_dout) * UNSIGNED(ROM_fadeout_dout);
    ROM_top_G_fade <= ROM_top_G_mult(15 DOWNTO 8);

    ROM_top_B_mult <= UNSIGNED(ROM_top_B_dout) * UNSIGNED(ROM_fadeout_dout);
    ROM_top_B_fade <= ROM_top_B_mult(15 DOWNTO 8);

    ROM_bot_R_mult <= UNSIGNED(ROM_bot_R_dout) * UNSIGNED(ROM_fadeout_dout);
    ROM_bot_R_fade <= ROM_bot_R_mult(15 DOWNTO 8);

    ROM_bot_G_mult <= UNSIGNED(ROM_bot_G_dout) * UNSIGNED(ROM_fadeout_dout);
    ROM_bot_G_fade <= ROM_bot_G_mult(15 DOWNTO 8);

    ROM_bot_B_mult <= UNSIGNED(ROM_bot_B_dout) * UNSIGNED(ROM_fadeout_dout);
    ROM_bot_B_fade <= ROM_bot_B_mult(15 DOWNTO 8);

    -- Disable fadeout
--    ROM_top_R_fade <= UNSIGNED(ROM_top_R_dout);
--    ROM_top_G_fade <= UNSIGNED(ROM_top_G_dout);
--    ROM_top_B_fade <= UNSIGNED(ROM_top_B_dout);
--    ROM_bot_R_fade <= UNSIGNED(ROM_bot_R_dout);
--    ROM_bot_G_fade <= UNSIGNED(ROM_bot_G_dout);
--    ROM_bot_B_fade <= UNSIGNED(ROM_bot_B_dout);

    -- Debug
--    ROM_top_R_fade <= (OTHERS => '1');
--    ROM_top_G_fade <= (OTHERS => '1');
--    ROM_top_B_fade <= (OTHERS => '1');
--    ROM_bot_R_fade <= (OTHERS => '1');
--    ROM_bot_G_fade <= (OTHERS => '1');
--    ROM_bot_B_fade <= (OTHERS => '1');


-- ----------------------------
--  Connecting outputs
-- ----------------------------
    aio(4)  <= LED_R0;
    aio(6)  <= LED_G0;
    aio(8)  <= LED_B0;
    aio(10) <= '0';
    aio(12) <= LED_R1;
    aio(11) <= LED_G1;
    aio(14) <= LED_B1;
    aio(13) <= '0';
    
    bio(4)  <= LED_DCBA(0);     -- A
    bio(6)  <= LED_DCBA(1);     -- B
    bio(8)  <= LED_DCBA(2);     -- C
    bio(10) <= LED_DCBA(3);     -- D
    bio(12) <= LED_CLK;
    bio(11) <= LED_STB;
    bio(14) <= LED_OEn;
    bio(13) <= '0';
    
    -- Assign everything else to 0 just in case
    aio(5)  <= '0';
    aio(7)  <= '0';
    aio(9)  <= '0';
    bio(5)  <= '0';
    bio(7)  <= '0';
    bio(9)  <= '0';
    

-- ----------------------------
--  Clock generation (DCM)
-- ----------------------------
	CLKgen_inst : ENTITY WORK.CLKgen
    PORT MAP(
		CLKIN_IN        => clk16M,
		RST_IN          => rstbt,
		CLKIN_IBUFG_OUT => OPEN,
        CLK0_OUT        => OPEN,
--        CLK0_OUT        => sys_clk,
        CLKFX_OUT       => sys_clk,
--        CLKFX_OUT       => OPEN,
		LOCKED_OUT      => DCM_locked
	);    


-- ----------------------------
--  Memory instantiation
-- ----------------------------
    -- Top half of the screen, red pixels
    BRAM_top_R_inst : ENTITY WORK.BRAM_top_R
    PORT MAP (
        clk             => sys_clk,
        ROM_addr        => ROM_addr,
        ROM_dout        => ROM_top_R_dout
    );

    -- Top half of the screen, green pixels
    BRAM_top_G_inst : ENTITY WORK.BRAM_top_G
    PORT MAP (
        clk             => sys_clk,
        ROM_addr        => ROM_addr,
        ROM_dout        => ROM_top_G_dout
    );
    -- Top half of the screen, blue pixels
    BRAM_top_B_inst : ENTITY WORK.BRAM_top_B
    PORT MAP (
        clk             => sys_clk,
        ROM_addr        => ROM_addr,
        ROM_dout        => ROM_top_B_dout
    );
    
    -- Bottom half of the screen, red pixels
    BRAM_bot_R_inst : ENTITY WORK.BRAM_bot_R
    PORT MAP (
        clk             => sys_clk,
        ROM_addr        => ROM_addr,
        ROM_dout        => ROM_bot_R_dout
    );

    -- Bottom half of the screen, green pixels
    BRAM_bot_G_inst : ENTITY WORK.BRAM_bot_G
    PORT MAP (
        clk             => sys_clk,
        ROM_addr        => ROM_addr,
        ROM_dout        => ROM_bot_G_dout
    );

    -- Bottom half of the screen, blue pixels
    BRAM_bot_B_inst : ENTITY WORK.BRAM_bot_B
    PORT MAP (
        clk             => sys_clk,
        ROM_addr        => ROM_addr,
        ROM_dout        => ROM_bot_B_dout
    );
    
    
    -- Fadeout control memory
    BRAM_fadeout_inst : ENTITY WORK.BRAM_fadeout
    PORT MAP (
        clk             => sys_clk,
        ROM_addr        => ROM_fadeout_addr,
        ROM_dout        => ROM_fadeout_dout
    );


-- ----------------------------
--  Tie unused selectors to 0
-- ----------------------------
    seg_n <= (OTHERS => '1');
    dig_n <= (OTHERS => '1');
    col_n <= (OTHERS => '1');
    
    
END behavioral;

