library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.NUMERIC_STD.all;

entity ALU is
    port (
        OP : in std_logic_vector(1 downto 0);   
        A, B : in std_logic_vector(31 downto 0);
        CPSR : out std_logic_vector(3 downto 0):=(others=>'0'); -- output flags
        S : out std_logic_vector(31 downto 0) -- output
    );
end entity;

architecture Behavioral of ALU is 
    signal MediateResult : std_logic_vector(31 downto 0):=(others=>'0');
    signal comp : std_logic_vector(31 downto 0):=(others=>'0');
begin 
    process (OP, A, B) 
    begin 
        case OP is
            when "00" =>  -- ADD
                S <= std_logic_vector(unsigned(A) + unsigned(B));
                CPSR(1) <= '0'; 
                CPSR(0) <= '0';

            when "01" =>  -- B
                S <= B;

            when "10" =>  -- SUB
                S <= std_logic_vector(unsigned(A) - unsigned(B));
                CPSR(1) <= '0'; 
                CPSR(0) <= '0';

            when "11" =>  -- A
                S <= A;
            when others =>
        end case;

        
        -- Set the Z flag
        if S="00000000000000000000000000000000" then
            CPSR(2) <= '1';
        else
            CPSR(2) <='0';
        end if;
    end process; 
    CPSR(3) <= S(31);
end architecture;
