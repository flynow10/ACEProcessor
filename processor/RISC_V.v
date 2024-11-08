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

	parameter START = 3'b0,
						FETCH = 3'b1,
						WAIT_FETCH = 3'b10,
						DECODE = 3'b11,
						EXECUTE = 3'b100,
						UPDATE = 3'b101,
						WAIT_UPDATE = 3'b110,
						ERROR = 3'b111;

	wire clk;
	wire rst;

	reg [2:0] S;
	reg [2:0] NS;

	reg requested_mem;

	reg [WORD_SIZE-1:0] instruction;

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
		case (S)
			FETCH: begin
				
			end
		endcase
	end
	// wire [31:0] a;
	// wire [31:0] b;
	// wire [31:0] o;
	// wire [31:0] q;

	// wire [2:0] op;

	// assign op = SW[2:0];
	// assign b = SW[9:6];
	// assign LEDR = o[9:0];

	// ALU #(WORD_SIZE) alu(a, b, op, o);

	// processor_memory memory(
	// 	.address(a[15:0]),
	// 	.clock(clk),
	// 	.data(b),
	// 	.wren(1'b0),
	// 	.q(q)
	// );

endmodule