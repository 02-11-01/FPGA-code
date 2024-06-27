library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Instruction_Management_Unit is
    Port (
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
		--PC_out      : out std_logic_vector(31 downto 0) 
    );
end Instruction_Management_Unit;

architecture Behavioral of Instruction_Management_Unit is
    type RAM64x32 is array (0 to 63) of std_logic_vector (31 downto 0);
       function init_mem return RAM64x32 is  
        variable result : RAM64x32; 
        begin 
        for i in 63 downto 0 loop 
        result (i):=(others=>'0'); 
        end loop;           -- PC        -- INSTRUCTION  -- COMMENTAIRE 
            result(0 ) := x"E3A01010"; -- _main : MOV R1,#0x10 ; --R1 <= 0x10
            result(1 ) := x"E3A02000"; -- MOV R2,#0 ;            --R2 <= 0 
            result(2 ) := x"E6110000"; -- _loop : LDR R0,0(R1) ; --R0 <= MEM[R1]
            result(3 ) := x"E0822000"; -- ADD R2,R2,R0 ;         --R2 <= R2 + R0
            result(4 ) := x"E2811001"; -- ADD R1,R1,#1 ;         --R1 <= R1 + 1
            result(5 ) := x"E351001A"; -- CMP R1,0x1A ;          --? R1 = 0x1A
            result(6 ) := x"BAFFFFFB"; -- BLT loop ;             --branch to _loop if R1 less than 0x1A
            result(7 ) := x"E6012000"; -- STR R2,0(R1) ;         --MEM[R1] <= R2
            result(8 ) := x"EAFFFFF7"; -- BAL main ;             --branch to _main 
            -- ISR 0 : interruption 0
            --save context
            result(9 ) := x"E60F1000"; -- STR R1,0(R15) ;        --MEM[R15] <= R1 
            result(10) := x"E28FF001"; -- ADD R15,R15,1 ;        --R15 <= R15 + 1
            result(11) := x"E60F3000"; -- STR R3,0(R15) ;        --MEM[R15] <= R3
            --processing
            result(12) := x"E3A03010"; -- MOV R3,0x10 ;          --R3 <= 0x10
            result(13) := x"E6131000"; -- LDR R1,0(R3) ;         --R1 <= MEM[R3]
            result(14) := x"E2811001"; -- ADD R1,R1,1 ;          --R1 <= R1 + 1
            result(15) := x"E6031000"; -- STR R1,0(R3) ;         --MEM[R3] <= R1
            -- restore context
            result(16) := x"E61F3000"; -- LDR R3,0(R15) ;        --R3 <= MEM[R15]
            result(17) := x"E28FF0FF"; -- ADD R15,R15,-1 ;       --R15 <= R15 - 1
            result(18) := x"E61F1000"; -- LDR R1,0(R15) ;        --R1 <= MEM[R15]
            result(19) := x"EB000000"; -- BX ;                   -- end of interruption instruction
            result(20) := x"00000000"; 
            -- ISR1 : interruption 1 
            --save context - R15 is the stack pointer
            result(21) := x"E60F4000"; -- STR R4,0(R15) ;        --MEM[R15] <= R4
            result(22) := x"E28FF001"; -- ADD R15,R15,1 ;        --R15 <= R15 + 1
            result(23) := x"E60F5000"; -- STR R5,0(R15) ;        --MEM[R15] <= R5
            --processing
            result(24) := x"E3A05010"; -- MOV R5,0x10 ;          --R5 <= 0x10
            result(25) := x"E6154000"; -- LDR R4,0(R5) ;         --R4 <= MEM[R5]
            result(26) := x"E2844002"; -- ADD R4,R4,2 ;          --R4 <= R4 + 2
            result(27) := x"E6054000"; -- STR R4,0(R5) ;         --MEM[R5] <= R4
            -- restore context
            result(28) := x"E61F5000"; -- LDR R5,0(R15) ;        --R5 <= MEM[R15]
            result(29) := x"E28FF0FF"; -- ADD R15,R15,-1 ;       --R15 <= R15 - 1
            result(30) := x"E61F4000"; -- LDR R4,0(R15) ;        --R4 <= MEM[R15]
            result(31) := x"EB000000"; -- BX ;                   -- end of interruption instruction
            result(32) := x"00000001";
            result(33) := x"00000002";
            result(34) := x"00000003";
            result(35) := x"00000004";
            result(36) := x"00000005";
            result(37) := x"00000006";
            result(38) := x"00000007";
            result(39) := x"00000008";
            result(40) := x"00000009";
            result(41) := x"0000000A";
            result(42 to 63) := (others=> x"00000000");
               
        return result; 
        end init_mem;  
        signal instruction_memory: RAM64x32 := init_mem; 
    signal PC,next_PC  : std_logic_vector(31 downto 0) := (others => '0');
    signal sign_ext_offset,temp_offset : std_logic_vector(31 downto 0);
    Signal LR : std_logic_vector(31 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            PC <= (others => '0');
            LR <= (others => '0');
            IRQ_SERV <= '0';
        elsif rising_edge(clk) then
            if (IRQ_END = '0') then
                if (IRQ = '1') then
                  LR <= PC;
                  PC <= VICPC;
                  next_PC<=VICPC;
                  IRQ_SERV <= '1';
                else
                    IRQ_SERV <= '0';
					next_PC<=next_PC;
                    if nPCsel = '0' then
                        next_PC <= PC + 1;
                        PC <= next_PC;
                    else
                        next_PC <= PC + 1 + sign_ext_offset;
                        PC <= next_PC;
                    end if;
                    
                  end if;
                end if;
            if (IRQ_END = '1') then 
                next_PC<= std_logic_vector(unsigned(LR) + 1);
                PC <= next_PC;
            end if;
        end if;
          end process;

    -- Sign extension unit
    process(offset)
        variable temp_offset : std_logic_vector(31 downto 0);
    begin
        --temp_offset := (others => offset(23));  -- 初始化高位部分为符号位
        for i in 0 to 23 loop
            temp_offset(i) := offset(i);  -- 复制 offset 的各位
        end loop;
		for j in 24 to 31 loop
            temp_offset(j) := offset(23);
		end loop;
        sign_ext_offset <= temp_offset;
    end process;

    -- PC update logic
    process(PC, nPCsel, sign_ext_offset)
    begin
        Rn <= instruction(19 downto 16);
        Rd <= instruction(15 downto 12);
        if instruction(25)='0' AND instruction(24 DOWNTO 21) = "0100" THEN
            Rn <= instruction(3 downto 0);
        end if;
        if instruction(25)='1' AND instruction(24 DOWNTO 21) = "0100" THEN 
            Rn <= instruction(3 downto 0);
        end if;
        if instruction(25)='1' AND instruction(27 downto 26)="01" then
            Rm <= instruction(3 downto 0);
        else
            Rm <= "0000";
        end if;
        
    end process;

   
    instruction <= instruction_memory(conv_integer(PC));  -- Using PC(7 downto 2) to access the 64-word memory
    imm8 <= instruction(7 downto 0);
   

    
    --PC_out <= PC;

end Behavioral;
