module full_adder_PG_1_bit(
	input logic A, B, Cin,
	output logic Sum, Cout, P, G
);

	assign Sum  = A ^ B ^ Cin;
	assign Cout = (A & B)|(A & Cin)|(B & Cin);
	assign P = A ^ B;
	assign G = A & B;

endmodule