library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TopLevel_TP4 is
    port (
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        IRQ0    : in STD_LOGIC;
        IRQ1    : in STD_LOGIC;
        OutPut_Data : out STD_LOGIC_VECTOR(15 downto 0)
    );
end entity TopLevel_TP4;

architecture Behavioral of TopLevel_TP4 is
    signal busW : STD_LOGIC_VECTOR(31 downto 0);

    -----------
    
    signal WEE: STD_LOGIC;
    signal ALU_output : STD_LOGIC_VECTOR(31 downto 0);                       ---ALU
    signal CPSR1 : STD_LOGIC_VECTOR(3 downto 0);
    signal OPIN : STD_LOGIC_VECTOR(1 downto 0);

    -----------
    signal Rn,Rd,Rm : STD_LOGIC_VECTOR(3 downto 0);                         ---reg
    signal Bus_A, Bus_B : STD_LOGIC_VECTOR(31 downto 0);
    signal ReW: STD_LOGIC_VECTOR(3 downto 0);
    signal Imme_Num: STD_LOGIC_VECTOR(31 downto 0);
    signal Imme8: STD_LOGIC_VECTOR(7 downto 0);
    -----------
     
    signal MUX1_InA,MUX1_InB,MUX2_InA,MUX2_InB:std_logic_vector(31 downto 0);
    signal MUX1_COM,MUX2_COM:std_logic:='0';
    signal MUX1_Out,MUX2_Out:std_logic_vector(31 downto 0);
    signal MUX3_Out:std_logic_vector(3 downto 0);
    signal WE,ALUSrc,COM2 : STD_LOGIC;
    ---mux1&2
    
    -----------
    signal Mem_WrEn: std_logic;
    signal Mem_Addr : std_logic_vector(5 downto 0); 
    signal Mem_DataInput : std_logic_vector(31 downto 0);
    signal Mem_DataOutput: std_logic_vector(31 downto 0); 
                                                                            ---Data_Memory
    -----------
    signal offset : std_logic_vector(23 downto 0);
    SIGNAL nPCSel,RegAff,PSREn : std_logic;
    signal instruction:std_logic_vector(31 downto 0);
    -----------
    signal RegSel: std_logic;
    ---------------------------
    Signal IRQ         : std_logic;
    Signal VICPC       : std_logic_vector(31 downto 0);
    Signal IRQ_END     : std_logic;
    Signal IRQ_SERV    : std_logic;

    component Instruction_Decoder is
        port (
            
            instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            PSR : IN STD_LOGIC_VECTOR(3 DOWNTO  0);
            nPCSel : OUT STD_LOGIC;
            RegWr : OUT STD_LOGIC;
            --ALUSrc : OUT STD_LOGIC;
            ALUCtr : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            PSREn : OUT STD_LOGIC;
            ALUSrc : OUT STD_LOGIC;
            MemWr : OUT STD_LOGIC;
            WrSrc : OUT STD_LOGIC;
            RegSel : OUT STD_LOGIC;
            RegAff : OUT STD_LOGIC;
            IRQ         : in std_logic;
            IRQ_END     : out std_logic
        );
    end component;
    component ImmediateExtender is 
        port ( immediat_in  : in  std_logic_vector(7 downto 0);  -- 8-bit input
               immediat_out : out std_logic_vector(31 downto 0)  -- 32-bit output 
            );
    end component;
    component VECTORED_INTERRUPT_CONTROLLER is 
        port (
            Clk      : in std_logic;
            Reset    : in std_logic;
            IRQ_SERV : in std_logic;
            IRQ0     : in std_logic;
            IRQ1     : in std_logic;
            IRQ      : out std_logic;
            VICPC    : out std_logic_vector(31 downto 0)
          );
    end component;
    component Instruction_Management_Unit is
        port (
            
            clk         : in  std_logic;
            reset       : in  std_logic;
            nPCsel      : in  std_logic;
            IRQ         : in std_logic;
            VICPC       : in std_logic_vector(31 downto 0);
            IRQ_END     : in std_logic;
            offset      : in  std_logic_vector(23 downto 0);
            instruction : out std_logic_vector(31 downto 0);
            Rd,Rn,Rm : out std_logic_vector(3 downto 0);
            IRQ_SERV    : out std_logic;
            imm8 : out std_logic_vector(7 downto 0)
            );
    end component;
    component ALU is
        port (
            
            OP : in std_logic_vector(1 downto 0);   
            A,B : in std_logic_vector(31 downto 0);
            CPSR : out std_logic_vector(3 downto 0); -- output flags
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
component MUX3 is 
    port ( A,B : in std_logic_vector(3 downto 0);
        COM : in std_logic; -- Chip Select
        S : out std_logic_vector(3 downto 0) 
        );
end component;
    component Data_Memory is
        port (
            CLK: in std_logic; -- Clock
            RST: in std_logic; -- Async Reset
            DataIn: in std_logic_vector(31 downto 0); -- Data In
            DataOut: out std_logic_vector(31 downto 0); -- Data Out
            Addr: in std_logic_vector(5 downto 0); -- Address
            WrEn: in std_logic -- Write Enable
            );
        end component;
    begin
        VIC_inst: VECTORED_INTERRUPT_CONTROLLER port map (
            Clk      => Clk,
            Reset    => RST,
            IRQ_SERV => IRQ_SERV,
            IRQ0     => IRQ0,
            IRQ1     => IRQ1,
            IRQ      => IRQ,
            VICPC    => VICPC
          );
    I1D_inst: Instruction_Decoder port map(
        instruction => instruction,
        nPCsel => nPCsel, 
        PSR => CPSR1,
        RegWr => WEE,
        ALUCtr => OPIN,
        PSREn => PSREn,
        ALUSrc => MUX1_COM,
        MemWr => Mem_WrEn,
        WrSrc => MUX2_COM,
        RegSel => RegSel,
        IRQ => IRQ,
        IRQ_END => IRQ_END,
        RegAff => RegAff

    );    
    IMU_inst: Instruction_Management_Unit port map(
        CLK => CLK,
        reset => RST,
        nPCsel => nPCsel, 
        offset => instruction(23 downto 0), 
        instruction => instruction,
        Rd => Rd,
        Rm => Rm,
        Rn => Rn,
        IRQ => IRQ,
        VICPC => VICPC,
        IRQ_END => IRQ_END,
        IRQ_SERV => IRQ_SERV,
        imm8 => imme8

    );
    ImmediateExtender_inst : ImmediateExtender port map (
        immediat_in  => imme8,
        immediat_out => Imme_Num
        );

    reg_inst: REG port map (
        CLK => CLK,
        RST => RST,
        RA => Rn, 
        RB => MUX3_Out, 
        RW => Rd, 
        W => busW,
        WE => WEE, 
        A => Bus_A,
        B => Bus_B

    );
    ALU_inst: ALU port map (
        OP=>OPIN,
        A =>Bus_A,
        B => MUX1_Out,
        CPSR => CPSR1,
        S => ALU_output
    );
    MUX1_inst: MUX port map (
        COM => MUX1_COM,
        A => Bus_B,
        B => Imme_Num,   ---没写位数选择
        S => MUX1_Out
        
    );
    Data_Memory_inst0: Data_Memory port map(
        
        CLK => CLK,
        RST => RST,
        addr => ALU_output(5 downto 0),
        WrEn => Mem_WrEn,
        DataIn => Bus_B,
        DataOut => MUX2_InB

    );

    MUX2_inst: MUX port map (
        A => ALU_output,
        B => MUX2_InB,   
        S => busW,
        COM => MUX2_COM
    );
    MUX3_inst: MUX3 port map (
        A => Rm,
        B => Rd,   
        S => MUX3_Out,
        COM => RegSel
    );
    process (CLK, RST)
    begin
    if RST = '1' then
        OutPut_Data <= (others => '0');
    elsif rising_edge(CLK) then
        if RegAff='1' then
            OutPut_Data <= Bus_B(15 downto 0);
        end if;
    --MUX2_Out1 <= busW;
    end if;
    end process;


end architecture Behavioral;
