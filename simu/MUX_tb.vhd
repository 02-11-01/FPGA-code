library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_tb is
end entity MUX_tb;

architecture testbench of MUX_tb is
    signal A, B, S : STD_LOGIC_VECTOR(31 downto 0);  -- Example: 8-bit input/output
    signal COM : STD_LOGIC := '0';  -- Example: Select input
begin
    -- Instantiate the 2-to-1 MUX
    uut: entity work.MUX
        --generic map (N => 32)  -- Set N to match the input/output size
        port map (A => A, B => B, COM => COM, S => S);

    -- Stimulus process
    stimulus: process
    begin
        A <= "11001100110011001100110011001100";  -- Example input data
        B <= "00110011110011001100110011001100";  -- Example input data
        COM <= '1';  -- Example: Select input B
        wait for 10 ns;
        COM <= '0';  -- Example: Select input A
        wait for 10 ns;
        -- Add more test cases as needed
        wait;
    end process stimulus;
end architecture testbench;
