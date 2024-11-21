module sign_extender #(
  parameter WORD_SIZE = 32,
  parameter IN_SIZE = 16
) (
  input [WORD_SIZE-1:0] in,
  output [WORD_SIZE-1:0] out
);
  assign out = {{WORD_SIZE-IN_SIZE{in[IN_SIZE-1]}}, in[IN_SIZE-1:0]};
endmodule