library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TopLevel is
    port (
        CLK : in STD_LOGIC;
        RST, WE : in STD_LOGIC;
        OP1 : in STD_LOGIC_VECTOR(1 downto 0):=(others=>'0');
        Rea, Reb, ReW : in STD_LOGIC_VECTOR(3 downto 0):=(others=>'0');
        CPSR : out std_logic_vector(3 downto 0):=(others=>'0'); 
        OutPut_Data, A, B : out STD_LOGIC_VECTOR(31 downto 0)
    );
end entity TopLevel;

architecture Behavioral of TopLevel is
    signal busW : STD_LOGIC_VECTOR(31 downto 0);

    signal Bus_A, Bus_B : STD_LOGIC_VECTOR(31 downto 0);

    component ALU is
        port (
            OP : in std_logic_vector(1 downto 0);   
            A, B : in std_logic_vector(31 downto 0);
            CPSR : out std_logic_vector(3 downto 0):=(others=>'0'); 
            S : out std_logic_vector(31 downto 0) 
        );
    end component;

    component REG is
        port (
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            RA, RB, RW : in STD_LOGIC_VECTOR(3 downto 0);
            W : in STD_LOGIC_VECTOR(31 downto 0);
            WE : in STD_LOGIC; 
            A, B : out STD_LOGIC_VECTOR(31 downto 0) 
        );
    end component;
begin
    A_inst: REG port map (
        CLK => CLK,
        RST => RST,
        RA => Rea, 
        RB => Reb, 
        RW => ReW, 
        W => busW,
        WE => WE, 
        A => Bus_A,
        B => Bus_B
    );

    B_inst: ALU port map (
        OP => OP1,
        A => Bus_A,
        B => Bus_B,
        CPSR => CPSR,
        S => busW
    );

    process (CLK, RST)
    begin
        if RST = '1' then
            OutPut_Data <= (others => '0');
            A <= (others => '0');
            B <= (others => '0');
        elsif rising_edge(CLK) then
            A <= Bus_A;
            B <= Bus_B;
            OutPut_Data <= busW;
        end if;
    end process;
end architecture Behavioral;
