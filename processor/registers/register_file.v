module register_file #(
  parameter WORD_SIZE = 16
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

integer i = 0;

always @(posedge clk or negedge rst) begin
  if(rst == 1'b0)
    for (i = 0; i < 32; i ++) begin
      registers[i] <= 0;
    end
		else if(en == 1'b1 & rd != 5'b0)
			registers[rd] <= data;
end
  
endmodule