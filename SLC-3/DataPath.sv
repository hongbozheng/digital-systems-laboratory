module datapath (
	input logic CLK, Reset,
	input logic GatePC, GateMARMUX, GateMDR, GateALU,
	input logic LD_REG, LD_PC, LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_LED,
	input logic DRMUX_SEL, SR1MUX_SEL, SR2MUX_SEL, ADDR1MUX_SEL, MIO_EN,
	input logic [1:0] ALUK, PCMUX_SEL, ADDR2MUX_SEL,
	input logic [15:0] MDR_Data,
	
	output logic [15:0] MAR, MDR, IR,
	output logic [9:0] LED,
	output logic BEN
);

	logic [15:0] DataBus, IR_wire, ALU;
	
	// Reg_File Select inputs from DR_MUX & SR1MUX
	logic [2:0] DRMUX, SR1MUX;
	
	// Reg_File Outputs & SR2MUX Output
	logic [15:0] SR1_OUT, SR2_OUT, SR2MUX;
	
	// PC_MUX Input and Output
	logic [15:0] PCMUX, PC, ADDR_SUM, ADDR1MUX, ADDR2MUX;
	
	logic [15:0] MDRMUX;
	
	assign ADDR_SUM = ADDR1MUX+ADDR2MUX;
	assign IR = IR_wire;
	
	// DR_MUX
	mux_2_to_1_X_bit #(3) DR_MUX(.A(IR_wire[11:9]),.B(3'b111),.Select(DRMUX_SEL),.F(DRMUX));
	
	// SR1_MUX
	mux_2_to_1_X_bit #(3) SR1_MUX(.A(IR_wire[11:9]),.B(IR_wire[8:6]),.Select(SR1MUX_SEL),.F(SR1MUX));
	
	// Reg_File
	reg_file Reg_File(.CLK,.Reset,.LD_REG,.DR(DRMUX),.SR1(SR1MUX),.SR2(IR_wire[2:0]),.DataBus,.SR1_OUT,.SR2_OUT);
	
	// SR2_MUX
	mux_2_to_1_X_bit SR2_MUX(.A(SR2_OUT),.B({{11{IR_wire[4]}},IR_wire[4:0]}),.Select(IR[5]),.F(SR2MUX));
	
	// ALU
	alu ALU_Unit(.A(SR1_OUT),.B(SR2MUX),.ALUK,.ALU);
	
	// ADDR1_MUX
	mux_2_to_1_X_bit ADDR1_MUX(.A(SR1_OUT),.B(PC),.Select(ADDR1MUX_SEL),.F(ADDR1MUX));
	
	// ADDR2_MUX
	mux_4_to_1_X_bit ADDR2_MUX(.A(16'h0000),.B({{10{IR_wire[5]}},IR_wire[5:0]}),.C({{7{IR_wire[8]}},IR_wire[8:0]}),.D({{5{IR_wire[10]}},IR_wire[10:0]}),.Select(ADDR2MUX_SEL),.F(ADDR2MUX));

	// PC_MUX
	mux_4_to_1_X_bit PC_MUX (.A(PC+16'h1),.B(ADDR_SUM),.C(DataBus),.D(16'h0),.Select(PCMUX_SEL),.F(PCMUX));
	
	// MDR_MUX
	mux_2_to_1_X_bit MDR_MUX(.A(DataBus),.B(MDR_Data),.Select(MIO_EN),.F(MDRMUX));
	
	// PC
	register_16_bit PC_Register_16_bit (.CLK,.Reset,.Load(LD_PC), .Data_In(PCMUX),  .Data_Out(PC));
	
	// MAR
	register_16_bit MAR_Register_16_bit(.CLK,.Reset,.Load(LD_MAR),.Data_In(DataBus),.Data_Out(MAR));
	
	// MDR
	register_16_bit MDR_Register_16_bit(.CLK,.Reset,.Load(LD_MDR),.Data_In(MDRMUX),.Data_Out(MDR));
	
	// IR
	register_16_bit IR_Register_16_bit (.CLK,.Reset,.Load(LD_IR), .Data_In(DataBus), .Data_Out(IR_wire));
	
	// DataBus
	databus_mux_4_to_1_16_bit databus_mux(.GatePC,.GateMARMUX,.GateMDR,.GateALU,.PC,.ADDR_SUM,.MDR,.ALU,.DataBus);
	
	// BEN_Unit
	ben_unit BEN_Unit(.CLK,.Reset,.LD_BEN,.LD_CC,.DataBus,.IR_11_9(IR_wire[11:9]),.BEN);
	
	// Pause Instruction
	always_ff @ (posedge CLK)
	begin
		if(LD_LED)
			LED <= IR[9:0];
		else if(Reset)
			LED <= 9'b0;
	end
	
endmodule