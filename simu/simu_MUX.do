# 创建工作库
vlib work

# 编译 VHDL 文件
vcom -93 MUX.vhd
vcom -93 MUX_tb.vhd

# 启动仿真
vsim MUX_tb

# 查看信号
view signals
add wave -radix hexadecimal *

# 运行仿真
run -all

