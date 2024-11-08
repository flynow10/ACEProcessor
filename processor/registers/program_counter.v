module program_counter #(
  parameter WORD_SIZE = 32
) (
  input clk,
  input rst,
  input en,
  input wren,
  input [WORD_SIZE-1:0] new_addr,
  output reg [WORD_SIZE-1:0] addr
);
  always @(posedge clk or negedge rst) begin
    if(rst == 1'b0)
      addr <= 0;
    else if(wren == 1'b1)
      addr <= new_addr;
    else if(en == 1'b1)
      addr <= addr + 'd1;
  end
endmodule