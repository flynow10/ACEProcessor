module byte_addressable (
  input clk,
  input [31:0] address,
  input [1:0] write_mode, // 0 = don't write, 1 = write byte, 2 = write half word, 3 = write word
  input [7:0] write_byte,
  input [15:0] write_half_word,
  input [31:0] write_word,
  output reg error,
  output reg done,
  output wire [7:0] byte_output,
  output reg [15:0] half_word_output,
  output wire [31:0] word_output
);

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
  if(address[1] == 1'b0)
      half_word_output = word_output[31:16];
    else
      half_word_output = word_output[15:0];
  if(write_mode == 2'b10) begin
    if(address[1] == 1'b0)
      compiled_data = {write_half_word, word_output[15:0]};
    else
      compiled_data = {word_output[31:16], write_half_word};
  end else
    compiled_data = write_word;
  
  case (S)
    START: begin
      if(write_mode == 2'b0)
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
      if(write_mode == 2'b0)
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
      error <= 1'b0;
    end
    READ: cycled[0] <= 1'b1;
    WRITE: begin
      if(address >= 32'h00020000 || address <= 32'h2644)
        error <= 1'b1;
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
  .address_a(address[17:2]),
  .address_b(address[17:0]),
  .clock(clk),
  .data_a(compiled_data),
  .data_b(write_byte),
  .wren_a(write_en & ((write_mode == 2'b10) | (write_mode == 2'b11))),
  .wren_b(write_en & (write_mode == 2'b01)),
  .q_a(word_output),
  .q_b(byte_output)
);
endmodule