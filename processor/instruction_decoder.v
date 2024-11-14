module instruction_decoder #(
  parameter WORD_SIZE = 32
) (
  input [WORD_SIZE-1:0] instruction,
  output reg [6:0] opcode,
  output reg [4:0] rd,
  output reg [4:0] rs1,
  output reg [4:0] rs2,
  output reg rs2_use_imm,
  output reg [3:0] alu_op,
  output reg [WORD_SIZE-1:0] immediate
);

parameter RTYPE = 7'b0110011;
parameter ITYPE = 7'b0010011;

assign opcode = instruction[6:0];

wire [WORD_SIZE-1:0] sign_extended_imm_12;
sign_extender #(WORD_SIZE, 'd12) imm_12(instruction[31:20], sign_extended_imm_12);

always @(*) begin
  case (opcode)
    RTYPE: begin
      rd = instruction[11:7];
      alu_op = {instruction[30], instruction[14:12]};
      rs1 = instruction[19:15];
      rs2 = instruction[24:20];
      rs2_use_imm = 1'b0;
      immediate = 'b0;
    end
    ITYPE: begin
      rd = instruction[11:7];
      alu_op = {1'b0, instruction[14:12]};
      rs1 = instruction[19:15];
      rs2_use_imm = 1'b1;
      immediate = sign_extended_imm_12;
    end
    default: begin
      rd = 5'b0;
      rs1 = 5'b0;
      rs2 = 5'b0;
      rs2_use_imm = 1'b0;
      alu_op = 4'b0;
      immediate = 'b0;
    end
  endcase
  
end

  
endmodule