`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:07:18 10/26/2016
// Design Name:   Alu
// Module Name:   D:/Spartan-3e/Lab3/alutest.v
// Project Name:  Lab3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Alu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module alutest;

	// Inputs
	reg [31:0] i_r;
	reg [31:0] i_s;
	reg [3:0] i_aluc;

	// Outputs
	wire [31:0] o_alu;

	// Instantiate the Unit Under Test (UUT)
	Alu uut (
		.i_r(i_r), 
		.i_s(i_s), 
		.i_aluc(i_aluc), 
		.o_alu(o_alu)
	);

	initial begin
		// Initialize Inputs
		i_r = 32'h87654321;
		i_s = 32'd5;
		i_aluc = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		// Add stimulus here
		i_aluc = 4'b1000;
		#100;
		i_aluc = 4'b1100;
		#100;
		i_aluc = 4'b1101;
		#100;
		i_aluc = 4'b1111;
	end
      
endmodule

