module double_buffer (

	//clock and reset
	input clk,
	input rst,
	
	//done signals
	input write_done,
	input disp_done,
	
	//write buffer
	input [14:0] write_address,
	input [23:0] write_data,
	
	//read buffer
	input [14:0] read_address,
	output reg [23:0] read_data
	
);


//individual buffer read/write
reg [14:0] address_1, address_2;
reg [23:0] data_in_1, data_in_2;
reg wren_1, wren_2;
wire [23:0] data_out_1, data_out_2;

//initializing buffers
buffer_1 buffer1(
	.address(address_1),
	.clock(clk),
	.data(data_in_1),
	.wren(wren_1),
	.q(data_out_1)
);

buffer_2 buffer2(
	.address(address_2),
	.clock(clk),
	.data(data_in_2),
	.wren(wren_2),
	.q(data_out_2)
);

reg S, NS;

parameter B1_DISP_B2_WRITE = 1'b0,
			B2_DISP_B1_WRITE = 1'b1;

always @ (posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		S <= B1_DISP_B2_WRITE;
	end
	else 
	begin
		S <= NS;
	end
end

always @ (*)
begin
	case (S)
		B1_DISP_B2_WRITE: 
		begin
			if (write_done == 1'b1 && disp_done == 1'b1)
				NS = B2_DISP_B1_WRITE;
			else
				NS = B1_DISP_B2_WRITE;
		end
		B2_DISP_B1_WRITE:
		begin
			if (write_done == 1'b1 && disp_done == 1'b1)
				NS = B1_DISP_B2_WRITE;
			else
				NS = B2_DISP_B1_WRITE;
		end
	endcase
end

always @ (posedge clk or negedge rst)
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


endmodule

