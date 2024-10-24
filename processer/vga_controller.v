module vga_controller (
	input [8:0]RGB,
	input clk,
	input rst,
	
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


parameter HDISP = 8'b00000000,
			HSYNC = 8'b00000001,
			HFRONT = 8'b00000010,
			HBACK = 8'b00000011,
			VDISP = 8'b00000100,
			VSYNC = 8'b00000101,
			VFRONT = 8'b00000111,
			VBACK = 8'b00001000,
			ERROR = 8'b11111111;
			
always @ (posedge clk25 or negedge rst)
begin
	if (rst == 1'b0)
	begin
		vs <=
		hs <= 
	end
end

always @ (posedge clk25 or negedge rst)
begin
	case (hs)
	
	endcase
	case (vs)
	
	endcase
end

endmodule