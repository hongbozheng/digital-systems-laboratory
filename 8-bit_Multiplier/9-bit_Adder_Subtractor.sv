module adder_subtractor_9_bit(
	input logic [7:0] A, B,
	input logic Subtract_Enable,	// Change the mode of the component '0'-Adder '1'-Subtractor
	output logic [8:0] Sum,
	output logic Cout
);

	logic [7:0] C, B_Add_Subtract;
	logic A8, B8;
	
	assign B_Add_Subtract = {B ^ {8{Subtract_Enable}}};
	assign A8 = A[7];
	assign B8 = B_Add_Subtract[7];
	
	full_adder_1_bit FA_1_bit_0(.A(A[0]), .B(B_Add_Subtract[0]), .Cin(Subtract_Enable), .Sum(Sum[0]), .Cout(C[0]));
	full_adder_1_bit FA_1_bit_1(.A(A[1]), .B(B_Add_Subtract[1]), .Cin(C[0]), 			   .Sum(Sum[1]), .Cout(C[1]));
	full_adder_1_bit FA_1_bit_2(.A(A[2]), .B(B_Add_Subtract[2]), .Cin(C[1]), 			   .Sum(Sum[2]), .Cout(C[2]));
	full_adder_1_bit FA_1_bit_3(.A(A[3]), .B(B_Add_Subtract[3]), .Cin(C[2]), 			   .Sum(Sum[3]), .Cout(C[3]));
	full_adder_1_bit FA_1_bit_4(.A(A[4]), .B(B_Add_Subtract[4]), .Cin(C[3]), 			   .Sum(Sum[4]), .Cout(C[4]));
	full_adder_1_bit FA_1_bit_5(.A(A[5]), .B(B_Add_Subtract[5]), .Cin(C[4]), 			   .Sum(Sum[5]), .Cout(C[5]));
	full_adder_1_bit FA_1_bit_6(.A(A[6]), .B(B_Add_Subtract[6]), .Cin(C[5]), 			   .Sum(Sum[6]), .Cout(C[6]));
	full_adder_1_bit FA_1_bit_7(.A(A[7]), .B(B_Add_Subtract[7]), .Cin(C[6]), 			   .Sum(Sum[7]), .Cout(C[7]));
	full_adder_1_bit FA_1_bit_8(.A(A8),   .B(B8),   				 .Cin(C[7]), 			   .Sum(Sum[8]), .Cout());
	
endmodule