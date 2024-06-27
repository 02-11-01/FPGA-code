library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library modelsim_lib;
use modelsim_lib.util.all;

entity TP7_UART_tb is
end entity;


architecture helloworld of TP7_UART_tb is
    Signal Clk     : std_logic;
    Signal Reset   : std_logic := '0';
    Signal Display : std_logic_vector(31 downto 0);
    Signal IRQ0    : std_logic := '0';
    Signal IRQ1    : std_logic := '0';
    Signal Data    : std_logic_vector(7 downto 0);
    Signal Tx      : std_logic := '1';
    Signal Rx      : std_logic := '1';
    Signal OK      : boolean := TRUE;

    type arr is array (natural range <>) of std_logic_vector;
    Signal Str     : arr (0 to 11)(7 downto 0) := (
        x"48", -- H
        x"45", -- E
        x"4C", -- L
        x"4C", -- L
        x"4F", -- O
        x"20", --
        x"57", -- W
        x"4F", -- O
        x"52", -- R
        x"4C", -- L
        x"44", -- D
        x"21"  -- !
    );
begin

process
begin
    while (now <= 50 us) loop
        Clk <= '0';
        wait for 10 ns;
        Clk <= '1';
        wait for 10 ns;
    end loop;
    wait;
end process;

UUT: process
begin

    Reset <= '1';
    wait for 10 ns;

    Reset <= '0';

    wait for 1 us;

    IRQ1 <= '1';

    wait for 20 ns;

    IRQ1 <= '0';

    for i in 0 to 7 loop
        Data <= Str(i);

        wait until Tx = '0';

        wait for 8750 ns;

    end loop;

    wait for 10 ns;

    wait;
end process;

processor: entity work.TopLevel_TP7
    port map (
        Clk     => Clk,
        RST   => Reset,
        IRQ0    => IRQ0,
        IRQ1    => IRQ1,
        OutPut_Data => Display,
        Tx      => Tx,
        Rx      => Rx


    );

end helloworld;

