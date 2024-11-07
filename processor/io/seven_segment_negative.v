module seven_segment_negative(i,o);

input i;
output reg [6:0]o; // a, b, c, d, e, f, g

always @(*) begin
	o = 7'b1111111;
	o[6] = ~i;
end


endmodule