module double_buffer (

	//clock and reset
	input clk,
	input rst,
	
	//control signals
	input en,
	input switch_buffer,
	
	//write buffer
	input [12:0] write_address,
	input [31:0] write_data,
	
	//read buffer
	input [12:0] read_address,
	output reg [31:0] read_data,
	
	/*-----------------DEBUG-----------------*/
	input [9:0]SW,
	input [3:0]KEY,
	input [9:0]LEDR
	
);

/*-----------------DEBUG-----------------*/



/*-----------------CODE-----------------*/
//individual buffer read/write
reg [12:0] address_1, address_2;
reg [31:0] data_in_1, data_in_2;
reg wren_1, wren_2;
wire [31:0] data_out_1, data_out_2;

//initializing buffers
ascii_buffer_1 buffer1(
	.address(address_1),
	.clock(clk),
	.data(data_in_1),
	.wren(wren_1),
	//.wren(1'b0),
	.q(data_out_1)
);

ascii_buffer_2 buffer2(
	.address(address_2),
	.clock(clk),
	.data(data_in_2),
	.wren(wren_2),
	//.wren(1'b0),
	.q(data_out_2)
);

reg [1:0]S, NS;

parameter START = 2'd0,
			B1_DISP_B2_WRITE = 2'd1,
			B2_DISP_B1_WRITE = 2'd2,
			ERROR = 2'd3;

always @ (posedge clk or negedge rst)
begin
	if (rst == 1'b0)
		S <= START;
	else 
		S <= NS;
end

always @ (*)
begin
	case (S)
		START: NS = B1_DISP_B2_WRITE;
		B1_DISP_B2_WRITE: 
		begin
			if (switch_buffer == 1'b1)
				NS = B2_DISP_B1_WRITE;
			else
				NS = B1_DISP_B2_WRITE;
		end
		B2_DISP_B1_WRITE:
		begin
			if (switch_buffer == 1'b1)
				NS = B1_DISP_B2_WRITE;
			else
				NS = B2_DISP_B1_WRITE;
		end
		default: NS = ERROR;
	endcase
end

always @ (posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		wren_1 <= 1'b0;
		wren_2 <= 1'b0;
	end
	else
	begin
		case (S)
			B1_DISP_B2_WRITE:
			begin
				address_1 <= read_address;
				read_data <= data_out_1;
				wren_1 <= 1'b0;

				address_2 <= write_address;
				data_in_2 <= write_data;
				wren_2 <= 1'b1;
			end
			B2_DISP_B1_WRITE:
			begin
				address_2 <= read_address;
				read_data <= data_out_2;
				wren_2 <= 1'b0;

				address_1 <= write_address;
				data_in_1 <= write_data;
				wren_1 <= 1'b1;
			end
		endcase
	end
end


endmodule

