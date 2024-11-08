module clock_divider(

	input clk, rst, 
	output reg clk_25
	
	);
	
	always @ (posedge clk or negedge rst)
	begin
		if (rst == 1'b0)
			clk_25 <= 1'b0;
		else 
			clk_25 <= ~clk_25;
	end
endmodule