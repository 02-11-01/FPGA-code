# 创建工作库
vlib work

# 编译 VHDL 文件
vcom -2008 Data_Memory.vhd
vcom -2008 DataMemory_tb.vhd

# 启动仿真
vsim DataMemory_tb

# 查看信号
view signals
add wave -radix hexadecimal *

# 运行仿真
run -all

