module ripple_carry_adder_4_bit(
	input logic [3:0] A, B, 
	input logic Cin,
	output logic [3:0] Sum, 
	output logic Cout
);

	logic [2:0]C;

	// Creating 4-bit Ripple-Carry Adder by connecting 4 1-bit Full Adder
	full_adder_1_bit FA_1_bit_0 (.A(A[0]), .B(B[0]), .Cin(Cin),  .Sum(Sum[0]), .Cout(C[0]));
	full_adder_1_bit FA_1_bit_1 (.A(A[1]), .B(B[1]), .Cin(C[0]), .Sum(Sum[1]), .Cout(C[1]));
	full_adder_1_bit FA_1_bit_2 (.A(A[2]), .B(B[2]), .Cin(C[1]), .Sum(Sum[2]), .Cout(C[2]));
	full_adder_1_bit FA_1_bit_3 (.A(A[3]), .B(B[3]), .Cin(C[2]), .Sum(Sum[3]), .Cout(Cout));

endmodule