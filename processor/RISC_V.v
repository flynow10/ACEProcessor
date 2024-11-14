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
	
	// Memory Control
	reg requested_mem;
	wire [WORD_SIZE-1:0] memory_output;
	reg [15:0] memory_address;

	// Fetch / Decode
	wire [WORD_SIZE-1:0] instruction;
	wire [5:0] rd;
	wire [5:0] rs1;
	wire [5:0] rs2;
	wire rs2_use_imm;
	wire [WORD_SIZE-1:0] immediate;
	wire [3:0] alu_op;

	wire [WORD_SIZE-1:0] rv1;
	wire [WORD_SIZE-1:0] rv2;

	// Execute
	reg [WORD_SIZE-1:0] alu_input_a,
	reg [WORD_SIZE-1:0] alu_input_b,
	wire [WORD_SIZE-1:0] alu_output



	always @(posedge clk or negedge rst) begin
		if(rst == 1'b0)
			S <= START;
		else
			S <= NS;
	end

	always @(*) begin
		case (S)
			START: NS = FETCH;
			FETCH: 
				if(requested_mem == 1'b1)
					NS = WAIT_FETCH;
				else
					NS = DECODE;
			WAIT_FETCH: NS = DECODE;
			DECODE: NS = EXECUTE;
			EXECUTE: NS = UPDATE;
			UPDATE:
				if(requested_mem == 1'b1)
					NS = WAIT_UPDATE;
				else
					NS = FETCH;
			WAIT_UPDATE: NS = FETCH;
			default: NS = ERROR;
		endcase
	end

	always @(posedge clk or negedge rst) begin
		if(rst == 1'b0) begin
			instruction <= 32'b0;
			requested_mem <= 0'b0;	
		end else
			case (S)
				FETCH: begin
					instruction <= 32'b0;
				end
				DECODE: begin
					alu_input_a <= rv1;
					alu_input_b <= rs2_use_imm == 1'b0 ? rv2 : immediate;
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
		.en(1'b0),
		.rd(rd),
		.rs1(rs1),
		.rs2(rs2),
		.data(alu_output),
		.rv1(rv1),
		.rv2(rv2)
	);

	ALU #(WORD_SIZE) alu(
		.a(alu_input_a),
		.b(alu_input_b),
		.raw_alu_operation(alu_op),
		.out(alu_output)
	);

	processor_memory memory(
		.address(memory_address),
		.clock(clk),
		.data(0),
		.wren(1'b0),
		.q(memory_output)
	);

endmodule