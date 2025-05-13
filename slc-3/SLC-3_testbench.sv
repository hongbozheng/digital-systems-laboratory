module slc3_testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
// This is the amount of time represented by #1 
timeprecision 1ns;

logic CLK=0;

logic [9:0] SW;
logic	Clk, Run, Continue;
logic [9:0] LED;
logic [6:0] HEX0, HEX1, HEX2, HEX3;

slc3_testtop slc3_TestTop(.Clk(CLK),.Run,.Continue,.SW,.HEX0,.HEX1,.HEX2,.HEX3,.LED);

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
SW=10'b0;
Run=1'b1;
Continue=1'b1;

#2 Run=1'b0;
Continue=1'b0;

#2 Run=1'b1;
Continue=1'b1;

////////// Basic I/O Test 1 //////////
//SW=10'h3;
//
//#2 Run=1'b0;
//#2 Run=1'b1;
//
//#55 SW=10'h7;
//#55 SW=10'h2;
//#55 SW=10'h7;

//#75 SW=10'h4;
//#75 SW=10'h1;
//#75 SW=10'h5;
//////////////////////////////////////

////////// Basic I/O Test 2 //////////
SW=10'h6;

#2 Run=1'b0;
#2 Run=1'b1;

#70 SW=10'h4;
#5 Continue=1'b0;
#2 Continue=1'b1;

#70 SW=10'h1;
#5 Continue=1'b0;
#2 Continue=1'b1;

#70 SW=10'h5;
#5 Continue=1'b0;
#2 Continue=1'b1;

//#75 SW=10'h4;
//#75 SW=10'h1;
//#75 SW=10'h5;
//////////////////////////////////////

////////// Self-Modifying Code Test //////////
//SW=10'hB;
//
//#2 Run=1'b0;
//#2 Run=1'b1;
//
//#150 Continue=1'b0;
//#2 Continue=1'b1;
//
//#150 Continue=1'b0;
//#2 Continue=1'b1;
//
//#150 Continue=1'b0;
//#2 Continue=1'b1;
//
//#150 Continue=1'b0;
//#2 Continue=1'b1;
//
//#150 Continue=1'b0;
//#2 Continue=1'b1;
//////////////////////////////////////

////////// XOR Test /////////////////
//SW=10'h14;
//
//#2 Run=1'b0;
//#2 Run=1'b1;
//
//#75 SW=10'hAA;
//#5 Continue=1'b0;
//#2 Continue=1'b1;
//
//#75 SW=10'h55;
//#5 Continue=1'b0;
//#2 Continue=1'b1;
//
//#200 Continue=1'b0;
//#2 Continue=1'b1;
//
//#50 SW=10'hAE;
//#5 Continue=1'b0;
//#2 Continue=1'b1;
//
//#75 SW=10'h67;
//#5 Continue=1'b0;
//#2 Continue=1'b1;
//
//#200 Continue=1'b0;
//#2 Continue=1'b1;
//////////////////////////////////////

////////// Multiplication Test ///////
//SW=10'h31;
//
//#2 Run=1'b0;
//#2 Run=1'b1;
//
//#300 SW=10'h23;
//#5 Continue=1'b0;
//#2 Continue=1'b1;
//
//#300 SW=10'hA;
//#5 Continue=1'b0;
//#2 Continue=1'b1;
//
//#500 Continue=1'b0;
//#2 Continue=1'b1;
//////////////////////////////////////

////////// Sort Test ///////
//SW=10'h5A;
//
//#2 Run=1'b0;
//#2 Run=1'b1;
//
//#300 SW=10'h2;
//#5 Continue=1'b0;
//#2 Continue=1'b1;
//////////////////////////////////////

end
endmodule