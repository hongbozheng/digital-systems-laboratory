module databus_mux_4_to_1_16_bit (
	input logic GatePC,
	input logic GateMARMUX,
	input logic GateMDR,
	input logic GateALU,
	
	input logic [15:0] PC, ADDR_SUM, MDR, ALU,
	
	output logic [15:0] DataBus
);

	always_comb
	begin
		if (GatePC)
			DataBus = PC;
		else if (GateMARMUX)
			DataBus = ADDR_SUM;
		else if (GateMDR)
			DataBus = MDR;
		else if (GateALU)
			DataBus = ALU;
		else
			DataBus = 16'h0;
	end
endmodule