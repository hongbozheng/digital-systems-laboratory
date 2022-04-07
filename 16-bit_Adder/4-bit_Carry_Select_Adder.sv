module carry_select_adder_4_bit(
	input logic [3:0] A, B,
	input logic Cin,
	output logic [3:0] Sum,
	output logic Cout
);

	logic [3:0] Sum_Cin_0, Sum_Cin_1;
	logic Cout_Cin_0, Cout_Cin_1;
	
	// Creating a 4-bit Carry Select Adder by connecting 2 4-bit Ripple-Carry Adder to a 4-bit 2-to-1 Multiplexer
	ripple_carry_adder_4_bit RCA_4_bit_0(.A(A), .B(B), .Cin(1'b0), .Sum(Sum_Cin_0), .Cout(Cout_Cin_0));
	ripple_carry_adder_4_bit RCA_4_bit_1(.A(A), .B(B), .Cin(1'b1), .Sum(Sum_Cin_1), .Cout(Cout_Cin_1));
	mux_2_to_1_4_bit MUX_2_to_1_4_bit(.A(Sum_Cin_1), .B(Sum_Cin_0), .Select(Cin), .F(Sum));
	
	assign Cout = (Cin & Cout_Cin_1) | Cout_Cin_0;

endmodule