module mux_4_to_1_X_bit
	#(parameter width = 16) (
	input logic [width-1:0] A, B, C, D,
	input logic [1:0] Select,
	
	output logic [width-1:0] F
);
	assign F = Select[1] ? (Select[0] ? D : C) : (Select[0] ? B : A);
endmodule