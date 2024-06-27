vlib work

vcom -2008 fdiv.vhd
vcom -2008 UART_CONF.vhd
vcom -2008 uart_tx.vhd
vcom -2008 uart_rx.vhd
vcom -2008 interrupt_controller.vhd
vcom -2008 REG.vhd
vcom -2008 ALU.vhd
vcom -2008 MUX.vhd
vcom -2008 MUX3.vhd
vcom -2008 Data_Memory.vhd
vcom -2008 Immextender.vhd
vcom -2008 Instruction_Management_Unit.vhd
vcom -2008 InstructionDecoder.vhd
vcom -2008 TopLevel_TP7.vhd
vcom -2008 Toplevel_uart.vhd
vcom -2008 TP7_uart_tb.vhd
vsim TP7_uart_tb(helloworld)

view signals
add wave *
add wave -radix ASCII sim:/tp7_uart_tb/Data

run -all
wave zoom full