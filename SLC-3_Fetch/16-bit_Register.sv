module register_16_bit (
	input logic CLK, Reset, Load,
	input logic [15:0] Data_In,
	
	output logic [15:0] Data_Out
);

	always_ff @ (posedge CLK)
	begin
		if(Reset)
			Data_Out <= 16'h0;
		else if(Load)
			Data_Out <= Data_In;
	end
endmodule