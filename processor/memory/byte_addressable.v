module byte_addressable (
  input clk,
  input [31:0] address,
  input [1:0] write, // 0 = don't write, 1 = write byte, 2 = write half word, 3 = write word
  input [7:0] d0,
  input [7:0] d1,
  input [7:0] d2,
  input [7:0] d3,
  output reg error,
  output reg done,
  output reg [7:0] q0,
  output reg [7:0] q1,
  output reg [7:0] q2,
  output reg [7:0] q3
);

wire [31:0] memory_output;

parameter START = 2'b0,
          READ = 2'b1,
          WRITE = 2'b10,
          DONE = 2'b11;

reg [1:0] S;
reg [1:0] NS;
reg [1:0] cycled; // bit 0 is for reading, bit 1 is for writing

reg [31:0] compiled_data;
reg write_en;

always @(posedge clk) begin
  S <= NS;
end

always @(*) begin
  error = address[1:0] != 2'b0;
  q3 = memory_output[7:0];
  q2 = memory_output[15:8];
  q1 = memory_output[23:16];
  q0 = memory_output[31:24];
  
  // case (address[1:0])
  //   2'b00: q0 = memory_output[31:24];
  //   2'b01: q0 = memory_output[23:16];
  //   2'b10: q0 = memory_output[15:8];
  //   2'b11: q0 = memory_output[7:0];
  // endcase

  if(write == 2'b0)
    compiled_data = {q0, q1, q2, q3};
  else if(write == 2'b1)
    compiled_data = {d0, q1, q2, q3};
  else if(write == 2'b10)
    compiled_data = {d0, d1, q2, q3};
  else if(write == 2'b11)
    compiled_data = {d0, d1, d2, d3};
  else
    compiled_data = 32'd0;
  
  case (S)
    START: begin
      if(write == 2'b0)
        NS = START;
      else
        NS = READ;
    end
    READ: begin
      if(cycled[0] == 1'b0)
        NS = READ;
      else
        NS = WRITE;
    end
    WRITE: begin
      if(cycled[1] == 1'b0)
        NS = WRITE;
      else
        NS = DONE;
    end
    DONE: begin
      if(write == 2'b0)
        NS = START;
      else
        NS = DONE;
    end
  endcase
end

always @(posedge clk) begin
  case (S)
    START: begin
      cycled <= 2'b0;
      done <= 1'b0;
      write_en <= 1'b0;
    end
    READ: cycled[0] <= 1'b1;
    WRITE: begin
      write_en <= 1'b1;
      cycled[1] <= 1'b1;
    end 
    DONE: begin
      write_en <= 1'b0;
      done <= 1'b1;
    end
  endcase
end

processor_memory memory_block(
  .address(address[17:2]),
  .clock(clk),
  .data(compiled_data),
  .wren(write_en),
  .q(memory_output)
);
endmodule