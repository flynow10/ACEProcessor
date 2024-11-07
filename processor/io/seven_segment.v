module seven_segment(
	input wire[3:0]i,
	output reg[6:0]HEX0
);

// HEX out - rewire DE1
//  ---0---
// |       |
// 5       1
// |       |
//  ---6---
// |       |
// 4       2
// |       |
//  ---3---
always @(*)
begin
	case (i)	    // abcdefg
			4'b0: HEX0 = 7'b1000000;
			4'b1: HEX0 = 7'b1111001;
			4'b10: HEX0 = 7'b0100100;
			4'b11: HEX0 = 7'b0110000;
			4'b100: HEX0 = 7'b0011001;
			4'b101: HEX0 = 7'b0010010;
			4'b110: HEX0 = 7'b0000010;
			4'b111: HEX0 = 7'b1111000;
			4'b1000: HEX0 = 7'b0000000;
			4'b1001: HEX0 = 7'b0011000;
			4'b1010: HEX0 = 7'b0001000;
			4'b1011: HEX0 = 7'b0000011;
			4'b1100: HEX0 = 7'b1000110;
			4'b1101: HEX0 = 7'b0100001;
			4'b1110: HEX0 = 7'b0000110;
			4'b1111: HEX0 = 7'b0001110;
	endcase
end


endmodule