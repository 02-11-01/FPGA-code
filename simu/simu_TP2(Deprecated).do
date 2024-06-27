# 创建工作库
vlib work



# 编译 VHDL 文件
vcom -2008 Instruction_Management_Unit.vhd
vcom -2008 Instruction_Management_Unit_tb.vhd

# 启动仿真
vsim work.Instruction_Management_Unit_tb

# 查看信号
view wave
add wave -radix hexadecimal *

# 运行仿真
run -all


