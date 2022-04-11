module reg_file(
	input logic CLK, Reset, LD_REG,
	input logic [2:0] DR, SR1, SR2,
	input logic [15:0] DataBus,
	
	output logic [15:0] SR1_OUT, SR2_OUT
);
	// Create 8 registers in Reg_File
	logic [7:0][15:0] Register_Data_Out;
	
	// Define 8 registers in Reg_File
	always_ff @ (posedge CLK)
	begin
		if(Reset)
			begin
				Register_Data_Out[0] <= 16'h0000;
				Register_Data_Out[1] <= 16'h0000;
				Register_Data_Out[2] <= 16'h0000;
				Register_Data_Out[3] <= 16'h0000;
				Register_Data_Out[4] <= 16'h0000;
				Register_Data_Out[5] <= 16'h0000;
				Register_Data_Out[6] <= 16'h0000;
				Register_Data_Out[7] <= 16'h0000;
			end
		
		else if(LD_REG)
			begin
				case(DR)
					3'b000: Register_Data_Out[0] <= DataBus;
					3'b001: Register_Data_Out[1] <= DataBus;
					3'b010: Register_Data_Out[2] <= DataBus;
					3'b011: Register_Data_Out[3] <= DataBus;
					3'b100: Register_Data_Out[4] <= DataBus;
					3'b101: Register_Data_Out[5] <= DataBus;
					3'b110: Register_Data_Out[6] <= DataBus;
					3'b111: Register_Data_Out[7] <= DataBus;
					default: ;
				endcase
			end
	end

	// Define output of SR1_OUT
	always_comb
	begin
		case(SR1)
			3'b000: SR1_OUT = Register_Data_Out[0];
			3'b001: SR1_OUT = Register_Data_Out[1];
			3'b010: SR1_OUT = Register_Data_Out[2];
			3'b011: SR1_OUT = Register_Data_Out[3];
			3'b100: SR1_OUT = Register_Data_Out[4];
			3'b101: SR1_OUT = Register_Data_Out[5];
			3'b110: SR1_OUT = Register_Data_Out[6];
			3'b111: SR1_OUT = Register_Data_Out[7];
			default: ;
		endcase
	end

	// Define output of SR2_OUT
	always_comb
	begin
		case(SR2)
			3'b000: SR2_OUT = Register_Data_Out[0];
			3'b001: SR2_OUT = Register_Data_Out[1];
			3'b010: SR2_OUT = Register_Data_Out[2];
			3'b011: SR2_OUT = Register_Data_Out[3];
			3'b100: SR2_OUT = Register_Data_Out[4];
			3'b101: SR2_OUT = Register_Data_Out[5];
			3'b110: SR2_OUT = Register_Data_Out[6];
			3'b111: SR2_OUT = Register_Data_Out[7];
			default: ;
		endcase
	end

endmodule