module vga_controller (
	input clk,
	input rst,
	
	input [23:0] vga_data,
	input [14:0] vga_write_address,
	
	output wire vga_blank,
	output wire vga_b,
	output wire	vga_r,
	output wire	vga_g,
	output wire	vga_clk,
	output wire	vga_hs,
	output wire	vga_vs,
	output wire	vga_sync
);

wire clk_25;

wire [9:0] x, y;
wire [7:0] red, green, blue;

wire [14:0] read_address;

wire disp_done;
wire write_done;

clock_divider clock(

	.clk(clk),
	.rst(rst),
	.clk_25(clk_25)

);


vga_driver driver(

	.r(red),
	.g(green),
	.b(blue),
	.clk_25(clk_25),
	.rst(rst),
	
	.x(x),
	.y(y),
	.disp_done(disp_done),
	
	.vga_blank(vga_blank),
	.vga_b(vga_b),
	.vga_r(vga_r),
	.vga_g(vga_g),
	.vga_clk(vga_clk),
	.vga_hs(vga_hs),
	.vga_vs(vga_vs),
	.vga_sync_n(vga_sync)
	
);

//translate x and y outputs to ram address values
assign read_address = 160 * (x >>> 2) + y >>> 2;


double_buffer buffer(

	.clk(clk),
	.rst(rst),
	
	.write_done(write_done),
	.disp_done(disp_done),
	
	.write_address(vga_write_address),
	.write_data(vga_data),
	
	.read_address(read_address),
	.read_data({red, green, blue})
	
);


endmodule
