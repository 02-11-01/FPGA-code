library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FDIV is
    generic (
        BaudRate : integer := 115200;
        ClockDefaut : integer := 50000000
    );
    port (
        Clk       : in std_logic;
        Reset     : in std_logic;
        Tick      : out std_logic;
        Tick_half : out std_logic
    );
end FDIV;

architecture Behavioral of FDIV is
    signal FDIV_Value : integer;
begin
    FDIV_Value <= ClockDefaut / BaudRate - 1;

    process (Clk, Reset)
        variable CNT : integer := 0;
    begin
        if Reset = '1' then
            CNT := 0;
            Tick <= '0';
            Tick_half <= '0';
        elsif rising_edge(Clk) then
                CNT := CNT + 1;
            if CNT >= FDIV_Value then
                Tick <= '1';
                Tick_half <= '1';
                CNT := 0;
            elsif CNT = FDIV_Value/2 then
                Tick_half <= '1';
            else
                Tick <= '0';
                Tick_half <= '0';
            end if;
        end if;
    end process;
end architecture;