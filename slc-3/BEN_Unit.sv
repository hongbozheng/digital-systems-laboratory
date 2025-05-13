module ben_unit(
	input logic CLK, Reset, LD_BEN, LD_CC,
	input logic [15:0] DataBus,
	input logic [2:0] IR_11_9,
	
	output logic BEN
);

	logic n,z,p, n_out, z_out, p_out;
	
	always_comb
	begin
		if(DataBus == 16'h0000)
			begin
				n = 1'b0;
				z = 1'b1;
				p = 1'b0;
			end
		
		else if(DataBus[15] == 1'b0 && DataBus != 16'h0000)
			begin
				n = 1'b0;
				z = 1'b0;
				p = 1'b1;
			end
		
		else if(DataBus[15] == 1'b1)
			begin
				n = 1'b1;
				z = 1'b0;
				p = 1'b0;
			end
		
		else
			begin
				n = 1'bZ;
				z = 1'bZ;
				p = 1'bZ;
			end
	end
	
	always_ff @ (posedge CLK)
	begin
		if(Reset)
			BEN <= 1'b0;
		
		else if(LD_BEN)
			BEN <= ((IR_11_9 & {n_out,z_out,p_out}) != 3'b000);
		
		if(LD_CC)
			begin
				n_out <= n;
				z_out <= z;
				p_out <= p;
			end
	end
endmodule