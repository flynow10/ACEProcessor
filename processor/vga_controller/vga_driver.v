module vga_driver (
	input [7:0]r,
	input [7:0]g,
	input [7:0]b,
	input clk_25,
	input rst,
	
	output wire [9:0]x,
	output wire [9:0]y,
	output reg disp_done,
	
	output wire vga_blank,
	output wire [7:0]vga_b,
	output wire [7:0]vga_g,
	output wire [7:0]vga_r,
	output wire vga_clk,
	output reg vga_hs,
	output reg vga_vs,
	output wire vga_sync_n,
	
	/*-----------------DEBUG-----------------*/
	input [9:0]SW,
	input [3:0]KEY,
	input [9:0]LEDR
	
);

/*-----------------DECLARATIONS AND ASSIGNMENTS-----------------*/

reg [1:0]vs, hs;
reg [1:0]hns, vns;
reg [9:0]hcount, vcount;
reg hblank, vblank;

assign vga_r = r;
assign vga_b = b;
assign vga_g = g;
assign vga_blank = hblank & vblank;
assign vga_sync_n = 1'b1;
assign vga_clk = clk_25;

assign x = (hblank == 1'd1)?(hcount):(10'd0);
assign y = (vblank == 1'd1)?(vcount):(10'd0);

parameter 
			HDISP = 2'd0,
			HFRONT = 2'd1,
			HSYNC = 2'd2,
			HBACK = 2'd3,
			
			VDISP = 2'd0,
			VFRONT = 2'd1,
			VSYNC =	2'd2,
			VBACK = 2'd3;


parameter
			HDISP_TIME = 10'd639,
			HFRONT_TIME = 10'd15,
			HSYNC_TIME = 10'd95,
			HBACK_TIME = 10'd47,
			
			VDISP_TIME = 10'd479,
			VFRONT_TIME = 10'd9,
			VSYNC_TIME = 10'd1,
			VBACK_TIME = 10'd32;


	
/*-----------------DEBUG-----------------*/

/*		
parameter
			HDISP_TIME = 10'd5,
			HFRONT_TIME = 10'd5,
			HSYNC_TIME = 10'd5,
			HBACK_TIME = 10'd5,
			
			VDISP_TIME = 10'd5,  
			VFRONT_TIME = 10'd5,
			VSYNC_TIME = 10'd5,
			VBACK_TIME = 10'd5;
*/	
/*
reg [9:0]X_OFFSET;

always @ (*)
begin
	X_OFFSET[2:0] = SW[2:0];
end
*/
/*-----------------CODE-----------------*/
			
always @ (posedge clk_25 or negedge rst)
begin
	if (rst == 1'b0)
	begin
		vs <= VDISP;
		hs <= HDISP;
	end
	else
	begin
		vs <= vns;
		hs <= hns;
	end
end

always @ (*)
begin
	case (hs)
		HDISP:
		begin
			if (hcount == HDISP_TIME)
				hns = HFRONT;
			else
				hns = HDISP;
		end
		HFRONT:
		begin
			if (hcount == HFRONT_TIME)
				hns = HSYNC;
			else
				hns = HFRONT;
		end
		HSYNC:
		begin
			if (hcount == HSYNC_TIME)
				hns = HBACK;
			else
				hns = HSYNC;
		end
		HBACK:
		begin
			if (hcount == HBACK_TIME)
				hns = HDISP;
			else
				hns = HBACK;
		end
	endcase
	case (vs)
		VDISP:
		begin
			if (vcount == VDISP_TIME)
				vns = VFRONT;
			else
				vns = VDISP;
		end
		VFRONT:
		begin
			if (vcount == VFRONT_TIME)
				vns = VSYNC;
			else
				vns = VFRONT;
		end
		VSYNC:
		begin
			if (vcount == VSYNC_TIME)
				vns = VBACK;
			else
				vns = VSYNC;
		end
		VBACK:
		begin
			if (vcount == VBACK_TIME)
				vns = VDISP;
			else
				vns = VBACK;
		end
	endcase
end

always @ (posedge clk_25 or negedge rst)
begin
	if (rst == 1'b0)
	begin
		hcount <= 10'd0;
		vcount <= 10'd0;
		vga_hs <= 1'd1;
		vga_vs <= 1'd1;
		hblank <= 1'd1;
		vblank <= 1'd1;
	end
	else
	begin
		case (hs)
			HDISP: 
			begin
				hblank <= 1'b1;
				vga_hs <= 1'b1;
				if (hcount == HDISP_TIME)
					hcount <= 10'd0;
				else
					hcount <= hcount + 1'b1;
			end
			HFRONT: 
			begin
				hblank <= 1'b0;
				vga_hs <= 1'b1;
				if (hcount == HFRONT_TIME)
					hcount <= 10'd0;
				else
					hcount <= hcount + 1'b1;
			end
			HSYNC:
			begin
				hblank <= 1'b0;
				vga_hs <= 1'b0;
				if (hcount == HSYNC_TIME)
					hcount <= 10'd0;
				else
					hcount <= hcount + 1'b1;
			end
			HBACK:
			begin
				hblank <= 1'b0;
				vga_hs <= 1'b1;
				if (hcount == HBACK_TIME)
				begin
					hcount <= 10'd0;
					vcount <= vcount + 1'b1;
				end
				else
					hcount <= hcount + 1'b1;
			end
		endcase
		case (vs)
			VDISP:
			begin
				vblank <= 1'd1;
				vga_vs <= 1'd1;
				if (vcount == VDISP_TIME)
					vcount <= 10'd0;
			end
			VFRONT:
			begin
			
				if (vcount == 10'b0)
				begin
					disp_done <= 1'b1;
				end
				else
				begin
					disp_done <= 1'b0;
				end
				
				vblank <= 1'd0;
				vga_vs <= 1'd1;
				
				if (vcount == VFRONT_TIME)
					vcount <= 10'd0;
			end
			VSYNC:
			begin
				vblank <= 1'd0;
				vga_vs <= 1'd0;
				if (vcount == VSYNC_TIME)
					vcount <= 10'd0;
			end
			VBACK:
			begin
				vblank <= 1'd0;
				vga_vs <= 1'd1;
				if (vcount == VBACK_TIME)
					vcount <= 10'd0;
			end
		endcase
	end
end
endmodule