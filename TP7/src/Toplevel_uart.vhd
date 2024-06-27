library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART is
  port (
    Clk    : in std_logic;
    Reset  : in std_logic;
    Data   : in std_logic_vector(7 downto 0);
    UARTWr : in std_logic;
    Rx     : in std_logic;
    Tx     : out std_logic;
    TxIrq  : out std_logic;
    RxData : out std_logic_vector(7 downto 0);
    RxIrq  : out std_logic
  );
end UART;

architecture RTL of UART is
    Signal Tick, Tick_half, Go, FDIV_RST, Error : std_logic;
    Signal DataReg  : std_logic_vector(31 downto 0);
    Signal Data_sub  : std_logic_vector(31 downto 0);
    component FDIV is 
      port (         
      Clk       : in std_logic;
      Reset     : in std_logic;
      Tick      : out std_logic;
      Tick_half : out std_logic
          );
  end component;
    component Uart_CONF is 
      port (
        Clk     : in STD_LOGIC;
        Reset   : in STD_LOGIC;
        Uart_CONF_DataIn  : in STD_LOGIC_VECTOR(31 downto 0);
        Uart_CONF_WrEn    : in STD_LOGIC;
        Uart_CONF_DataOut : out STD_LOGIC_VECTOR(31 downto 0);
        Go      : out STD_LOGIC
          );
  end component;
  component UART_RX is
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
  end component;
  
  component UART_TX is
    port (
        Clk   : in std_logic;
        Reset : in std_logic;
        Go    : in std_logic;
        Data  : in std_logic_vector(7 downto 0);
        Tick  : in std_logic;
        Tx    : out std_logic;
        TxIrq : out std_logic
    );
end component;
begin
  Data_sub<= X"000000"&Data;
  fdiv_inst: FDIV port map (
      Clk   => Clk,
      Reset => FDIV_RST,
      Tick  => Tick,
      Tick_half => Tick_half
    );

  UART_Conf_inst: Uart_CONF port map (
    Clk     => Clk,
    Reset   => Reset,
    Uart_CONF_DataIn  => Data_sub,
    Uart_CONF_WrEn    => UARTWr,
    Uart_CONF_DataOut => DataReg,
    Go      => Go
  );

  UART_TX_inst: UART_TX port map (
      Clk   => Clk,
      Reset => Reset,
      Go    => Go,
      Data  => DataReg(7 downto 0),
      Tick  => Tick,
      Tx    => Tx,
      TxIrq => TxIrq
    );

  UART_RX_inst: UART_RX port map (
    Clk          => Clk,
    Reset        => Reset,
    Rx           => Rx,
    Tick_halfbit => Tick_half,
    FDIV_RST   => FDIV_RST,
    Error          => Error,
    Data         => RxData,
    RxIrq        => RxIrq
  );

end RTL;