module display_pixel (
	input [7:0]r,
	input [7:0]g,
	input [7:0]b,
	input clk_25,
	input rst,
	
	output wire x,
	output wire y,
	
	output vga_blank,
	output [7:0]vga_b,
	output [7:0]vga_g,
	output [7:0]vga_r,
	output vga_clk,
	output vga_hs,
	output vga_vs,
	output vga_sync_n
	
);


reg [7:0]hs,vs,hns,vns;
reg [9:0]hcount, vcount;
reg hblank, vblank;

assign vga_r = r;
assign vga_b = b;
assign vga_g = g;
assign vga_blank = hblank | vblank;
assign vga_sync_n = 1'b0;
assign vga_clk = clk_25;

assign x = (hblank == 1'd1)?hcount:10'd0;
assign y = (vblank == 1'd1)?vcount:10'd0;


parameter 
			HDISP = 8'd0,
			HSYNC = 8'd1,
			HFRONT = 8'd2,
			HBACK = 8'd3,
			
			VDISP = 8'd7,
			VSYNC = 8'd8,
			VFRONT = 8'd9,
			VBACK = 8'd10,
			
			ERROR = 8'b11111111;
			
parameter
			HDISP_TIME = 10'd640,
			HFRONT_TIME = 10'd16,
			HSYNC_TIME = 10'd96,
			HBACK_TIME = 10'd48,
			
			VDISP_TIME = 10'd480,
			VFRONT_TIME = 10'd10,
			VSYNC_TIME = 10'd2,
			VBACK_TIME = 10'd33;
			
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
			if (hcount < HDISP_TIME)
				hns = HDISP;
			else
				hns = HFRONT;
		end
		HFRONT:
		begin
			if (hcount < HFRONT_TIME)
				hns = HFRONT;
			else
				hns = HSYNC;
		end
		HSYNC:
		begin
			if (hcount < HSYNC_TIME)
				hns = HSYNC;
			else
				hns = HBACK;
		end
		HBACK:
		begin
			if (hcount < HBACK_TIME)
				hns = HBACK;
			else
				hns = HDISP;
		end
	endcase
	case (vs)
		VDISP:
		begin
			if (vcount < VDISP_TIME)
				vns = VDISP;
			else
				vns = VFRONT;
		end
		VFRONT:
		begin
			if (vcount < VFRONT_TIME)
				vns = VFRONT;
			else
				vns = VSYNC;
		end
		VSYNC:
		begin
			if (vcount < VSYNC_TIME)
				vns = VSYNC;
			else
				vns = VBACK;
		end
		VBACK:
		begin
			if (vcount < VBACK_TIME)
				vns = VBACK;
			else
				vns = VDISP;
		end
	endcase
end

always @ (posedge clk_25 or negedge rst)
begin
	if (rst == 1'b0)
	begin
		hcount <= 10'd0;
		vcount <= 10'd0;
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