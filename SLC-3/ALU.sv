module alu(
	input logic [15:0] A,B,
	input logic [1:0] ALUK,
	
	output logic [15:0] ALU
);
	
	always_comb 
	begin
		case(ALUK)
			2'b00: ALU = A+B;
			2'b01: ALU = A&B;
			2'b10: ALU = ~A;
			2'b11: ALU = A;
		endcase
	end
endmodule