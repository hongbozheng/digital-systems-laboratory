module mux_2_to_1_4_bit(
	input logic [3:0] A, B,
	input logic Select,
	output logic [3:0] F
);

	assign F[3:0] = (Select) ? A[3:0] : B[3:0];

endmodule