module Register #(
  REG_NUM,
  WORD_SIZE,
) (
  input clk,
  input rst,
  input en,
  input [WORD_SIZE-1:0] in,
  output reg [WORD_SIZE-1:0] out
);
  always @ (posedge clk or negedge rst) begin
		if(rst == 1'b0)
			out <= {WORD_SIZE{1'b0}};
		else if(en == 1'b1 && REG_NUM != 0)
			out <= in;
	end
endmodule