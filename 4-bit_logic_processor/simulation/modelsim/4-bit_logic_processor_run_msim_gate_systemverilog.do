transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -sv -work work +incdir+. {4-bit_logic_processor.svo}

vlog -sv -work work +incdir+C:/Users/Marco\ Reus/Documents/ECE385/4-bit_logic_processor {C:/Users/Marco Reus/Documents/ECE385/4-bit_logic_processor/4-bit_logic_processor_testbench.sv}

vsim -t 1ps -L altera_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L gate_work -L work -voptargs="+acc"  logic_processor_4_bit_testbench

add wave *
view structure
view signals
run 1000 ns
