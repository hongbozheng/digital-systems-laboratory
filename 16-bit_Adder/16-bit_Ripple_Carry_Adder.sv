module ripple_carry_adder_16_bit(
	input logic [15:0] A, B,
	input logic Cin,
	output logic [15:0] Sum,
	output logic Cout
);
	  
	logic [2:0] C;
	
	// Creating 16-bit Ripple-Carry Adder by connecting 4 4-bit Ripple-Carry Adder
	ripple_carry_adder_4_bit RCA_4_bit_0(.A(A[3:0]),   .B(B[3:0]),   .Cin(1'b0), .Sum(Sum[3:0]),   .Cout(C[0]));
	ripple_carry_adder_4_bit RCA_4_bit_1(.A(A[7:4]),   .B(B[7:4]),   .Cin(C[0]), .Sum(Sum[7:4]),   .Cout(C[1]));
	ripple_carry_adder_4_bit RCA_4_bit_2(.A(A[11:8]),  .B(B[11:8]),  .Cin(C[1]), .Sum(Sum[11:8]),  .Cout(C[2]));
	ripple_carry_adder_4_bit RCA_4_bit_3(.A(A[15:12]), .B(B[15:12]), .Cin(C[2]), .Sum(Sum[15:12]), .Cout(Cout));
   
endmodule
