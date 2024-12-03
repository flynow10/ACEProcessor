module register_file #(
  parameter WORD_SIZE = 32
) (
  input clk,
  input rst,
  input en,
  input [4:0] rs1,
  input [4:0] rs2,
  input [4:0] rd,
  input [WORD_SIZE - 1:0] data,
  output [WORD_SIZE - 1:0] rv1,
  output [WORD_SIZE - 1:0] rv2
);

reg [WORD_SIZE-1:0] registers [31:0];

assign rv1 = registers[rs1];
assign rv2 = registers[rs2];

always @(posedge clk or negedge rst) begin
  if(rst == 1'b0) begin
      registers[0] <= 32'd0;
      registers[1] <= 32'd0;
      registers[2] <= 32'd0;
      registers[3] <= 32'd0;
      registers[4] <= 32'd0;
      registers[5] <= 32'd0;
      registers[6] <= 32'd0;
      registers[7] <= 32'd0;
      registers[8] <= 32'd0;
      registers[9] <= 32'd0;
      registers[10] <= 32'd0;
      registers[11] <= 32'd0;
      registers[12] <= 32'd0;
      registers[13] <= 32'd0;
      registers[14] <= 32'd0;
      registers[15] <= 32'd0;
      registers[16] <= 32'd0;
      registers[17] <= 32'd0;
      registers[18] <= 32'd0;
      registers[19] <= 32'd0;
      registers[20] <= 32'd0;
      registers[21] <= 32'd0;
      registers[22] <= 32'd0;
      registers[23] <= 32'd0;
      registers[24] <= 32'd0;
      registers[25] <= 32'd0;
      registers[26] <= 32'd0;
      registers[27] <= 32'd0;
      registers[28] <= 32'd0;
      registers[29] <= 32'd0;
      registers[30] <= 32'd0;
      registers[31] <= 32'd0;
  end else if(en == 1'b1 && rd != 5'b0)
    registers[rd] <= data;
end
  
endmodule