-- Instruction decoder module
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY Instruction_Decoder IS
    PORT (
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
END ENTITY;

ARCHITECTURE behavior OF Instruction_Decoder IS
    type Instruction_memory is array(15 downto 0) of std_logic_vector(31 downto 0); 
    TYPE enum_instruction IS (MOV,CMP,ADDi,ADDr,LDR,STR, BAL, BLT,BX);
    SIGNAL instr_current : enum_instruction;
	
    BEGIN
        PROCESS (instruction,PSR)
    BEGIN
        CASE instruction(27 DOWNTO 26) IS
            WHEN "00" =>
                IF  instruction(24 DOWNTO 21) = "1101" THEN     --MOV操作 把A值给B
                        instr_current <= MOV;
                        IRQ_END <= '0';
                        --Rm <= instruction(3 DOWNTO 0);
                        nPCSel <= '0';      --只需要在跳转时使能
                        RegWr <= '1';
                        ALUSrc <= '1';
                        ALUCtr <= "01";  -- 输出信号为B，即MOV A,B
                        PSREn <= '0';
                        MemWr <= '0';
                        WrSrc <= '0';
                        RegSel <= '1';
                        RegAff <= '0';
				END IF;	
                IF  instruction(25)='0' AND instruction(24 DOWNTO 21) = "0100" THEN     --ADDR操作 对两个寄存器值相加
                    instr_current <= ADDr;
                    --Rm <= instruction(3 DOWNTO 0);
                    IRQ_END <= '0';
                    nPCSel <= '0';
                    RegWr <= '1';
                    ALUSrc <= '0';
                    ALUCtr <= "00";
                    PSREn <= '1';
                    MemWr <= '0';
                    WrSrc <= '0';
                    RegSel <= '1';
                    RegAff <= '0';
				END IF;	
                IF  instruction(25)='1' AND instruction(24 DOWNTO 21) = "0100" THEN     --ADDi操作 对两个寄存器值相加,25位只对需要立即数操作的运算有效 其他不需要立即数参与运算的不需要考虑
                    instr_current <= ADDi;
                    --Rm <= instruction(3 DOWNTO 0);
                    IRQ_END <= '0';
                    nPCSel <= '0';
                    RegWr <= '1';
                    ALUSrc <= '1';     -- 使用立即数
                    ALUCtr <= "00";     --A+B 
                    PSREn <= '0';
                    MemWr <= '0';
                    WrSrc <= '0';
                    RegSel <= '0';
                    RegAff <= '0';
				END IF;	
                IF  instruction(24 DOWNTO 21) = "1010" THEN     --CMP操作 比较寄存器值的大小 通过减法 A-B时：N=1,Z!=0 => A<B,N=0,Z!=0 A>B Z=0 A=B
                    instr_current <= CMP;
                    --Rm <= instruction(3 DOWNTO 0);
                    IRQ_END <= '0';
                    nPCSel <= '0';
                    RegWr <= '0';
                    ALUSrc <= '1';     -- 使用立即数
                    ALUCtr <= "10";     --A-B 
                    PSREn <= '1';
                    MemWr <= '0';
                    WrSrc <= '0';
                    RegSel <= '1';
                    RegAff <= '0';
				END IF;	
             WHEN "01" =>
                -- LDR和STR指令
                if instruction(27 downto 26) = "01" and instruction(20) = '1' then        --将寄存器RA的
                    instr_current <= LDR;
                       /* nPCSel <= '0';
                        RegWr <= '1';      -- 写入寄存器
                        ALUSrc <= '0';     -- 使用寄存器值作为ALU输入
                        ALUCtr <= "001";  -- LDR指令的控制信号
                        PSREn <= '0';
                        MemWr <= '0';      -- 不写入内存
                        WrSrc <= '1';      -- 从内存读取数据
                        RegSel <= '1';
                        RegAff <= '0';
                        */
                        IRQ_END <= '0';
                        nPCSel <= '0';
                        RegWr <= '1';
                        ALUSrc <= '1';
                        ALUCtr <= "01";
                        PSREn <= '0';
                        MemWr <= '0';
                        WrSrc <= '1';
                        RegAff <= '0';

                end if;
                if instruction(27 downto 26) = "01" and instruction(20) = '0' then  
                    instr_current <= STR;
                    IRQ_END <= '0';
                    nPCSel <= '0';
                    RegWr <= '0';
                    ALUSrc <= '1';
                    ALUCtr <= "11";
                    PSREn <= '0';
                    WrSrc <= '0';
                    MemWr <= '1';
                    RegSel <= '1';
                    RegAff <= '1';
                
                END IF;
            WHEN "10"  =>
                if (Instruction(31 downto 28) = "1110") then
                    if (Instruction(25 downto 24) = "11") then
                        instr_current <= BX;
                        IRQ_END <= '1';
                        nPCSel <= '0';
                        PSREn <= '0';
                        RegWr <= '0';
                        RegSel <= '0';
                        ALUctr <= "00";
                        ALUSrc <= '0';
                        WrSrc <= '0';
                        MemWr <= '0';
                        RegAff <= '0';
                    else
                        instr_current <= BAL;
                        IF instruction(24) = '0' THEN
                        IRQ_END <= '0';
                            nPCSel <= '1'; -- 跳转
                            RegWr <= '0'; -- 不写入r14
                            --ALUSrc <= '1'; -- 使用立即数
                            --ALUCtr <= "000"; -- 控制信号假设值
                            PSREn <= '0';
                            MemWr <= '0';
                            --WrSrc <= '0';
                            --RegSel <= '0';
                            RegAff <= '0';
                        ELSE
                            -- 如果L位不为0，说明指令有误，设置为不跳转
                            nPCSel <= '0'; -- 不跳转
                            IRQ_END <= '0';
                            RegWr <= '0'; -- 不写入寄存器
                            --ALUSrc <= '0';
                            --ALUCtr <= "000";
                            PSREn <= '0';
                            MemWr <= '0';
                            --WrSrc <= '0';
                            --RegSel <= '0';
                            RegAff <= '0';
                        END IF;
                    end if;
                end if;
            WHEN OTHERS =>
            
        END CASE;
        if instruction(27 DOWNTO 25)="101" then
        CASE instruction(31 DOWNTO 28) IS
        WHEN "1011" =>
            -- BLT指令
            instr_current <= BLT;
            IF PSR(3) = '1' AND PSR(2) = '0' THEN
                -- 条件满足（N=1 且 V=0）
                IF instruction(24) = '0' THEN
                    nPCSel <= PSR(3); -- 跳转
                    IRQ_END <= '0';
                    RegWr <= '0'; -- 不写入r14
                    --ALUSrc <= '1'; -- 使用立即数
                    --ALUCtr <= "000"; -- 控制信号假设值
                    PSREn <= '0';
                    MemWr <= '0';
                    --WrSrc <= '0';
                    RegSel <= '0';
                    RegAff <= '0';
            ELSE
                -- 条件不满足，不跳转
                nPCSel <= PSR(3); -- 不跳转
                RegWr <= '0'; -- 不写入寄存器
                IRQ_END <= '0';
                --ALUSrc <= '0';
                --ALUCtr <= "000";
                PSREn <= '0';
                MemWr <= '0';
                --WrSrc <= '0';
                --RegSel <= '0';
                RegAff <= '0';
                END IF;
			END IF;	
            WHEN OTHERS =>
    END CASE;
    END if;
    END PROCESS;
END ARCHITECTURE;
