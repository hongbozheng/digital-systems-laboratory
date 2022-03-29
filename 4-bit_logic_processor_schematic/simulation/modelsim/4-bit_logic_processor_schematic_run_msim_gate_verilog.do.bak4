transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {4-bit_logic_processor_schematic.vo}

vlog -sv -work work +incdir+C:/Users/Marco\ Reus/Documents/ECE385/4-bit_logic_processor_schematic {C:/Users/Marco Reus/Documents/ECE385/4-bit_logic_processor_schematic/logic_processor_4_bit_testbench.sv}

vsim -t 1ps -L altera_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L gate_work -L work -voptargs="+acc"  logic_processor_4_bit_testbench

add wave *
view structure
view signals
run 1000 ns
