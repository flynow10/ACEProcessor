module ALU #(
  parameter WORD_SIZE = 32
) (
  input [WORD_SIZE-1:0] a,
  input [WORD_SIZE-1:0] b,
  input [3:0] raw_alu_operation,
  output reg [WORD_SIZE-1:0] out
);
  parameter 
    OP_ADD = 3'd0, // Arithmetic Add
    OP_SLL = 3'd1, // Logical Left Shift
    OP_SLT = 3'd2, // Less Then Signed
    OP_SLTU = 3'd3, // Less Then Unsigned
    OP_XOR = 3'd4, // Bitwise Xor
    OP_SR = 3'd5, // Shift Right
    OP_OR = 3'd6, // Bitwise Or
    OP_AND = 3'd7; // Bitwise And
  
  reg signed [WORD_SIZE-1:0] a_signed;
  reg signed [WORD_SIZE-1:0] b_signed;

  wire [2:0] alu_op;
  wire invert_b;

  assign alu_op = raw_alu_operation[2:0];
  assign invert_b = raw_alu_operation[3];

  always @(*) begin
    a_signed = a;
    b_signed = b;
    case (alu_op)
      OP_AND: out = a & b;
      OP_XOR: out = a ^ b;
      OP_OR: out = a | b;
      OP_ADD: begin
        if(invert_b == 1'b0)
          out = a + b;
        else
          out = a - b;
      end
      OP_SR: begin
        if(invert_b == 1'b0)
          out = a >> b;
        else
          out = a >>> b;
      end
      OP_SLL: out = a << b;
      OP_SLT: out = a_signed < b_signed;
      OP_SLTU: out = a < b;
      default: out = { WORD_SIZE{1'b0} };
    endcase
  end
endmodule