module full_adder_1_bit(
	input logic A, B, Cin,
	output logic Sum, Cout
);

	assign Sum  = A ^ B ^ Cin;
	assign Cout = (A & B)|(A & Cin)|(B & Cin);

endmodule