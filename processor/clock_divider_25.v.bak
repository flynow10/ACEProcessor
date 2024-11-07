module clock_divider_25 (
	input clock,
	output clock25
);

//clock divider
always @ (posedge clock) 
begin
	if (clock25 == 1'b0)
	begin
		clock25 <= 1'b1;
	end
	else
	begin
		clock25 <= 1'b0;
	end
end

endmodule