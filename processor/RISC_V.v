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

	wire clk;
	wire clk1;
	wire clk2;
	wire clk3;
	wire clk4;
	wire rst;
	wire [WORD_SIZE-1:0] pc_addr;

	assign clk1 = KEY[2];
	assign rst = KEY[3];
	
	clock_divider_25 cld1 (clk1, clk2);
	clock_divider_25 cld2 (clk2, clk3);
	clock_divider_25 cld3 (clk3, clk4);
	clock_divider_25 cld4 (clk4, clk);

	program_counter #(WORD_SIZE) pc (.clk(clk), .rst(rst), .en(1'b1), .wren(1'b0), .X(32'b0), .addr(pc_addr));

	three_decimal_vals_w_neg seven_seg(.val(pc_addr[7:0]), .seg7_neg_sign(HEX3), .seg7_dig0(HEX0), .seg7_dig1(HEX1), .seg7_dig2(HEX2));



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