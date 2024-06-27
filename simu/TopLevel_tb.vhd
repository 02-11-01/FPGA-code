
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Top_Level_tb IS
END ENTITY;

ARCHITECTURE behavior OF Top_Level_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
    component Top_Level
        port(
            CLOCK_50 	:  IN  STD_LOGIC;
            KEY	:  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
            SW 	:  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
            SEG_A_OUT :  OUT  STD_LOGIC_VECTOR(0 TO 6);
            SEG_B_OUT :  OUT  STD_LOGIC_VECTOR(0 TO 6);
            SEG_C_OUT :  OUT  STD_LOGIC_VECTOR(0 TO 6);
            SEG_D_OUT :  OUT  STD_LOGIC_VECTOR(0 TO 6)
        );
    end component;



    -- Clock period definitions
    constant CLK_period : time := 10 ns;
    signal CLK : std_logic := '0';
    signal RST :std_logic := '0';
    signal Done : boolean := False;
    signal KEY1 : STD_LOGIC_VECTOR(1 downto 0) := (others => '1');
    signal SW1: STD_LOGIC_VECTOR(9 downto 0):= (others => '0');
    signal SEG_A_OUT,SEG_B_OUT,SEG_C_OUT,SEG_D_OUT : STD_LOGIC_VECTOR( 0 TO 6);
    --constant CLK_period : time := 10 ns;
BEGIN

    -- Instantiate the Unit Under Test (UUT)

    uut: Top_Level port map (
        CLOCK_50 => CLK,
        KEY => KEY1,
        SW => SW1,
        SEG_A_OUT => SEG_A_OUT,
        SEG_B_OUT => SEG_B_OUT,
        SEG_C_OUT => SEG_C_OUT,
        SEG_D_OUT => SEG_D_OUT
    );
    -- Clock process definitions
    clk <= '0' when Done else not clk after CLK_period;

    -- Stimulus process
    stim_proc: process
    begin       
        -- hold reset state for 100 ns.
        wait for CLK_period * 2; 
        KEY1 <= (others => '0');
        wait for CLK_period * 2;
        KEY1 <= (others => '1');
        SW1<= (others => '0');
        wait for CLK_period * 2;
        wait for CLK_period * 2;

        wait for 1300 ns;

        SW1(8)<= '1';
        wait for 1000 ns;
        Done <= True;
        --Done <= True;
        wait;



        -- insert stimulus here 

        
    end process;

end architecture behavior;
