module Multiplier_8_bit(
	input logic [7:0] S,
	input logic CLK, Reset, ClearA_LoadB, Execute,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3,
	output logic [7:0] Aval, Bval,
	output logic X
);

	logic [7:0] A, B;
	logic [8:0] Sum;
	
	// Register X, A, B
	logic Register_X_Shift_Out, Register_A_Shift_Out, Register_B_Shift_Out;
	
	// Control Unit
	logic Clear_Load, Shift_Enable, Load_XA, Subtract_Enable, Clear_Register;
	
	// Synchronizer
	logic Reset_SH, Execute_SH, ClearA_LoadB_SH;
	
	// S --- Synchronized
	// H --- Active High
	sync synchronizer0(.Clk(CLK), .d(Reset),         .q(Reset_SH));
	sync synchronizer1(.Clk(CLK), .d(~Execute),      .q(Execute_SH));
	sync synchronizer2(.Clk(CLK), .d(~ClearA_LoadB), .q(ClearA_LoadB_SH));
	
	register_1_bit Reg_X_1_bit  (.CLK(CLK),
										.Reset(Reset_SH|Clear_Load|Clear_Register),
										.Load(Load_XA),
										.D(Sum[8]),
										.Q(Register_X_Shift_Out));
										
	register_8_bit Reg_A_8_bit(.CLK(CLK),
										.Reset(Reset_SH|Clear_Load|Clear_Register),
										.Load(Load_XA),
										.Shift_Enable(Shift_Enable),
										.Shift_In(Register_X_Shift_Out),
										.Data_In(Sum[7:0]),
										.Shift_Out(Register_A_Shift_Out),
										.Data_Out(A));
										
	register_8_bit Reg_B_8_bit(.CLK(CLK),
										.Reset(Reset), 
										.Load(ClearA_LoadB_SH),
										.Shift_Enable(Shift_Enable),
										.Shift_In(Register_A_Shift_Out),
										.Data_In(S),
										.Shift_Out(Register_B_Shift_Out),
										.Data_Out(B));
										
	adder_subtractor_9_bit Add_Sub_9_bit(.A(A),
													 .B(S),
													 .Subtract_Enable(Subtract_Enable),
													 .Sum(Sum),
													 .Cout());
													 
	control_unit Control_Unit(.CLK(CLK),
									  .Reset(Reset_SH),
									  .ClearA_LoadB(ClearA_LoadB_SH),
									  .Execute(Execute_SH),
									  .Register_B_Shift_Out(Register_B_Shift_Out),
									  .Clear_Load(Clear_Load),
									  .Shift(Shift_Enable),
									  .Load_XA(Load_XA),
									  .Subtract_Enable(Subtract_Enable),
									  .Clear_Register(Clear_Register));
	
	HexDriver HexBL(.In0(B[3:0]), .Out0(HEX0));
	HexDriver HexBU(.In0(B[7:4]), .Out0(HEX1));
	HexDriver HexAL(.In0(A[3:0]), .Out0(HEX2));
	HexDriver HexAU(.In0(A[7:4]), .Out0(HEX3));
	
	assign Aval = A;
	assign Bval = B;

endmodule