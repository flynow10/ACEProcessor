module six_hex_vals (
input [31:0]val,
output [6:0]seg7_dig0,
output [6:0]seg7_dig1,
output [6:0]seg7_dig2,
output [6:0]seg7_dig3,
output [6:0]seg7_dig4,
output [6:0]seg7_dig5,
output overflow
);

assign overflow = val > 32'hffffff;

/* instantiate the modules for each of the seven seg decoders including the negative one */
seven_segment dig0(val[3:0], seg7_dig0);
seven_segment dig1(val[7:4], seg7_dig1);
seven_segment dig2(val[11:8], seg7_dig2);
seven_segment dig3(val[15:12], seg7_dig3);
seven_segment dig4(val[19:16], seg7_dig4);
seven_segment dig5(val[23:20], seg7_dig5);
endmodule