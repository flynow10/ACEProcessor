module branch_condition #(
  parameter WORD_SIZE = 32
) (
  input [WORD_SIZE-1:0] r1,
  input [WORD_SIZE-1:0] r2,
  input [2:0] branch_condition,
  output reg branch_taken
);
  reg signed [WORD_SIZE-1:0] signed_r1;
  reg signed [WORD_SIZE-1:0] signed_r2;

  always @(*) begin
    signed_r1 = r1;
    signed_r2 = r2;
    case (branch_condition)
      3'b000: begin
        branch_taken = r1 == r2;
      end
      3'b001: begin
        branch_taken = r1 != r2;
      end
      3'b100: begin
        branch_taken = signed_r1 < signed_r2;
      end
      3'b101: begin
        branch_taken = signed_r1 >= signed_r2;
      end
      3'b110: begin
        branch_taken = r1 < r2;
      end
      3'b111: begin
        branch_taken = r1 >= r2;
      end
      default: branch_taken = 1'b0;
    endcase
  end
endmodule