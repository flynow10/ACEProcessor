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
	parameter START = 4'b0,
						FETCH = 4'b1,
						WAIT_FETCH = 4'b10,
						DECODE = 4'b11,
						EXECUTE = 4'b100,
						MEM_ACCESS = 4'b101,
						WAIT_MEM_ACCESS = 4'b110,
						UPDATE = 4'b111,
						WAIT_UPDATE = 4'b1000,
						DECODE_ERROR = 4'b1110,
						MEM_ERROR = 4'b1101,
						FSM_ERROR = 4'b1111;

	reg [3:0] S;
	reg [3:0] NS;

	assign LEDR[3:0] = S;
	assign LEDR[4] = mem_align_error;
	assign LEDR[9:5] = SW[9:5];

	// Display
	reg [31:0] to_display;
	wire [31:0] debug_reg_out;
	
	// Memory Control
	wire mem_update_complete;
	wire mem_align_error;
	wire [WORD_SIZE-1:0] memory_output;
	reg need_write_mem;
	reg [31:0] memory_address;
	reg [31:0] memory_write_data;
	reg [1:0] write_en;

	// Fetch / Decode
	reg [31:0] program_counter;

	wire decode_error;
	reg [WORD_SIZE-1:0] instruction;
	wire [4:0] rd;
	wire [4:0] rs1;
	wire [4:0] rs2;
	wire rs1_use_pc;
	wire rs2_use_imm;
	wire [WORD_SIZE-1:0] immediate;
	wire [3:0] alu_op;
	wire [2:0] reg_load_size;
	wire [1:0] mem_write_size;
	wire mem_to_reg;
	wire [2:0] branch_condition;
	wire branch;
	wire jump;
	wire jal_or_jalr;

	wire [WORD_SIZE-1:0] rv1;
	wire [WORD_SIZE-1:0] rv2;

	// Execute
	reg [WORD_SIZE-1:0] alu_input_a;
	reg [WORD_SIZE-1:0] alu_input_b;
	wire [WORD_SIZE-1:0] alu_output;
	reg enable_register;
	reg [WORD_SIZE-1:0] raw_reg_write_back;
	wire branch_taken;

	// Mem write back
	reg [WORD_SIZE-1:0] register_write_back;

	always @(posedge clk or negedge rst) begin
		if(rst == 1'b0)
			S <= START;
		else
			S <= NS;
	end

	always @(*) begin
		case (S)
			START: NS = FETCH;
			FETCH: NS = WAIT_FETCH;
			WAIT_FETCH: NS = DECODE;
			DECODE: NS = EXECUTE;
			EXECUTE: begin
				if(decode_error == 1'b0)
					NS = MEM_ACCESS;
				else
					NS = DECODE_ERROR;
			end
			MEM_ACCESS: NS = WAIT_MEM_ACCESS;
			WAIT_MEM_ACCESS: NS = UPDATE;
			UPDATE:
				if(need_write_mem == 1'b1)
					NS = WAIT_UPDATE;
				else
					NS = FETCH;
			WAIT_UPDATE: begin
				if(mem_update_complete == 1'b1)
					NS = FETCH;
				else
					NS = WAIT_UPDATE;
			end
			default: NS = FSM_ERROR;
		endcase
	end

	always @(posedge clk or negedge rst) begin
		if(rst == 1'b0) begin
			memory_address <= 32'b0;
			instruction <= 32'b0;
			need_write_mem <= 1'b0;
			program_counter <= 32'd0;
		end else
			case (S)
				FETCH: begin
					need_write_mem <= 1'b0;
					enable_register <= 1'b0;
					memory_address <= program_counter;
					write_en <= 2'b0;
				end
				DECODE: begin
					instruction <= memory_output;
				end
				EXECUTE: begin
					alu_input_a <= rs1_use_pc == 1'b0 ? rv1 : program_counter;
					alu_input_b <= rs2_use_imm == 1'b0 ? rv2 : immediate;
					need_write_mem <= mem_write_size != 2'b0;
				end
				MEM_ACCESS: begin
					memory_address <= alu_output;
				end
				UPDATE: begin
					if(jump == 1'b1)
						raw_reg_write_back <= program_counter + 32'd4;
					else if(mem_to_reg == 1'b1)
						raw_reg_write_back <= memory_output;
					else
						raw_reg_write_back <= alu_output;
					case (reg_load_size)
						3'b100: register_write_back <= {{24{1'b0}}, raw_reg_write_back[7:0]};
						3'b101:	register_write_back <= {{16{1'b0}}, raw_reg_write_back[15:0]};
						3'b000: register_write_back <= {{24{raw_reg_write_back[7]}}, raw_reg_write_back[7:0]};
						3'b001:	register_write_back <= {{16{raw_reg_write_back[15]}}, raw_reg_write_back[15:0]};
						default: register_write_back <= raw_reg_write_back;
					endcase
					enable_register <= 1'b1;
					write_en <= mem_write_size;
					if(jump == 1'b1) begin
						if(jal_or_jalr == 1'b1)
							program_counter <= program_counter + immediate;
						else
							program_counter <= rv1 + immediate;
					end else if(branch == 1'b1 & branch_taken == 1'b1)
						program_counter <= program_counter + immediate;
					else
						program_counter <= program_counter + 32'd4;
				end
			endcase
	end

	instruction_decoder #(WORD_SIZE) instruction_decoder(
		.instruction(instruction),
		.rd(rd),
		.rs1(rs1),
		.rs2(rs2),
		.rs1_use_pc(rs1_use_pc),
		.rs2_use_imm(rs2_use_imm),
		.immediate(immediate),
		.alu_op(alu_op),
		.reg_load_size(reg_load_size),
		.mem_write_size(mem_write_size),
		.mem_to_reg(mem_to_reg),
		.branch_condition(branch_condition),
		.branch(branch),
		.jump(jump),
		.jal_or_jalr(jal_or_jalr),
		.decode_error(decode_error)
	);

	register_file #(WORD_SIZE) registers(
		.clk(clk),
		.rst(rst),
		.en(enable_register),
		.rd(rd),
		.rs1(rs1),
		.rs2(rs2),
		.debug_reg(SW[9:5]),
		.data(register_write_back),
		.rv1(rv1),
		.rv2(rv2),
		.debug_reg_out(debug_reg_out)
	);

	ALU #(WORD_SIZE) alu(
		.a(alu_input_a),
		.b(alu_input_b),
		.raw_alu_operation(alu_op),
		.out(alu_output)
	);

	branch_condition #(WORD_SIZE) branch_cond(
		.r1(rv1),
		.r2(rv2),
		.branch_condition(branch_condition),
		.branch_taken(branch_taken)
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
		.q0(memory_output[31:24])
	);

	always @(*) begin
		case (~KEY[1:0])
			2'b00: to_display = alu_output;
			2'b01: to_display = immediate;
			2'b10: to_display = debug_reg_out;
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