# 创建工作库
# 编译 VHDL 文件

vcom -2008 ../src/REG.vhd
vcom -2008 ../src/ALU.vhd
vcom -2008 ../src/MUX.vhd
vcom -2008 ../src/MUX3.vhd
vcom -2008 ../src/Data_Memory.vhd
vcom -2008 ../src/Immextender.vhd
vcom -2008 ../src/Instruction_Management_Unit.vhd
vcom -2008 ../src/InstructionDecoder.vhd
vcom -2008 ../src/SEVEN_SEG.vhd
vcom -2008 ../src/top_level.vhd
vcom -2008 ../src/TopLevel_TP4.vhd
vcom -2008 TopLevel_tb.vhd

# 启动仿真
vsim Top_Level_tb

# 查看信号
view signals 
add wave -radix hexadecimal *



#add wave -radix hexadecimal

# 运行仿真
run -all

