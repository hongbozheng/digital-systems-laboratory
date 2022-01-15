module carry_lookahead_adder_4_bit(
	input logic [3:0] A, B,
	input logic Cin,
	output logic [3:0] Sum,
	output logic Cout, PG, GG
);

	logic [3:0] C, P, G;
	
	assign C[0] = Cin;
	assign C[1] = (Cin & P[0]) | G[0];
	assign C[2] = (Cin & P[0] & P[1]) | (G[0] & P[1]) | G[1];
	assign C[3] = (Cin & P[0] & P[1] & P[2]) | (G[0] & P[1] & P[2]) | (G[1] & P[2]) | G[2];
	
	full_adder_PG_1_bit FA_PG_1_bit_0 (.A(A[0]), .B(B[0]), .Cin(C[0]), .Sum(Sum[0]), .Cout(), .P(P[0]), .G(G[0]));
	full_adder_PG_1_bit FA_PG_1_bit_1 (.A(A[1]), .B(B[1]), .Cin(C[1]), .Sum(Sum[1]), .Cout(), .P(P[1]), .G(G[1]));
	full_adder_PG_1_bit FA_PG_1_bit_2 (.A(A[2]), .B(B[2]), .Cin(C[2]), .Sum(Sum[2]), .Cout(), .P(P[2]), .G(G[2]));
	full_adder_PG_1_bit FA_PG_1_bit_3 (.A(A[3]), .B(B[3]), .Cin(C[3]), .Sum(Sum[3]), .Cout(), .P(P[3]), .G(G[3]));
	
	assign Cout = G[3] | (G[2] & P[3]) | (G[1] & P[2] & P[3]) | (G[0] & P[1] & P[2] & P[3]) | (Cin & P[0] & P[1] & P[2] & P[3]);
	assign PG = P[0] & P[1] & P[2] & P[3];
	assign GG = G[3] | (G[2] & P[3]) | (G[1] & P[3] & P[2]) | (G[0] & P[3] & P[2] & P[1]);

endmodule