transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3 {C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3/BEN_Unit.sv}
vlog -sv -work work +incdir+C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3 {C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3/X-bit_4-to-1_Multiplexer.sv}
vlog -sv -work work +incdir+C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3 {C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3/X-bit_2-to-1_Multiplexer.sv}
vlog -sv -work work +incdir+C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3 {C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3/test_memory.sv}
vlog -sv -work work +incdir+C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3 {C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3/synchronizers.sv}
vlog -sv -work work +incdir+C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3 {C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3/SLC3_2.sv}
vlog -sv -work work +incdir+C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3 {C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3/Mem2IO.sv}
vlog -sv -work work +incdir+C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3 {C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3/ISDU.sv}
vlog -sv -work work +incdir+C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3 {C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3 {C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3/ALU.sv}
vlog -sv -work work +incdir+C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3 {C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3/16-bit_Register.sv}
vlog -sv -work work +incdir+C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3 {C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3/16-bit_4-to-1_DataBus_Multiplexer.sv}
vlog -sv -work work +incdir+C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3 {C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3/Reg_File.sv}
vlog -sv -work work +incdir+C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3 {C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3/memory_contents.sv}
vlog -sv -work work +incdir+C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3 {C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3/DataPath.sv}
vlog -sv -work work +incdir+C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3 {C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3/slc3.sv}
vlog -sv -work work +incdir+C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3 {C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3/slc3_testtop.sv}

vlog -sv -work work +incdir+C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3 {C:/Users/MarcoReus/Documents/QuartusProjects/SLC-3/SLC-3_testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  slc3_testbench

add wave *
view structure
view signals
run 2000 ns
