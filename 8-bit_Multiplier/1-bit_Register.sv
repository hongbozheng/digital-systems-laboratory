module register_1_bit(
	input logic CLK, Reset, Load, D,
	output logic Q
);

	always @ (posedge CLK or posedge Reset)
	begin
		Q <= Q;
		
		if(Reset)
			Q <= 1'b0;
		else if(Load)
			Q <= D;
	end

endmodule