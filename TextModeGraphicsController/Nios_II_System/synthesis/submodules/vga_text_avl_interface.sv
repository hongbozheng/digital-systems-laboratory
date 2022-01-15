/************************************************************************
Avalon-MM Interface VGA Text mode display

Register Map:
0x000-0x0257 : VRAM, 80x30 (2400 byte, 600 word) raster order (first column then row)
0x258        : control register

VRAM Format:
X->
[ 31  30-24][ 23  22-16][ 15  14-8 ][ 7    6-0 ]
[IV3][CODE3][IV2][CODE2][IV1][CODE1][IV0][CODE0]

IVn = Draw inverse glyph
CODEn = Glyph code from IBM codepage 437

Control Register Format:
[[31-25][24-21][20-17][16-13][ 12-9][ 8-5 ][ 4-1 ][   0    ] 
[[RSVD ][FGD_R][FGD_G][FGD_B][BKG_R][BKG_G][BKG_B][RESERVED]

VSYNC signal = bit which flips on every Vsync (time for new frame), used to synchronize software
BKG_R/G/B = Background color, flipped with foreground when IVn bit is set
FGD_R/G/B = Foreground color, flipped with background when Inv bit is set

************************************************************************/
`define NUM_REGS 601 //80*30 characters / 4 characters per register
`define CTRL_REG 600 //index of control register

