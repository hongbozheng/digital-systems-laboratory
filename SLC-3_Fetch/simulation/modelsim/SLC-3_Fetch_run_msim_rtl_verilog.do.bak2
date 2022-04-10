transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/Marco\ Reus/Documents/ECE385/SLC-3_Fetch {C:/Users/Marco Reus/Documents/ECE385/SLC-3_Fetch/X-bit_4-to-1_Multiplexer.sv}
vlog -sv -work work +incdir+C:/Users/Marco\ Reus/Documents/ECE385/SLC-3_Fetch {C:/Users/Marco Reus/Documents/ECE385/SLC-3_Fetch/test_memory.sv}
vlog -sv -work work +incdir+C:/Users/Marco\ Reus/Documents/ECE385/SLC-3_Fetch {C:/Users/Marco Reus/Documents/ECE385/SLC-3_Fetch/synchronizers.sv}
vlog -sv -work work +incdir+C:/Users/Marco\ Reus/Documents/ECE385/SLC-3_Fetch {C:/Users/Marco Reus/Documents/ECE385/SLC-3_Fetch/SLC3_2.sv}
vlog -sv -work work +incdir+C:/Users/Marco\ Reus/Documents/ECE385/SLC-3_Fetch {C:/Users/Marco Reus/Documents/ECE385/SLC-3_Fetch/Mem2IO.sv}
vlog -sv -work work +incdir+C:/Users/Marco\ Reus/Documents/ECE385/SLC-3_Fetch {C:/Users/Marco Reus/Documents/ECE385/SLC-3_Fetch/ISDU.sv}
vlog -sv -work work +incdir+C:/Users/Marco\ Reus/Documents/ECE385/SLC-3_Fetch {C:/Users/Marco Reus/Documents/ECE385/SLC-3_Fetch/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/Marco\ Reus/Documents/ECE385/SLC-3_Fetch {C:/Users/Marco Reus/Documents/ECE385/SLC-3_Fetch/16-bit_Register.sv}
vlog -sv -work work +incdir+C:/Users/Marco\ Reus/Documents/ECE385/SLC-3_Fetch {C:/Users/Marco Reus/Documents/ECE385/SLC-3_Fetch/16-bit_4-to-1_DataBus_Multiplexer.sv}
vlog -sv -work work +incdir+C:/Users/Marco\ Reus/Documents/ECE385/SLC-3_Fetch {C:/Users/Marco Reus/Documents/ECE385/SLC-3_Fetch/memory_contents.sv}
vlog -sv -work work +incdir+C:/Users/Marco\ Reus/Documents/ECE385/SLC-3_Fetch {C:/Users/Marco Reus/Documents/ECE385/SLC-3_Fetch/DataPath.sv}
vlog -sv -work work +incdir+C:/Users/Marco\ Reus/Documents/ECE385/SLC-3_Fetch {C:/Users/Marco Reus/Documents/ECE385/SLC-3_Fetch/slc3.sv}
vlog -sv -work work +incdir+C:/Users/Marco\ Reus/Documents/ECE385/SLC-3_Fetch {C:/Users/Marco Reus/Documents/ECE385/SLC-3_Fetch/slc3_testtop.sv}

vlog -sv -work work +incdir+C:/Users/Marco\ Reus/Documents/ECE385/SLC-3_Fetch {C:/Users/Marco Reus/Documents/ECE385/SLC-3_Fetch/SLC-3_Fetch_testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  slc3_fetch_testbench

add wave *
view structure
view signals
run 2000 ns
