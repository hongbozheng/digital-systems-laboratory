module multiplier_8_bit_testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

logic CLK=0;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic [7:0] S;
logic Reset, ClearA_LoadB, Execute;
logic [7:0] Aval, Bval;
				
// A counter to count the instances where simulation results
// do no match with expected results
//integer ErrorCnt = 0;
		
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
Multiplier_8_bit multiplier_8_bit(.CLK, .S, .Reset, .ClearA_LoadB, .Execute, .Aval, .Bval);	

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 CLK = ~CLK;
end

initial begin: CLOCK_INITIALIZATION
    CLK = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS

// Initialize Values
S=8'h00;
Reset=1'b0;
ClearA_LoadB=1'b1;
Execute=1'b1;

#2 Reset = 1'b1;
#2 Reset = 1'b0;

// 7 * 59
#2 S=8'h07;
#2 ClearA_LoadB = 0;
#2 ClearA_LoadB=1;
#2 S=8'h3B;

#2 Execute=1'b0;
#2 Execute=1'b1;

#100 Reset=1'b1;
#2 Reset=1'b0;
//
// -7 * 59
#2 S=8'hF9;
#2 ClearA_LoadB = 0;
#2 ClearA_LoadB=1;
#2 S=8'h3B;

#2 Execute=1'b0;
#2 Execute=1'b1;

#100 Reset=1'b1;
#2 Reset=1'b0;
//
//// 7 * -59
#2 S=8'h07;
#2 ClearA_LoadB = 0;
#2 ClearA_LoadB=1;
#2 S=8'hC5;

#2 Execute=1'b0;
#2 Execute=1'b1;

#100 Reset=1'b1;
#2 Reset=1'b0;
//
// -7 * -59
#2 S=8'hF9;
#2 ClearA_LoadB = 0;
#2 ClearA_LoadB=1;
#2 S=8'hC5;

#2 Execute=1'b0;
#2 Execute=1'b1;

end
endmodule
