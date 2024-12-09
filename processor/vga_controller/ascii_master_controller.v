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
reg vga_write_done;
wire buffer_switched;

reg [12:0] vga_write_address;
reg [31:0] vga_data;

vga_controller controller(
	.clk(clk),
	.rst(rst),
	
	.vga_write_address(vga_write_address),
	.vga_data(vga_data),
	
	.vga_write_done(vga_write_done),
	.switch_buffer(buffer_switched),
	
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
reg [12:0]master_read_address; 
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
//assign LEDR[3] = vga_write_done;

//-----------------CODE-----------------

assign master_write_en = ascii_write_en;
assign master_data_in = ascii_input;
assign master_write_address = ascii_write_address;

//writing master to current buffer
reg [2:0]WRITE_S, WRITE_NS;
reg [12:0]address_count;
reg [3:0]delay_count;

parameter START = 4'd0,
			WRITE_DONE = 4'd1,
			WAIT_SWITCH = 4'd2,
			WRITE_START = 4'd3,
			CHECK = 4'd4,
			DELAY	= 4'd5,
			ITERATE =  4'd6,
			ERROR = 4'd7;

always @ (*)
begin
	vga_write_address = address_count;
	master_read_address = address_count;
	vga_data = master_data_out;
end

always @ (posedge clk or negedge rst)
begin
	if (rst == 1'b0)
		WRITE_S <= START;
	else
		WRITE_S <= WRITE_NS;
end

always @ (*)
begin
	case (WRITE_S)
	
		START: WRITE_NS = WRITE_DONE;
		
		WRITE_DONE: WRITE_NS = WAIT_SWITCH;
		
		WAIT_SWITCH:
		begin
			if (buffer_switched == 1'b1)
				WRITE_NS = WRITE_START;
			else 
				WRITE_NS = WAIT_SWITCH;
		end
		
		WRITE_START: WRITE_NS = CHECK;
		
		CHECK:
		begin
			if (address_count == 13'd4799)
				WRITE_NS = WRITE_DONE;
			else 
				WRITE_NS = DELAY;
		end
		
		DELAY: 
		begin
			if (delay_count == 4'd7)
				WRITE_NS = ITERATE;
			else 
				WRITE_NS = DELAY;
		end
		
		ITERATE: WRITE_NS = CHECK;
		
	endcase
end

always @ (posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		address_count <= 13'd0;
		delay_count <= 4'b0;
		vga_write_done <= 1'b0;
	end
	else
	begin
		case (WRITE_S)
			WRITE_DONE: vga_write_done <= 1'b1;
			WAIT_SWITCH: 
			begin
				address_count <= 13'd0;
				delay_count <= 4'b0;
			end
			WRITE_START: vga_write_done <= 1'b0;
			DELAY: delay_count <= delay_count + 4'd1;
			ITERATE: address_count <= address_count + 13'd1;
		endcase
	end
end
endmodule