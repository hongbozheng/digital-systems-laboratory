module datapath (
	input logic CLK, Reset,
	input logic GatePC, GateMARMUX, GateMDR, GateALU,
	input logic LD_PC, LD_MAR, LD_MDR, LD_IR,
	input logic [1:0] PCMUX,
	input logic [15:0] Data,

	output logic [15:0] PC,
	output logic [15:0] ADDR_SUM,
	output logic [15:0] MAR,
	output logic [15:0] MDR,
	output logic [15:0] ALU,
	output logic [15:0] DataBus,
	output logic [15:0] IR
);

logic [15:0] PC_In;


	// PC_MUX
	mux_4_to_1_X_bit PC_MUX(.A(PC+16'h1),.B(DataBus),.C(ADDR_SUM),.D(16'h0),.Select(PCMUX),.F(PC_In));
	
	// PC
	register_16_bit PC_Register_16_bit(.CLK,.Reset,.Load(LD_PC), .Data_In(PC_In),  .Data_Out(PC) );
	
	// MAR
	register_16_bit MAR_Register_16_bit(.CLK,.Reset,.Load(LD_MAR), .Data_In(DataBus),  .Data_Out(MAR));
	
	// MDR
	register_16_bit MDR_Register_16_bit(.CLK,.Reset,.Load(LD_MDR), .Data_In(Data),  .Data_Out(MDR));
	
	// IR
	register_16_bit IR_Register_16_bit(.CLK,.Reset,.Load(LD_IR), .Data_In(DataBus),.Data_Out(IR));
	
	// DataBus
	databus_mux_4_to_1_16_bit databus_mux(.GatePC,.GateMARMUX,.GateMDR,.GateALU,.PC,.ADDR_SUM,.MDR,.ALU,.DataBus);
endmodule