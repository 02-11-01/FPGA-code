library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Uart_CONF is
  port (
    Clk     : in STD_LOGIC;
    Reset   : in STD_LOGIC;
    Uart_CONF_DataIn  : in STD_LOGIC_VECTOR(31 downto 0);
    Uart_CONF_WrEn    : in STD_LOGIC;
    Uart_CONF_DataOut : out STD_LOGIC_VECTOR(31 downto 0);
    Go      : out STD_LOGIC
  );
end Uart_CONF;

architecture RTL of Uart_CONF is
begin

process(Clk, Reset)
begin
  if (Reset = '1') then
    Uart_CONF_DataOut <= (others => '0');
    Go <= '0';
  elsif rising_edge(Clk) then
    if (Uart_CONF_WrEn = '1') then
        Go <= '1';
        Uart_CONF_DataOut <= Uart_CONF_DataIn;
    else
        Go <= '0';
    end if;
  end if;
end process;

end RTL;