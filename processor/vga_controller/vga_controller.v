module vga_controller (

	input clk,
	input rst,

	output clk_25

);

clock_divider vga_clk(clk, rst, clk_25);


endmodule