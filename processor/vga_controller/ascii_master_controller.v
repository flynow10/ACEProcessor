module ascii_master_controller (

	input clk,
	input rst,
	
	input ascii_write_en,
	input [31:0]ascii_input,
	input [12:0]ascii_write_address,
	
	output wire vga_blank,
	output wire [7:0]vga_b,
	output wire	[7:0]vga_r,
	output wire	[7:0]vga_g,
	output wire	vga_clk,
	output wire	vga_hs,
	output wire	vga_vs,
	output wire	vga_sync,

	/*-----------------DEBUG-----------------*/
	input [9:0]SW,
	input [3:0]KEY,
	output [9:0]LEDR
);


//vga controller declaration
wire [12:0] vga_read_address;
wire [31:0] vga_data;

vga_controller controller(
	.clk(clk),
	.rst(rst),
	
	.ascii_buffer_address(vga_read_address),
	.ascii_buffer_data(vga_data),
	
	.vga_blank(vga_blank),
	.vga_b(vga_b),
	.vga_r(vga_r),
	.vga_g(vga_g),
	.vga_clk(vga_clk),
	.vga_hs(vga_hs),
	.vga_vs(vga_vs),
	.vga_sync(vga_sync),
	
	/*-----------------DEBUG-----------------*/
	.SW(SW[9:0]),
	.KEY(KEY[3:0]),
	.LEDR(LEDR[9:0])
);


//master ram declaration
wire [12:0]master_read_address;
wire [12:0]master_write_address;
wire [31:0]master_data_out;
wire [31:0]master_data_in;
wire master_write_en;

ascii_master master (
	.rdaddress(master_read_address),
	.wraddress(master_write_address),
	.clock(clk),
	.data(master_data_in),
	.wren(master_write_en),
	.q(master_data_out)
);

//-----------------DEBUG-----------------
//wire [3:0]DELAY_TIME;

//assign DELAY_TIME = SW[3:0];

//wire test_clk;
//assign test_clk = KEY[3];

//assign LEDR[2:0] = WRITE_S;

//-----------------CODE-----------------

assign master_read_address = vga_read_address;
assign master_write_en = ascii_write_en;
assign master_data_in = ascii_input;
assign master_write_address = ascii_write_address;
assign vga_data = master_data_out;
endmodule