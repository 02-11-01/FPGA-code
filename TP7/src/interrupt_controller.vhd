library IEEE;
use IEEE.std_logic_1164.all;

entity INTERRUPT_CONTROLLER is
  port (
    Clk      : in std_logic;
    Reset    : in std_logic;
    IRQ_SERV : in std_logic;
    IRQ0     : in std_logic;
    IRQ1     : in std_logic;
    IRQTx    : in std_logic;
    IRQRx    : in std_logic;
    IRQ      : out std_logic;
    VICPC    : out std_logic_vector(31 downto 0)
  );
end INTERRUPT_CONTROLLER;

architecture Behavioral of INTERRUPT_CONTROLLER is
    signal IRQ0_memo, IRQ1_memo,IRQTx_memo, IRQRx_memo: std_logic;
begin
VICPC <= x"00000009" when IRQ0_memo = '1' else
         x"00000015" when IRQ1_memo = '1' else
         x"0000001E" when IRQTx_memo = '1' else
         x"00000028" when IRQRx_memo = '1' else
         x"00000000";

IRQ <= (IRQ0_memo or IRQ1_memo or IRQTx_memo or IRQRx_memo ) and not(IRQ_SERV);

sampling: process(Clk, Reset)
    variable IRQ0_prev, IRQ1_prev,IRQTx_prev, IRQRx_prev: std_logic;
begin
    if (Reset = '1') then
        IRQ0_memo <= '0';
        IRQ1_memo <= '0';
        IRQTx_memo <= '0';
        IRQRx_memo <= '0';
    elsif (rising_edge(Clk)) then
        if (IRQ0_prev = '0' and IRQ0 = '1') then
            IRQ0_memo <= '1';
        elsif (IRQ_SERV = '1') then
            IRQ0_memo <= '0';
        end if;

        if (IRQ1_prev = '0' and IRQ1 = '1') then
            IRQ1_memo <= '1';
        elsif (IRQ_SERV = '1') then
            IRQ1_memo <= '0';
        end if;

        if (IRQTx_prev = '0' and IRQTx = '1') then
            IRQTx_memo <= '1';
        elsif (IRQ_SERV = '1') then
            IRQTx_memo <= '0';
        end if;

        if (IRQRx_prev = '0' and IRQRx = '1') then
            IRQRx_memo <= '1';
        elsif (IRQ_SERV = '1') then
            IRQRx_memo <= '0';
        end if;
        IRQ0_prev  := IRQ0;
        IRQ1_prev  := IRQ1;
        IRQTx_prev := IRQTx;
        IRQRx_prev := IRQRx;
    end if;
end process;
end architecture;