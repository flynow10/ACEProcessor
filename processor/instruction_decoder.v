module instruction_decoder #(
  parameter WORD_SIZE = 32
) (
  input [WORD_SIZE-1:0] instruction,
  output [6:0] opcode,
  output reg [4:0] rd,
  output reg [4:0] rs1,
  output reg [4:0] rs2,
  output reg rs1_use_pc,
  output reg rs2_use_imm,
  output reg [3:0] alu_op,
  output reg [WORD_SIZE-1:0] immediate,
  output reg [2:0] reg_load_size,
  output reg [1:0] mem_write_size,
  output reg mem_to_reg,
  output reg [2:0] branch_condition,
  output reg branch,
  output reg jump,
  output reg jal_or_jalr,
  output reg decode_error
);

parameter ARITH_REG = 7'b0110011,
          ARITH_IMM = 7'b0010011,
          LOAD = 7'b0000011,
          STORE = 7'b0100011,
          LUI = 7'b0110111,
          AUIPC = 7'b0010111,
          BRANCH = 7'b1100011,
          JAL = 7'b1101111,
          JALR = 7'b1100111,
          ECALL = 7'b1110011;

assign opcode = instruction[6:0];

wire [WORD_SIZE-1:0] sign_extended_imm_12;
sign_extender #(WORD_SIZE, 'd12) imm_12(instruction[31:20], sign_extended_imm_12);

wire [WORD_SIZE-1:0] sign_extended_imm_12_store;
sign_extender #(WORD_SIZE, 'd12) imm_s12({instruction[31:25], instruction[11:7]}, sign_extended_imm_12_store);

wire [WORD_SIZE-1:0] sign_extended_imm_branch_offset;
sign_extender #(WORD_SIZE, 'd13) imm_branch({instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}, sign_extended_imm_branch_offset);

wire [WORD_SIZE-1:0] sign_extended_imm_jal_offset;
sign_extender #(WORD_SIZE, 'd21) imm_jal({instruction[31],instruction[19:12], instruction[20],instruction[30:21], 1'b0}, sign_extended_imm_jal_offset);

always @(*) begin
  rd = instruction[11:7];
  alu_op = 4'b0;
  rs1 = instruction[19:15];
  rs2 = instruction[24:20];
  rs1_use_pc = 1'b0;
  rs2_use_imm = 1'b0;
  immediate = {WORD_SIZE{1'b0}};
  reg_load_size = 3'b010;
  mem_write_size = 2'b0;
  mem_to_reg = 1'b0;
  branch_condition = 3'b0;
  branch = 1'b0;
  jump = 1'b0;
  jal_or_jalr = 1'b0;
  decode_error = 1'b0;
  case (opcode)
    ARITH_REG: begin
      alu_op = {instruction[30], instruction[14:12]};
    end
    LOAD: begin
      rs2 = 5'b0;
      rs2_use_imm = 1'b1;
      mem_to_reg = 1'b1;
      immediate = sign_extended_imm_12;
      reg_load_size = instruction[14:12];
    end
    STORE: begin
      rd = 5'b0;
      rs2_use_imm = 1'b1;
      immediate = sign_extended_imm_12_store;
      case (instruction[14:12])
        3'b000: mem_write_size = 2'b1;
        3'b001: mem_write_size = 2'b10;
        3'b010: mem_write_size = 2'b11;
        default: decode_error = 1'b1;
      endcase
    end
    AUIPC, LUI: begin
      rs1 = 5'b0;
      rs2_use_imm = 1'b1;
      immediate = {instruction[31:12], 12'b0};
      rs1_use_pc = opcode == AUIPC ? 1'b1 : 1'b0;
    end
    ARITH_IMM: begin
      if(instruction[14:12] == 3'b101) begin
        alu_op = {instruction[30], instruction[14:12]};
        immediate = {{27{1'b0}}, instruction[24:20]};
      end else begin
        alu_op = {1'b0, instruction[14:12]};
        immediate = sign_extended_imm_12;
      end
      rs2 = 5'b0;
      rs2_use_imm = 1'b1;
    end
    BRANCH: begin
      rd = 5'b0;
      branch_condition = instruction[14:12];
      branch = 1'b1;
      immediate = sign_extended_imm_branch_offset;
    end
    JALR: begin
      jump = 1'b1;
      immediate = sign_extended_imm_12;
    end
    JAL: begin
      jump = 1'b1;
      immediate = sign_extended_imm_jal_offset;
      jal_or_jalr = 1'b1;
    ECALL: begin
      rd = 5'b0;
      rs1 = 5'b0;
      rs2 = 5'b0;
    end
    end
    default: begin
      decode_error = 1'b1;
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