library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_RX is
    port (
        Clk          : in std_logic;
        Reset        : in std_logic;
        Rx           : in std_logic;
        Tick_halfbit : in std_logic;
        FDIV_RST   : out std_logic;
        Error          : out std_logic;
        Data         : out std_logic_vector(7 downto 0);
        RxIrq        : out std_logic
    );
end UART_RX;

architecture Behavioral of UART_RX is
    signal reg : std_logic_vector(7 downto 0);
    signal count_bit : integer range 0 to 15;

	type StateType is (E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, Er);
	signal State : StateType;
begin

process (Clk, Reset)
begin
    if Reset = '1' then
        State <= E1;
        RxIrq <= '0';
        count_bit <= 0;
        reg <= (others => '0');
        FDIV_RST <= '0';
        Error <= '0';
    elsif rising_edge(Clk) then
        case State is
            when E1 =>
                if Rx = '0' then
                    State <= E2;
                    FDIV_RST <= '1';
                    RxIrq <= '0';
                    Error <= '0';
                end if;
            when E2 =>
                State <= E3;
                FDIV_RST <= '0';
            when E3 =>
                if Tick_halfbit = '1' then
                    State <= E4;
                end if;
            when E4 =>
                if Rx = '0' then
                    State <= E5;
                elsif Rx = '1' then
                    State <= Er;
                    Error <= '1';
                end if;
            when E5 =>
                if Tick_halfbit = '1' then
                    State <= E6;
                end if;
            when E6 =>
                if Tick_halfbit = '1' then
                    State <= E7;
                    reg(count_bit) <= Rx;
                    count_bit <= count_bit + 1;
                end if;
            when E7 =>
                if count_bit = 8 then
                    State <= E8;
                elsif Tick_halfbit = '1' then
                    State <= E6;
                end if;
            when E8 =>
                if Tick_halfbit = '1' then
                    State <= E9;
                end if;
            when E9 =>
                if Tick_halfbit = '1' then
                    State <= E10;
                end if;
            when E10 =>
                if Rx = '0' then
                    State <= Er;
                    Error <= '1';
                else
                    State <= E11;
                    Data <= reg;
                    RxIrq <= '1';
                end if;
            when E11 =>
                State <= E1;
                count_bit <= 0;
            when Er =>
                State <= E1;
                count_bit <= 0;
        end case;
    end if;
end process;

end architecture;