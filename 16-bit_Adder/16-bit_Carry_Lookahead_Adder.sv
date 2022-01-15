module carry_lookahead_adder_16_bit (
	input  [15:0] A, B,
	input         Cin,
	output [15:0] Sum,
	output        Cout
);
	logic [3:0] C, PG, GG;
	
	assign C[0] = 1'b0;
	assign C[1] = GG[0] | (C[0] & PG[0]);
	assign C[2] = GG[1] | (GG[0] & PG[1]) | (C[0] & PG[0] & PG[1]);
	assign C[3] = GG[2] | (GG[1] & PG[2]) | (GG[0] & PG[1] & PG[2]) | (C[0] & PG[0] & PG[1] & PG[2]);
	
	carry_lookahead_adder_4_bit CLA_4_bit_0(.A(A[3:0]),   .B(B[3:0]),   .Cin(C[0]), .Sum(Sum[3:0]),   .Cout(), .PG(PG[0]), .GG(GG[0]));
	carry_lookahead_adder_4_bit CLA_4_bit_1(.A(A[7:4]),   .B(B[7:4]),   .Cin(C[1]), .Sum(Sum[7:4]),   .Cout(), .PG(PG[1]), .GG(GG[1]));
	carry_lookahead_adder_4_bit CLA_4_bit_2(.A(A[11:8]),  .B(B[11:8]),  .Cin(C[2]), .Sum(Sum[11:8]),  .Cout(), .PG(PG[2]), .GG(GG[2]));
	carry_lookahead_adder_4_bit CLA_4_bit_3(.A(A[15:12]), .B(B[15:12]), .Cin(C[3]), .Sum(Sum[15:12]), .Cout(), .PG(PG[3]), .GG(GG[3]));
	
	assign Cout = GG[3] | (GG[2] & PG[3]) | (GG[1] & PG[2] & PG[3]) | (C[0] & PG[0] & PG[1] & PG[2] & PG[3]);

endmodule