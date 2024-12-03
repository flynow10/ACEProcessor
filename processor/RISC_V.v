module RISC_V(
  
	//////////// ADC //////////
	output		          		ADC_CONVST,
	output		          		ADC_DIN,
	input 		          		ADC_DOUT,
	output		          		ADC_SCLK,

	//////////// Audio //////////
	input 		          		AUD_ADCDAT,
	inout 		          		AUD_ADCLRCK,
	inout 		          		AUD_BCLK,
	output		          		AUD_DACDAT,
	inout 		          		AUD_DACLRCK,
	output		          		AUD_XCK,

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SDRAM //////////
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		          		DRAM_LDQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_UDQM,
	output		          		DRAM_WE_N,

	//////////// I2C for Audio and Video-In //////////
	output		          		FPGA_I2C_SCLK,
	inout 		          		FPGA_I2C_SDAT,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// IR //////////
	input 		          		IRDA_RXD,
	output		          		IRDA_TXD,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// PS2 //////////
	inout 		          		PS2_CLK,
	inout 		          		PS2_CLK2,
	inout 		          		PS2_DAT,
	inout 		          		PS2_DAT2,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// Video-In //////////
	input 		          		TD_CLK27,
	input 		     [7:0]		TD_DATA,
	input 		          		TD_HS,
	output		          		TD_RESET_N,
	input 		          		TD_VS,

	//////////// VGA //////////
	output		          		VGA_BLANK_N,
	output		     [7:0]		VGA_B,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS,

	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	inout 		    [35:0]		GPIO_0,

	//////////// GPIO_1, GPIO_1 connect to GPIO Default //////////
	inout 		    [35:0]		GPIO_1
);
	parameter WORD_SIZE = 'd32;

	// Clock
	wire clk;
	wire rst;

	assign clk = ~KEY[3];
	assign rst = KEY[2];

	// FSM Control
	parameter START = 3'b0,
						FETCH = 3'b1,
						WAIT_FETCH = 3'b10,
						DECODE = 3'b11,
						EXECUTE = 3'b100,
						UPDATE = 3'b101,
						WAIT_UPDATE = 3'b110,
						ERROR = 3'b111;

	reg [2:0] S;
	reg [2:0] NS;

	assign LEDR[2:0] = S;

	// Display
	reg [31:0] to_display;
	
	// Memory Control
	wire mem_update_complete;
	wire mem_align_error;
	wire [WORD_SIZE-1:0] memory_output;
	reg requested_mem;
	reg [31:0] memory_address;
	reg [31:0] memory_write_data;
	reg [1:0] write_en;

	// Fetch / Decode
	reg [31:0] program_counter;

	reg [WORD_SIZE-1:0] instruction;
	wire [5:0] rd;
	wire [5:0] rs1;
	wire [5:0] rs2;
	wire rs2_use_imm;
	wire [WORD_SIZE-1:0] immediate;
	wire [3:0] alu_op;
	wire store_register;

	wire [WORD_SIZE-1:0] rv1;
	wire [WORD_SIZE-1:0] rv2;

	// Execute
	reg [WORD_SIZE-1:0] alu_input_a;
	reg [WORD_SIZE-1:0] alu_input_b;
	wire [WORD_SIZE-1:0] alu_output;
	reg enable_register;

	// Mem write back
	reg [WORD_SIZE-1:0] register_write_back;

	always @(posedge clk or negedge rst) begin
		if(rst == 1'b0)
			S <= START;
		else if(mem_align_error == 1'b1)
			S <= ERROR;
		else
			S <= NS;
	end

	always @(*) begin
		case (S)
			START: NS = FETCH;
			FETCH: NS = WAIT_FETCH;
			WAIT_FETCH: NS = DECODE;
			DECODE: NS = EXECUTE;
			EXECUTE: NS = UPDATE;
			UPDATE:
				if(requested_mem == 1'b1)
					NS = WAIT_UPDATE;
				else
					NS = FETCH;
			WAIT_UPDATE: begin
				if(mem_update_complete == 1'b1)
					NS = FETCH;
				else
					NS = WAIT_UPDATE;
			end
			default: NS = ERROR;
		endcase
	end

	always @(posedge clk or negedge rst) begin
		if(rst == 1'b0) begin
			instruction <= 32'b0;
			requested_mem <= 1'b0;
			program_counter <= 32'b4;
		end else
			case (S)
				FETCH: begin
					enable_register <= 1'b0;
					memory_address <= program_counter;
				end
				DECODE: begin
					instruction <= memory_output;
				end
				EXECUTE: begin
					alu_input_a <= rv1;
					alu_input_b <= rs2_use_imm == 1'b0 ? rv2 : immediate;
				end
				UPDATE: begin
					register_write_back <= alu_output;
					enable_register <= 1'b1;
					program_counter <= program_counter + 32'b4;
				end
			endcase
	end

	instruction_decoder #(WORD_SIZE) instruction_decoder(
		.instruction(instruction),
		.rd(rd),
		.rs1(rs1),
		.rs2(rs2),
		.rs2_use_imm(rs2_use_imm),
		.immediate(immediate),
		.alu_op(alu_op)
	);

	register_file #(WORD_SIZE) registers(
		.clk(clk),
		.rst(rst),
		.en(enable_register),
		.rd(rd),
		.rs1(rs1),
		.rs2(rs2),
		.data(register_write_back),
		.rv1(rv1),
		.rv2(rv2)
	);

	ALU #(WORD_SIZE) alu(
		.a(alu_input_a),
		.b(alu_input_b),
		.raw_alu_operation(alu_op),
		.out(alu_output)
	);

	byte_addressable memory(
		.address(memory_address),
		.clk(clk),
		.error(mem_align_error),
		.done(mem_update_complete),
		.write(write_en),
		.d3(memory_write_data[7:0]),
		.d2(memory_write_data[15:8]),
		.d1(memory_write_data[23:16]),
		.d0(memory_write_data[31:24]),
		.q3(memory_output[7:0]),
		.q2(memory_output[15:8]),
		.q1(memory_output[23:16]),
		.q0(memory_output[31:24]),
	);

	always @(*) begin
		case (~KEY[1:0])
			2'b00: to_display = alu_output;
			2'b01: to_display = rv1;
			2'b10: to_display = rv2;
			2'b11: to_display = program_counter;
		endcase
	end

	five_decimal_vals_w_neg seven_seg_display(
		.val(to_display),
		.seg7_neg_sign(HEX5),
		.seg7_dig0(HEX0),
		.seg7_dig1(HEX1),
		.seg7_dig2(HEX2),
		.seg7_dig3(HEX3),
		.seg7_dig4(HEX4)
	);
endmodule