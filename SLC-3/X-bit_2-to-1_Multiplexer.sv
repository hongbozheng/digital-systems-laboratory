module mux_2_to_1_X_bit 
	#(parameter width = 16)(
	input logic [width-1:0] A, B,
	input logic Select,
	
	output logic [width-1:0] F
);

	assign F = Select ? B : A;
endmodule