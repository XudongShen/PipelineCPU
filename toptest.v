`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:04:46 10/26/2016
// Design Name:   top
// Module Name:   D:/Spartan-3e/Lab3/toptest.v
// Project Name:  Lab3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module toptest;

	// Inputs
	reg CCLK;
	reg BTN3;
	reg BTN2;
	reg [3:0] SW;

	// Outputs
	wire LED;
	wire LCDE;
	wire LCDRS;
	wire LCDRW;
	wire [3:0] LCDDAT;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.CCLK(CCLK), 
		.BTN3(BTN3), 
		.BTN2(BTN2), 
		.SW(SW), 
		.LED(LED), 
		.LCDE(LCDE), 
		.LCDRS(LCDRS), 
		.LCDRW(LCDRW), 
		.LCDDAT(LCDDAT)
	);

	initial forever begin
		#5;
		CCLK = ~CCLK;
	end
	
	initial forever begin
		#50;
		BTN3 = 1;
		#20;
		BTN3 = 0;
	end	

	initial begin
		// Initialize Inputs
		CCLK = 0;
		BTN3 = 0;
		BTN2 = 0;
		SW = 0;
		#10;
		BTN2 = 1;
		#10;
		BTN2 = 0;

		// Wait 100 ns for global reset to finish
		#100;

		// Add stimulus here
	end
      
endmodule

