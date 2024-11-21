module five_decimal_vals_w_neg (
input [31:0]val,
output [6:0]seg7_neg_sign,
output [6:0]seg7_dig0,
output [6:0]seg7_dig1,
output [6:0]seg7_dig2,
output [6:0]seg7_dig3,
output [6:0]seg7_dig4,
output reg overflow
);

reg [3:0] result_one_digit;
reg [3:0] result_ten_digit;
reg [3:0] result_hundred_digit;
reg [3:0] result_thousands_digit;
reg [3:0] result_ten_thousands_digit;
reg result_is_negative;

reg [7:0]twos_comp;

/* convert the binary value into 4 signals */
always @(*)
begin
	  result_is_negative = val[7];
	  twos_comp = val[7] ? (~val + 1): val;
		overflow = twos_comp > 99999;
	  
	  result_one_digit = twos_comp % 10;
	  result_ten_digit = (twos_comp / 10) % 10;
	  result_hundred_digit = (twos_comp / 100) % 10;
	  result_thousands_digit = (twos_comp / 1000) % 10;
	  result_ten_thousands_digit = (twos_comp / 10000) % 10;
end

/* instantiate the modules for each of the seven seg decoders including the negative one */
seven_segment dig0(result_one_digit, seg7_dig0);
seven_segment dig1(result_ten_digit, seg7_dig1);
seven_segment dig2(result_hundred_digit, seg7_dig2);
seven_segment dig3(result_thousands_digit, seg7_dig3);
seven_segment dig4(result_ten_thousands_digit, seg7_dig4);
seven_segment_negative neg(result_is_negative, seg7_neg_sign);

endmodule