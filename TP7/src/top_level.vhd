LIBRARY ieee;
USE ieee.std_logic_1164.all; 
use IEEE.numeric_std.ALL;


ENTITY top_level is
	PORT
	(
		CLOCK_50 	:  IN  STD_LOGIC;
		KEY	:  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
        SW 	:  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		SEG_A_OUT :  OUT  STD_LOGIC_VECTOR(0 TO 6);
		SEG_B_OUT :  OUT  STD_LOGIC_VECTOR(0 TO 6);
		SEG_C_OUT :  OUT  STD_LOGIC_VECTOR(0 TO 6);
		SEG_D_OUT :  OUT  STD_LOGIC_VECTOR(0 TO 6)
	);
END entity;

ARCHITECTURE bhv OF top_level IS 

	signal 	RST,CLK, pol,IRQ0,IRQ1  : std_logic;
    signal OutPut_Data : STD_LOGIC_VECTOR(15 DOWNTO 0);

    component SEVEN_SEG is
        port (
            Data   : in  std_logic_vector(3 downto 0); -- Expected within 0 .. 9
            Pol    : in  std_logic;                    -- '0' if active LOW
            Segout : out std_logic_vector(1 to 7) 
            );   -- Segments A, B, C, D, E, F, G
    end component;
    component TopLevel_TP4 is
        port (
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            IRQ0    : in STD_LOGIC;
            IRQ1    : in STD_LOGIC;
            OutPut_Data : out STD_LOGIC_VECTOR(15 downto 0)
        ); -- Segments A, B, C, D, E, F, G
    end component;
BEGIN 

RST <= not KEY(0);
CLK <= CLOCK_50; 
pol <= SW(9);
IRQ0 <=SW(8);
IRQ1 <=SW(7);

tp4: TopLevel_TP4 port map (
    CLK=>CLOCK_50,
    OutPut_Data=>OutPut_Data,
    RST=>RST,
	 IRQ0 =>IRQ0,
	 IRQ1 => IRQ1
);

SEG1: SEVEN_SEG port map (
    Pol=>pol,
    Data=>OutPut_Data(3 downto 0),
    Segout=>SEG_A_OUT
);
SEG2: SEVEN_SEG port map (
    Pol=>pol,
    Data=>OutPut_Data(7 downto 4),
    Segout=>SEG_B_OUT
);
SEG3: SEVEN_SEG port map (
    Pol=>pol,
    Data=>OutPut_Data(11 downto 8),
    Segout=>SEG_C_OUT
);
SEG4: SEVEN_SEG port map (
    Pol=>pol,
    Data=>OutPut_Data(15 downto 12),
    Segout=>SEG_D_OUT
);

end architecture;