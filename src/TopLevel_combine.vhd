library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TopLevel is
    port (
        CLK : in STD_LOGIC;
        RST,WE,COM1,COM2 : in STD_LOGIC;
        OP1 : in STD_LOGIC_VECTOR(1 downto 0);
        Rea,Reb,ReW : in STD_LOGIC_VECTOR(3 downto 0);
        Imme_Num: in STD_LOGIC_VECTOR(31 downto 0);
        Mem_WrEn :in STD_LOGIC;
        --ROA,ROB : out STD_LOGIC_VECTOR(3 downto 0);
        --W : in STD_LOGIC_VECTOR(31 downto 0);
        CPSR : out std_logic_vector(3 downto 0);
        addre : out std_logic_vector(5 downto 0);                      ---没写extender
        OutPut_Data,A,B,MUX1_Out1,MUX2_Out1,ALU_out : out STD_LOGIC_VECTOR(31 downto 0)
        
    );
end entity TopLevel;

architecture Behavioral of TopLevel is
    signal busW : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');

    -----------
    
    signal  CPSR1 :STD_LOGIC_VECTOR(3 downto 0):= (others => '0');
    signal ALU_output : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');                       ---ALU
   
    -----------
    
    signal Bus_A, Bus_B : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
    
    -----------
     
    signal MUX1_InA,MUX1_InB,MUX2_InA,MUX2_InB:std_logic_vector(31 downto 0):= (others => '0');
    signal MUX1_COM,MUX2_COM:std_logic:='0';
    signal MUX1_Out,MUX2_Out:std_logic_vector(31 downto 0):= (others => '0');
    ---mux1&2
    
    -----------
    
    signal Mem_Addr : std_logic_vector(5 downto 0):= (others => '0'); 
    signal Mem_DataInput : std_logic_vector(31 downto 0):= (others => '0');
    signal Mem_DataOutput: std_logic_vector(31 downto 0):= (others => '0'); 
                                                                            ---Data_Memory
    -----------



    component ALU is
        port (
            
            OP : in std_logic_vector(1 downto 0);   
            A,B : in std_logic_vector(31 downto 0);
            CPSR : out std_logic_vector(3 downto 0);
            S:out std_logic_vector(31 downto 0) -- output
        );
    end component;

    component REG is
        port (
            CLK: in std_logic;
            RST: in std_logic;
            RA,RB,RW : in std_logic_vector(3 downto 0);
            W: in std_logic_vector(31 downto 0);
            WE : in std_logic; -- input flags
            A,B: out std_logic_vector(31 downto 0) -- output
        
        );
    end component;
    component MUX is 
        port ( A,B : in std_logic_vector(31 downto 0);
            COM : in std_logic; -- Chip Select
            S : out std_logic_vector(31 downto 0) 
            );
end component;
    component Data_Memory is
        port (
            CLK: in std_logic;
            RST: in std_logic;
            Addr : in std_logic_vector(5 downto 0);--address
            DataInput: in std_logic_vector(31 downto 0);
            WrEn : in std_logic; -- write flag
            DataOutput: out std_logic_vector(31 downto 0) -- output
            );
        end component;
    begin
    reg_inst: REG port map (
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
    ALU_inst: ALU port map (
            OP=>OP1,
            A =>Bus_A,
            B => MUX1_Out,
            CPSR => open,
            S => ALU_output
            --S(5 downto 0) => Mem_Addr
    );
    MUX1_inst: MUX port map (
        COM => COM1,
        A => Bus_B,
        B => Imme_Num,   ---没写位数选择
        S => MUX1_Out
        
    );
    Data_Memory_inst: Data_Memory port map(
        WrEn => Mem_WrEn,
        DataInput => Bus_B,
        CLK => CLK,
        RST => RST,
        addr => ALU_output(5 downto 0),
        DataOutput => MUX2_InB

    );
    MUX2_inst: MUX port map (
        A => ALU_output,
        B => MUX2_InB,   
        S => busW,
        COM => COM2
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
    addre <= ALU_output(5 downto 0);
    --MUX2_Out1 <= busW;
    MUX1_Out1 <= MUX1_Out;
    ALU_out <= ALU_output;
    MUX2_Out1 <= MUX2_InB; 
    end if;
    end process;


end architecture Behavioral;
