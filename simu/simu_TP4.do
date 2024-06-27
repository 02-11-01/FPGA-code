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
vcom -2008 ../src/TopLevel_TP4.vhd
vcom -2008 TestBench_tp4.vhd


# 启动仿真
vsim TopLevel_tb

# 查看信号
view signals 
add wave -radix hexadecimal *
add wave sim:/toplevel_tb/uut/I1D_inst/instr_current
add wave -radix hexadecimal sim:/toplevel_tb/uut/busW
add wave -radix hexadecimal sim:/toplevel_tb/uut/IMU_inst/instruction_memory
add wave -radix hexadecimal sim:/toplevel_tb/uut/reg_inst/Banc 
add wave -radix hexadecimal sim:/toplevel_tb/uut/Data_Memory_inst0/Banc
add wave -radix hexadecimal sim:/toplevel_tb/uut/I1D_inst/instruction
add wave -radix hexadecimal sim:/toplevel_tb/uut/IMU_inst/instruction
add wave -radix hexadecimal sim:/toplevel_tb/uut/IMU_inst/PC
add wave -radix hexadecimal sim:/toplevel_tb/uut/I1D_inst/nPCSel
add wave -radix decimal sim:/toplevel_tb/uut/IMU_inst/Rd
add wave -radix decimal sim:/toplevel_tb/uut/IMU_inst/Rn
add wave -radix decimal sim:/toplevel_tb/uut/IMU_inst/Rm
add wave -radix decimal sim:/toplevel_tb/uut/reg_inst/RW
add wave -radix decimal sim:/toplevel_tb/uut/reg_inst/RA
add wave -radix decimal sim:/toplevel_tb/uut/reg_inst/RB
add wave -radix decimal sim:/toplevel_tb/uut/IMU_inst/imm8
add wave -radix hexadecimal sim:/toplevel_tb/uut/reg_inst/B
add wave -radix hexadecimal sim:/toplevel_tb/uut/reg_inst/A
add wave -radix hexadecimal sim:/toplevel_tb/uut/MUX3_inst/COM
add wave -radix hexadecimal sim:/toplevel_tb/uut/MUX3_inst/S
add wave -radix hexadecimal sim:/toplevel_tb/uut/ALU_inst/A
add wave -radix hexadecimal sim:/toplevel_tb/uut/ALU_inst/B
add wave -radix hexadecimal sim:/toplevel_tb/uut/ALU_inst/S
add wave -radix binary sim:/toplevel_tb/uut/ALU_inst/CPSR
add wave -radix hexadecimal sim:/toplevel_tb/uut/reg_inst/W
add wave -radix hexadecimal sim:/toplevel_tb/uut/reg_inst/WE


#add wave -radix hexadecimal

# 运行仿真
run -all