module vga_text_avl_interface (
	// Avalon Clock Input, note this clock is also used for VGA, so this must be 50Mhz
	// We can put a clock divider here in the future to make this IP more generalizable
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,					// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,			// Avalon-MM Byte Enable
	input  logic [9:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);

logic [31:0] LOCAL_REG [`NUM_REGS]; // Registers
//put other local variables here
logic [9:0] DrawX, DrawY;
logic pixel_clk,blank;

//Declare submodules..e.g. VGA controller, ROMS, etc
vga_controller VGA_Controller(.Clk(CLK),.Reset(RESET),.hs,.vs,.pixel_clk,.blank,.sync(),.DrawX,.DrawY);
font_rom Font_Rom(.addr({Font_Index,Font_Rom_Row}),.data);

// Read and write from AVL interface to register block, note that READ waitstate = 1, so this should be in always_ff
always_ff @(posedge CLK) begin
//	if(RESET) begin
//		for(int i = 0; i < `NUM_REGS; i++) begin
//			LOCAL_REG <= 32'h0;
//		end
//	end
	if(AVL_WRITE && AVL_CS)
	begin
		case(AVL_BYTE_EN)
			4'b1111: LOCAL_REG[AVL_ADDR][31:0]  <= AVL_WRITEDATA[31:0];
			4'b1100: LOCAL_REG[AVL_ADDR][31:16] <= AVL_WRITEDATA[31:16];
			4'b0011: LOCAL_REG[AVL_ADDR][15:0]  <= AVL_WRITEDATA[15:0];
			4'b1000: LOCAL_REG[AVL_ADDR][31:24] <= AVL_WRITEDATA[31:24];
			4'b0100: LOCAL_REG[AVL_ADDR][23:16] <= AVL_WRITEDATA[23:16];
			4'b0010: LOCAL_REG[AVL_ADDR][15:8]  <= AVL_WRITEDATA[15:8];
			4'b0001: LOCAL_REG[AVL_ADDR][7:0]   <= AVL_WRITEDATA[7:0];
			default:;
		endcase
	end
	else if(AVL_READ && AVL_CS)
	begin
		AVL_READDATA[31:0] = LOCAL_REG[AVL_ADDR][31:0];
	end
end

//handle drawing (may either be combinational or sequential - or both).

logic [7:0] data;

logic [4:0] Row_Location, Register_in_Row, Font_Rom_Row;
logic [6:0] Column_Location;
logic [9:0] Register_Index;
logic [1:0] Location_in_Register;
logic [6:0] Font_Index;
logic [2:0] Font_Rom_Column;
logic Invert;


always_ff @(posedge pixel_clk)
begin
	
	if(blank == 1'b0)
	begin
		red   <= 4'h0;
		green <= 4'h0;
		blue  <= 4'h0;
	end
	else if(Invert == 1'b0)
	begin
		if(data[7-Font_Rom_Column] == 1'b1)
		begin
			red   <= LOCAL_REG[600][24:21];
			green <= LOCAL_REG[600][20:17];
			blue  <= LOCAL_REG[600][16:13];
		end
		else
		begin
			red   <= LOCAL_REG[600][12:9];
			green <= LOCAL_REG[600][ 8:5];
			blue  <= LOCAL_REG[600][ 4:1];
		end
	end
	else if(Invert == 1'b1)
	begin
		if(data[7-Font_Rom_Column] == 1'b0)
		begin
			red   <= LOCAL_REG[600][24:21];
			green <= LOCAL_REG[600][20:17];
			blue  <= LOCAL_REG[600][16:13];
		end
		else
		begin
			red   <= LOCAL_REG[600][12:9];
			green <= LOCAL_REG[600][ 8:5];
			blue  <= LOCAL_REG[600][ 4:1];
		end
	end
end

always_comb
begin
	Row_Location = DrawY>>4;
	Column_Location = DrawX>>3;
	Register_in_Row = Column_Location>>2;
	Location_in_Register = Column_Location[1:0];
	Register_Index = 20*Row_Location+Register_in_Row;
	
	Font_Rom_Row = DrawY[3:0];
	Font_Rom_Column = DrawX[2:0];
	
	if(Location_in_Register == 1'b0)
	begin
		Font_Index = LOCAL_REG[Register_Index][6:0];
		Invert = LOCAL_REG[Register_Index][7];
	end
	else if(Location_in_Register == 1'b1)
	begin
		Font_Index = LOCAL_REG[Register_Index][14:8];
		Invert = LOCAL_REG[Register_Index][15];
	end
	else if(Location_in_Register == 2'h2)
	begin
		Font_Index = LOCAL_REG[Register_Index][22:16];
		Invert = LOCAL_REG[Register_Index][23];
	end
	else
	begin
		Font_Index = LOCAL_REG[Register_Index][30:24];
		Invert = LOCAL_REG[Register_Index][31];
	end
end

//always_comb
//begin
//	if(Font_Index == 7'h28)
//		Font_Index = 7'h54;
//	else if(Font_Index == 7'h50)
//		Font_Index = 7'h68;
//	else if(Font_Index == 7'h28)
//		Font_Index = 7'h54;
//	else if(Font_Index == 7'h52)
//		Font_Index = 7'h69;
//	else if(Font_Index == 7'h66)
//		Font_Index = 7'h73;
//	else if(Font_Index == 7'h40)
//		Font_Index = 7'h00;
//	else if(Font_Index == 7'h68)
//		Font_Index = 7'h74;
//	else if(Font_Index == 7'h4A)
//		Font_Index = 7'h65;
//	else if(Font_Index == 7'h70)
//		Font_Index = 7'h78;
//	else if(Font_Index == 7'h5E)
//		Font_Index = 7'h6F;
//	else if(Font_Index == 7'h6A)
//		Font_Index = 7'h75;
//	else if(Font_Index == 7'h58)
//		Font_Index = 7'h6C;
//	else if(Font_Index == 7'h48)
//		Font_Index = 7'h64;
//	else if(Font_Index == 7'h64)
//		Font_Index = 7'h72;
//	else if(Font_Index == 7'h42)
//		Font_Index = 7'h61;
//	else if(Font_Index == 7'h6E)
//		Font_Index = 7'h77;
//	else if(Font_Index == 7'h5C)
//		Font_Index = 7'h6E;
//	else if(Font_Index == 7'h4E)
//		Font_Index = 7'h67;
//	else if(Font_Index == 7'h44)
//		Font_Index = 7'h62;
//	else if(Font_Index == 7'h02)
//		Font_Index = 7'h41;
//	else if(Font_Index == 7'h6C)
//		Font_Index = 7'h76;
//	else if(Font_Index == 7'h46)
//		Font_Index = 7'h63;
//	else if(Font_Index == 7'h5A)
//		Font_Index = 7'h6D;
//	else if(Font_Index == 7'h60)
//		Font_Index = 7'h70;
//	else if(Font_Index == 7'h4C)
//		Font_Index = 7'h66;
//	else if(Font_Index == 7'h72)
//		Font_Index = 7'h79;
//	else
//		Font_Index = 7'h00;
//end
endmodule