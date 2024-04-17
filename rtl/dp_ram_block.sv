
module dp_ram_block #(	
    parameter DMEM_DEPTH = 1024,		// dmem depth in a word (4 bytes, default: 1024 entries = 4 KB)
	parameter DMEM_ADDR_WIDTH = 12
) (
	input			                i_clk,

	input	[DMEM_ADDR_WIDTH-1:0]	i_addr_a,
	//input			                i_we_a,		// write enable
	//input	[1:0]	                i_size_a,	// data size (LB, LH, LW)
	//input	[31:0]	                i_din_a,
	output	[31:0]	                o_dout_a,

    input	[DMEM_ADDR_WIDTH-1:0]	i_addr_b,
	input			                i_we_b,		// write enable
	input	[1:0]	                i_size_b,	// data size (LB, LH, LW)
	input	[31:0]	                i_din_b,
	output	[31:0]	                o_dout_b
);

	// memory entries. dmem is split into 4 banks to support various data granularity
	(* ram_style="block" *) logic	[7:0]	d0[0:DMEM_DEPTH-1];
	(* ram_style="block" *) logic	[7:0]	d1[0:DMEM_DEPTH-1];
	(* ram_style="block" *) logic	[7:0]	d2[0:DMEM_DEPTH-1];
	(* ram_style="block" *) logic	[7:0]	d3[0:DMEM_DEPTH-1];

	//logic [31:0] data[0:DMEM_DEPTH-1];
	//initial begin
	//	$readmemh("dmem.mem", data);
	//	for (int i = 0; i < DMEM_DEPTH; i++)
    //        {d3[i], d2[i], d1[i], d0[i]} = data[i];
	//end

	// address for each bank
	logic	[DMEM_ADDR_WIDTH-3:0]	addr_a_0;	// address for bank 0
	logic	[DMEM_ADDR_WIDTH-3:0]	addr_a_1;	// address for bank 1
	logic	[DMEM_ADDR_WIDTH-3:0]	addr_a_2;	// address for bank 2
	logic	[DMEM_ADDR_WIDTH-3:0]	addr_a_3;	// address for bank 3
	
	assign addr_a_0 = i_addr_a[DMEM_ADDR_WIDTH-1:2] + {9'b0, |i_addr_a[1:0]};
	assign addr_a_1 = i_addr_a[DMEM_ADDR_WIDTH-1:2] + {9'b0, i_addr_a[1]};
	assign addr_a_2 = i_addr_a[DMEM_ADDR_WIDTH-1:2] + {9'b0, &i_addr_a[1:0]};
	assign addr_a_3 = i_addr_a[DMEM_ADDR_WIDTH-1:2];
	
	// data out from each bank
	logic	[7:0]	dout_a_0, dout_a_1, dout_a_2, dout_a_3;

	logic 	[1:0] i_addr_a_q;
	
    always_ff @(posedge i_clk) begin
        dout_a_0 <= d0[addr_a_0];
        dout_a_1 <= d1[addr_a_1];
        dout_a_2 <= d2[addr_a_2];
        dout_a_3 <= d3[addr_a_3];
    end
	
	// read operation with rd_en
	logic	[31:0]	dout_a_tmp;	// need to be aligned by an address offset

	always_ff @(posedge i_clk) begin
		i_addr_a_q <= i_addr_a[1:0];
	end

	always @(*) begin
		case (i_addr_a[1:0])	// synopsys full_case parallel_case
			2'b00: dout_a_tmp = {dout_a_3, dout_a_2, dout_a_1, dout_a_0};
			2'b01: dout_a_tmp = {dout_a_0, dout_a_3, dout_a_2, dout_a_1};
			2'b10: dout_a_tmp = {dout_a_1, dout_a_0, dout_a_3, dout_a_2};
			2'b11: dout_a_tmp = {dout_a_2, dout_a_1, dout_a_0, dout_a_3};
		endcase
	end

	assign o_dout_a = dout_a_tmp;

    // address for each bank
	logic	[DMEM_ADDR_WIDTH-3:0]	addr_b_0;	// address for bank 0
	logic	[DMEM_ADDR_WIDTH-3:0]	addr_b_1;	// address for bank 1
	logic	[DMEM_ADDR_WIDTH-3:0]	addr_b_2;	// address for bank 2
	logic	[DMEM_ADDR_WIDTH-3:0]	addr_b_3;	// address for bank 3
	
	assign addr_b_0 = i_addr_b[DMEM_ADDR_WIDTH-1:2] + {9'b0, |i_addr_b[1:0]};
	assign addr_b_1 = i_addr_b[DMEM_ADDR_WIDTH-1:2] + {9'b0, i_addr_b[1]};
	assign addr_b_2 = i_addr_b[DMEM_ADDR_WIDTH-1:2] + {9'b0, &i_addr_b[1:0]};
	assign addr_b_3 = i_addr_b[DMEM_ADDR_WIDTH-1:2];
	
	// data out from each bank
	logic	[7:0]	dout_b_0, dout_b_1, dout_b_2, dout_b_3;

	logic 	[1:0] i_addr_b_q;
	
    always_ff @(posedge i_clk) begin
        dout_b_0 <= d0[addr_b_0];
        dout_b_1 <= d1[addr_b_1];
        dout_b_2 <= d2[addr_b_2];
        dout_b_3 <= d3[addr_b_3];
    end
	
	// read operation with rd_en
	logic	[31:0]	dout_b_tmp;	// need to be aligned by an address offset

	always_ff @(posedge i_clk) begin
		i_addr_b_q <= i_addr_b[1:0];
	end
	
	always @(*) begin
		case (i_addr_b_q[1:0])	// synopsys full_case parallel_case
			2'b00: dout_b_tmp = {dout_b_3, dout_b_2, dout_b_1, dout_b_0};
			2'b01: dout_b_tmp = {dout_b_0, dout_b_3, dout_b_2, dout_b_1};
			2'b10: dout_b_tmp = {dout_b_1, dout_b_0, dout_b_3, dout_b_2};
			2'b11: dout_b_tmp = {dout_b_2, dout_b_1, dout_b_0, dout_b_3};
		endcase
	end

	assign o_dout_b = dout_b_tmp;





	
	// write operation with wr_en
	//logic	[3:0]	we_a;		// write enable for each bank
	//
	//always @(*) begin
	//	if (i_size_a==2'b00) begin
	//		case (i_addr_a[1:0])	// synopsys full_case
	//			2'b00: we_a = {3'b000, i_we_a};
	//			2'b01: we_a = {2'b00, i_we_a, 1'b0};
	//			2'b10: we_a = {1'b0, i_we_a, 2'b00};
	//			2'b11: we_a = {i_we_a, 3'b000};
	//		endcase
	//	end
	//	else if (i_size_a==2'b01) begin
	//		case (i_addr_a[1:0])	// synopsys full_case
	//			2'b00: we_a = {2'b00, {2{i_we_a}}};
	//			2'b01: we_a = {1'b0, {2{i_we_a}}, 1'b0};
	//			2'b10: we_a = {{2{i_we_a}}, 2'b00};
	//			2'b11: we_a = {i_we_a, 2'b00, i_we_a};
	//		endcase
	//	end
	//	else
	//		we_a = {4{i_we_a}};	// store word
	//end
	//
	//// write operation that supports unaligned words
	//logic	[31:0]	din_a_tmp;
	//
	//always @(*) begin
	//	case (i_addr_a[1:0])	// synopsys full_case parallel_case
	//		2'b00: din_a_tmp = i_din_a[31:0];
	//		2'b01: din_a_tmp = {i_din_a[23:0], i_din_a[31:24]};
	//		2'b10: din_a_tmp = {i_din_a[15:0], i_din_a[31:16]};
	//		2'b11: din_a_tmp = {i_din_a[7:0], i_din_a[31:8]};
	//	endcase
	//end
	//
	//// in the textbook, dmem does not receive the clock signal
	//// but clocked write operation is required for better operation and synthesis
	//// we must avoid latch for the normal cases
	//always_ff @ (posedge i_clk) begin
	//	if (we_a[0]) d0[addr_a_0] <= din_a_tmp[7:0];
	//	if (we_a[1]) d1[addr_a_1] <= din_a_tmp[15:8];
	//	if (we_a[2]) d2[addr_a_2] <= din_a_tmp[23:16];
	//	if (we_a[3]) d3[addr_a_3] <= din_a_tmp[31:24];
	//end
    

    	// write operation with wr_en
	logic	[3:0]	we_b;		// write enable for each bank
	
	always @(*) begin
		if (i_size_b==2'b00) begin
			case (i_addr_b[1:0])	// synopsys full_case
				2'b00: we_b = {3'b000, i_we_b};
				2'b01: we_b = {2'b00, i_we_b, 1'b0};
				2'b10: we_b = {1'b0, i_we_b, 2'b00};
				2'b11: we_b = {i_we_b, 3'b000};
			endcase
		end
		else if (i_size_b==2'b01) begin
			case (i_addr_b[1:0])	// synopsys full_case
				2'b00: we_b = {2'b00, {2{i_we_b}}};
				2'b01: we_b = {1'b0, {2{i_we_b}}, 1'b0};
				2'b10: we_b = {{2{i_we_b}}, 2'b00};
				2'b11: we_b = {i_we_b, 2'b00, i_we_b};
			endcase
		end
		else
			we_b = {4{i_we_b}};	// store word
	end
	
	// write operation that supports unaligned words
	logic	[31:0]	din_b_tmp;
	
	always @(*) begin
		case (i_addr_b[1:0])	// synopsys full_case parallel_case
			2'b00: din_b_tmp = i_din_b[31:0];
			2'b01: din_b_tmp = {i_din_b[23:0], i_din_b[31:24]};
			2'b10: din_b_tmp = {i_din_b[15:0], i_din_b[31:16]};
			2'b11: din_b_tmp = {i_din_b[7:0], i_din_b[31:8]};
		endcase
	end
	
	// in the textbook, dmem does not receive the clock signal
	// but clocked write operation is required for better operation and synthesis
	// we must avoid latch for the normal cases
	always_ff @ (posedge i_clk) begin
		if (we_b[0]) d0[addr_b_0] <= din_b_tmp[7:0];
		if (we_b[1]) d1[addr_b_1] <= din_b_tmp[15:8];
		if (we_b[2]) d2[addr_b_2] <= din_b_tmp[23:16];
		if (we_b[3]) d3[addr_b_3] <= din_b_tmp[31:24];
	end

endmodule