# 创建工作库
vlib work

# 编译 VHDL 文件
vcom -2008 REG.vhd
vcom -2008 ALU.vhd
vcom -2008 MUX.vhd
vcom -2008 Data_Memory.vhd
vcom -2008 TopLevel_combine.vhd
vcom -2008 TopLevel_com_tb.vhd

# 启动仿真
vsim TopLevel_tb

# 查看信号
view signals 
add wave -radix hexadecimal *
add wave -radix hexadecimal sim:/toplevel_tb/uut/ALU_inst/S
add wave -radix hexadecimal sim:/toplevel_tb/uut/reg_inst/Banc
add wave  -radix hexadecimal sim:/toplevel_tb/uut/reg_inst/W
# 运行仿真
run -all

