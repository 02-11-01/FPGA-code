LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY TopLevel_tb IS
END ENTITY;

ARCHITECTURE behavior OF TopLevel_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT TopLevel
    PORT(
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
    END COMPONENT;
   
    --Inputs
    signal CLK : std_logic := '0';
    signal RST,WEE,MUX1_COM,MUX2_COM,Mem_WrEn : std_logic := '0';
    signal OP1 : std_logic_vector(1 downto 0) := (others => '0');
    signal Done : boolean := False;
    signal Rea1,Reb1,RW : STD_LOGIC_VECTOR(3 downto 0):= (others => '0');

    --Outputs
    signal address : std_logic_vector(5 downto 0):= (others => '0');

    signal Imme_Num,MUX1_Out,MUX2_Out,ALU_out1: std_logic_vector(31 downto 0):= (others => '0');
    signal A_O,DataOutput : std_logic_vector(31 downto 0) := (others => '0');
    signal B_O,test1 : std_logic_vector(31 downto 0) := (others => '1');

    -- Clock period definitions
    constant CLK_period : time := 10 ns;
 
BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: TopLevel PORT MAP (
        CLK => CLK,
        RST => RST,
        OP1 => OP1,
        CPSR => OPEN,
        Rea=>Rea1,
        Reb=>Reb1,
        WE=>WEE,
        ReW=>RW,
        --W=>busW,
        --OutPut_Data=>busW,
        COM1 => MUX1_COM,
        COM2 => MUX2_COM,
        Mem_WrEn => Mem_WrEn,
        Imme_Num => Imme_Num,
        MUX1_Out1 => MUX1_Out,
        A=>A_O,
        ALU_out => ALU_out1,
        --test => test1,
        B=>B_O,
        OutPut_Data => DataOutput,
        addre => address,
        MUX2_Out1 => MUX2_Out
        ---OutPut_Data => busW
    );

    -- Clock process definitions
    clk <= '0' when Done else not clk after CLK_period;

    -- Stimulus process
    stim_proc: process
    begin       

        wait for CLK_period * 2;  
        RST <= '1';
        wait for CLK_period * 2;
        RST <= '0';
        Rea1 <= "0001";
        Reb1 <= "1111";
        wait for CLK_period * 2;
        --test1 <="11001100110011001100110011001100";

        ---A<="00000000000000000000000000000001";
        ---B<="00000000000000000000000000000001";
        MUX1_COM <= '0';            --分配
        MUX2_COM <= '0';
        WEE <='0';
        Mem_WrEn <= '1';
        OP1 <= "00";
        wait for CLK_period * 2;
        MUX1_COM <= '1';         
        MUX2_COM <= '0';
        WEE <='0';
        Mem_WrEn <= '1';
        OP1 <= "00";
        --RW<="0001";
        --busW<="00000000000000000000000000000001";
        wait for CLK_period * 2;
        MUX1_COM <= '1';
        MUX2_COM <= '1';
        Imme_Num <="00000000000000000000000000000011";
        WEE <='0';
        Mem_WrEn <= '1';
        OP1 <= "01";
        wait for CLK_period * 2;            --sub
        Rea1 <="0001";
        Reb1 <="1111";
        RW <= "0001";
        WEE <= '1';
        wait for CLK_period * 2;
        MUX1_COM <= '1';
        MUX2_COM <= '1';
        Imme_Num <="00000000000000000000000000000011";
        WEE <='0';
        Mem_WrEn <= '1';
        OP1 <= "01";
        wait for CLK_period * 2;
        WEE <='1';
        RW <= "0001";
        Mem_WrEn <= '0';
        wait for CLK_period * 2;                    --R(15)-R(2)=x30
        WEE <= '0';
        Mem_WrEn <= '0';
        Rea1 <= "1111";
        Reb1 <= "0010";
        MUX1_COM <= '0';
        MUX2_COM <= '0';
        OP1 <= "10";
        wait for CLK_period * 2;
        Imme_Num <="00000000000000000000000000000100";
        WEE <= '0';
        Mem_WrEn <= '0';
        Rea1 <= "1111";
        Reb1 <= "0010";
        MUX1_COM <= '1';
        MUX2_COM <= '0';
        OP1 <= "10";
        wait for CLK_period * 2;                --R(15)=> R(3), r(3)=x30 
        WEE <= '1';
        Mem_WrEn <= '0';
        Rea1 <= "1111";
        Reb1 <= "0010";
        RW <= "0011";
        MUX1_COM <= '0';
        MUX2_COM <= '0';
        OP1 <= "11";
        wait for CLK_period * 2;
        MUX2_COM <='1';
        Done <= True;
        wait;



        
    end process;

END;
