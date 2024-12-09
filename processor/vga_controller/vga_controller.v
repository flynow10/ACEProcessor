module vga_controller (

	input clk,
	input rst,
	
	input [12:0] vga_write_address,
	input [31:0] vga_data,
	
	input vga_write_done,
	output reg switch_buffer,
	
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
	input [9:0]LEDR
	
);

/*-----------------DEBUG-----------------*/
/*
always @ (*)
begin
	red = 8'b11111111;
	blue = 8'b11111111;
	green = 8'b11111111;
end
*/


/*
reg [9:0]ROM_OFFSET;

always @ (*)
begin
	ROM_OFFSET = SW[5:3];
end
*/
/*-----------------CODE-----------------*/

wire clk_25;

wire [9:0] next_x, next_y;
reg [7:0] red, green, blue;

reg [12:0] ascii_buffer_address;
wire [31:0] ascii_buffer_data;

reg [9:0]ascii_rom_address;
reg [7:0]current_pixel;
wire [7:0]ascii_rom_data;

wire disp_done;

clock_divider clock(
	
	.clk(clk),
	.rst(rst),
	.clk_25(clk_25)

);


vga_driver driver(
	
	//clk and rst
	.clk_25(clk_25),
	.rst(rst),
	
	//inputs
	.r(red),
	.g(green),
	.b(blue),
	
	//control outputs
	.x(next_x),
	.y(next_y),
	.disp_done(disp_done),
	
	//outputs
	.vga_blank(vga_blank),
	.vga_b(vga_b),
	.vga_r(vga_r),
	.vga_g(vga_g),
	.vga_clk(vga_clk),
	.vga_hs(vga_hs),
	.vga_vs(vga_vs),
	.vga_sync_n(vga_sync),
	
	/*-----------------DEBUG-----------------*/
	.SW(SW),
	.KEY(KEY),
	.LEDR(LEDR[9:0])
);


double_buffer buffer(
	
	//clk and rst
	.clk(clk),
	.rst(rst),
	
	//control inputs
	.switch_buffer(switch_buffer),
	
	//write buffer
	.write_address(vga_write_address),
	.write_data(vga_data),
	
	//outputs
	.read_address(ascii_buffer_address),
	.read_data(ascii_buffer_data),
	
	/*-----------------DEBUG-----------------*/
	.SW(SW),
	.KEY(KEY),
	.LEDR(LEDR[9:0])
	
);

Char_ROM rom1 (
	
	.address(ascii_rom_address),
	.clock(clk),
	.q(ascii_rom_data)
	
);

//combinational ram control

always @ (*)
begin
	ascii_buffer_address = 80 * (next_y >> 3) + (next_x >> 3);
	
	ascii_rom_address = (ascii_buffer_data[31:24] * 8) + (next_y % 8);
	current_pixel = ((ascii_rom_data >> ((next_x - 10'd2) % 8)) & 1'b1);
	
	if (current_pixel == 1'b1)
		{red, green, blue} = ascii_buffer_data[23:0];
	else
		{red, green, blue} = 24'b0;
end



//FSM for switch buffer

reg [1:0]SWITCH_S, SWITCH_NS;
reg [3:0]count;

parameter WAIT_SIGNAL = 2'd0,
			SWITCH_BUFFER = 2'd1,
			RESET = 2'd2,
			DELAY = 2'd3;

always @ (posedge clk or negedge rst)
begin
	if (rst == 1'b0)
		SWITCH_S <= WAIT_SIGNAL;
	else 
		SWITCH_S <= SWITCH_NS;
end

always @ (*)
begin
	case (SWITCH_S)
		WAIT_SIGNAL: SWITCH_NS = (disp_done == 1'b1 && vga_write_done == 1'b1)?SWITCH_BUFFER:WAIT_SIGNAL;
		SWITCH_BUFFER: SWITCH_NS = RESET;
		RESET: SWITCH_NS = DELAY;
		DELAY: SWITCH_NS = (count == 4'd15)?WAIT_SIGNAL:DELAY;
	endcase
end

always @ (posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		switch_buffer <= 1'b0;
	end
	else
	begin
		case (SWITCH_S)
			WAIT_SIGNAL: count <= 4'd0;
			SWITCH_BUFFER: switch_buffer <= 1'b1;
			RESET: switch_buffer <= 1'b0;
			DELAY: count <= count + 4'd1;
		endcase
	end
end
endmodule
