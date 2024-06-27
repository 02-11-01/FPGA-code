library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity data_memory is
    port(
        CLK: in std_logic; -- Clock
        RST: in std_logic; -- Async Reset
        DataIn: in std_logic_vector(31 downto 0); -- Data In
        DataOut: out std_logic_vector(31 downto 0); -- Data Out
        Addr: in std_logic_vector(5 downto 0); -- Address
        WrEn: in std_logic -- Write Enable
    );
end entity;

architecture RTL of data_memory is
    type table is array(63 downto 0) of std_logic_vector(31 downto 0);
    signal Banc: table;
begin
    process(CLK, RST)
    begin
        if RST = '1' then
            for i in 63 downto 0 loop
                if i = 39 then
                    Banc(i) <= x"00000001";
                elsif i = 1 then
                    Banc(i) <= x"00000007";
                elsif i = 0 then
                    Banc(i) <= x"00000004";
                else
                    Banc(i) <= (others => '0');
                end if;
            end loop;
        elsif rising_edge(CLK) then
            if WrEn = '1' then
                Banc(to_integer(unsigned(Addr))) <= DataIn;
            end if;
        end if;
    end process;

    DataOut <= Banc(to_integer(unsigned(Addr)));
end architecture;