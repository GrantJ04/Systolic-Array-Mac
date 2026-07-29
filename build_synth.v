module flex_counter (
	clk,
	n_rst,
	en,
	rollover_flag,
	count
);
	parameter DEPTH = 16;
	input wire clk;
	input wire n_rst;
	input wire en;
	output reg rollover_flag;
	output reg [$clog2(DEPTH) - 1:0] count;
	localparam CNT_WIDTH = $clog2(DEPTH);
	function automatic signed [CNT_WIDTH - 1:0] sv2v_cast_1924C_signed;
		input reg signed [CNT_WIDTH - 1:0] inp;
		sv2v_cast_1924C_signed = inp;
	endfunction
	always @(posedge clk or negedge n_rst)
		if (!n_rst) begin
			count <= 1'sb0;
			rollover_flag <= 1'b0;
		end
		else begin
			rollover_flag <= en && (count == sv2v_cast_1924C_signed(DEPTH - 1));
			if (en) begin
				if (count == sv2v_cast_1924C_signed(DEPTH - 1))
					count <= 1'sb0;
				else
					count <= count + 1;
			end
		end
endmodule
module flex_sr (
	clk,
	n_rst,
	en,
	data_in,
	data_out,
	buffer_full
);
	parameter DATA_WIDTH = 8;
	parameter ARRAY_SIZE = 4;
	input wire clk;
	input wire n_rst;
	input wire en;
	input wire [DATA_WIDTH - 1:0] data_in;
	output reg [(ARRAY_SIZE * DATA_WIDTH) - 1:0] data_out;
	output wire buffer_full;
	flex_counter #(.DEPTH(ARRAY_SIZE)) buffer_full_counter(
		.clk(clk),
		.n_rst(n_rst),
		.en(en),
		.rollover_flag(buffer_full),
		.count()
	);
	always @(posedge clk or negedge n_rst)
		if (!n_rst)
			data_out <= 1'sb0;
		else
			data_out <= {data_out[DATA_WIDTH * (((ARRAY_SIZE - 2) >= 0 ? ARRAY_SIZE - 2 : ((ARRAY_SIZE - 2) + ((ARRAY_SIZE - 2) >= 0 ? ARRAY_SIZE - 1 : 3 - ARRAY_SIZE)) - 1) - (((ARRAY_SIZE - 2) >= 0 ? ARRAY_SIZE - 1 : 3 - ARRAY_SIZE) - 1))+:DATA_WIDTH * ((ARRAY_SIZE - 2) >= 0 ? ARRAY_SIZE - 1 : 3 - ARRAY_SIZE)], data_in};
endmodule
module mac_cell (
	clk,
	n_rst,
	x_i,
	w_i,
	accum_in,
	valid_in,
	valid_out,
	y_i,
	x_out,
	w_out
);
	reg _sv2v_0;
	parameter DATA_WIDTH = 8;
	parameter ARRAY_SIZE = 4;
	input wire clk;
	input wire n_rst;
	input wire [DATA_WIDTH - 1:0] x_i;
	input wire [DATA_WIDTH - 1:0] w_i;
	input wire [((DATA_WIDTH * 2) + $clog2(ARRAY_SIZE)) - 1:0] accum_in;
	input wire valid_in;
	output reg valid_out;
	output reg [((DATA_WIDTH * 2) + $clog2(ARRAY_SIZE)) - 1:0] y_i;
	output reg [DATA_WIDTH - 1:0] x_out;
	output reg [DATA_WIDTH - 1:0] w_out;
	localparam ACC_WIDTH = (DATA_WIDTH * 2) + $clog2(ARRAY_SIZE);
	localparam PAD_WIDTH = $clog2(ARRAY_SIZE);
	reg [(DATA_WIDTH * 2) - 1:0] mult_res;
	reg [(DATA_WIDTH * 2) - 1:0] mult_res_reg;
	reg [ACC_WIDTH - 1:0] accum_res;
	reg [ACC_WIDTH - 1:0] mult_reg_ext;
	reg valid_stage1;
	reg [DATA_WIDTH - 1:0] x_stage1;
	reg [DATA_WIDTH - 1:0] w_stage1;
	always @(*) begin : multiply_block
		if (_sv2v_0)
			;
		mult_res = w_i * x_i;
	end
	always @(posedge clk or negedge n_rst)
		if (!n_rst) begin
			mult_res_reg <= 1'sb0;
			valid_stage1 <= 1'sb0;
			x_stage1 <= 1'sb0;
			w_stage1 <= 1'sb0;
		end
		else begin
			mult_res_reg <= mult_res;
			valid_stage1 <= valid_in;
			x_stage1 <= x_i;
			w_stage1 <= w_i;
		end
	always @(*) begin : accumulator_block
		if (_sv2v_0)
			;
		mult_reg_ext = {{PAD_WIDTH {1'b0}}, mult_res_reg};
		accum_res = mult_reg_ext + accum_in;
	end
	always @(posedge clk or negedge n_rst)
		if (!n_rst) begin
			y_i <= 1'sb0;
			valid_out <= 1'sb0;
			x_out <= 1'sb0;
			w_out <= 1'sb0;
		end
		else begin
			y_i <= accum_res;
			valid_out <= valid_stage1;
			x_out <= x_stage1;
			w_out <= w_stage1;
		end
	initial _sv2v_0 = 0;
endmodule
module mac_cell_array (
	clk,
	n_rst,
	x_i,
	w_i,
	valid_in,
	y_i,
	valid_out
);
	parameter DATA_WIDTH = 8;
	parameter ARRAY_SIZE = 4;
	input wire clk;
	input wire n_rst;
	input wire [(ARRAY_SIZE * DATA_WIDTH) - 1:0] x_i;
	input wire [(ARRAY_SIZE * DATA_WIDTH) - 1:0] w_i;
	input wire [ARRAY_SIZE - 1:0] valid_in;
	output wire [((ARRAY_SIZE * ARRAY_SIZE) * ((DATA_WIDTH * 2) + $clog2(ARRAY_SIZE))) - 1:0] y_i;
	output wire [(ARRAY_SIZE * ARRAY_SIZE) - 1:0] valid_out;
	genvar _gv_i_1;
	genvar _gv_j_1;
	wire [((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))) >= (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) ? ((((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))) - (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))))) + 1) * DATA_WIDTH) + (((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) * DATA_WIDTH) - 1) : ((((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) - (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1)))) + 1) * DATA_WIDTH) + (((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))) * DATA_WIDTH) - 1)):((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))) >= (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) ? (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) * DATA_WIDTH : (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))) * DATA_WIDTH)] x_wire;
	wire [((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))) >= (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) ? ((((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))) - (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))))) + 1) * DATA_WIDTH) + (((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) * DATA_WIDTH) - 1) : ((((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) - (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1)))) + 1) * DATA_WIDTH) + (((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))) * DATA_WIDTH) - 1)):((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))) >= (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) ? (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) * DATA_WIDTH : (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))) * DATA_WIDTH)] w_wire;
	wire [((ARRAY_SIZE * ARRAY_SIZE) * ((DATA_WIDTH * 2) + $clog2(ARRAY_SIZE))) - 1:0] accum_wire;
	wire [(ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))):(ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))))] valid_wire;
	generate
		for (_gv_i_1 = 0; _gv_i_1 < ARRAY_SIZE; _gv_i_1 = _gv_i_1 + 1) begin : genblk1
			localparam i = _gv_i_1;
			assign w_wire[((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))) >= (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) ? ((ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i) : (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) - ((((ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i)) - (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))))) * DATA_WIDTH+:DATA_WIDTH] = w_i[i * DATA_WIDTH+:DATA_WIDTH];
		end
		for (_gv_i_1 = 0; _gv_i_1 < ARRAY_SIZE; _gv_i_1 = _gv_i_1 + 1) begin : genblk2
			localparam i = _gv_i_1;
			assign x_wire[((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))) >= (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) ? ((ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE) : (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) - ((((ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE)) - (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))))) * DATA_WIDTH+:DATA_WIDTH] = x_i[i * DATA_WIDTH+:DATA_WIDTH];
			assign valid_wire[((ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE)] = valid_in[i];
		end
		for (_gv_i_1 = 0; _gv_i_1 < ARRAY_SIZE; _gv_i_1 = _gv_i_1 + 1) begin : genblk3
			localparam i = _gv_i_1;
			for (_gv_j_1 = 0; _gv_j_1 < ARRAY_SIZE; _gv_j_1 = _gv_j_1 + 1) begin : genblk1
				localparam j = _gv_j_1;
				if (j == 0) begin : init_col
					localparam sv2v_uu_cell_inst_ARRAY_SIZE = ARRAY_SIZE;
					localparam sv2v_uu_cell_inst_DATA_WIDTH = DATA_WIDTH;
					localparam [((DATA_WIDTH * 2) + $clog2(ARRAY_SIZE)) - 1:0] sv2v_uu_cell_inst_ext_accum_in_0 = 1'sb0;
					mac_cell #(
						.DATA_WIDTH(DATA_WIDTH),
						.ARRAY_SIZE(ARRAY_SIZE)
					) cell_inst(
						.clk(clk),
						.n_rst(n_rst),
						.x_i(x_wire[((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))) >= (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) ? ((ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? j : ARRAY_SIZE - j) : (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) - ((((ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? j : ARRAY_SIZE - j)) - (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))))) * DATA_WIDTH+:DATA_WIDTH]),
						.w_i(w_wire[((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))) >= (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) ? ((ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? j : ARRAY_SIZE - j) : (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) - ((((ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? j : ARRAY_SIZE - j)) - (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))))) * DATA_WIDTH+:DATA_WIDTH]),
						.accum_in(sv2v_uu_cell_inst_ext_accum_in_0),
						.valid_in(valid_wire[((ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? j : ARRAY_SIZE - j)]),
						.valid_out(valid_wire[((ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? j + 1 : ARRAY_SIZE - (j + 1))]),
						.y_i(accum_wire[((i * ARRAY_SIZE) + j) * ((DATA_WIDTH * 2) + $clog2(ARRAY_SIZE))+:(DATA_WIDTH * 2) + $clog2(ARRAY_SIZE)]),
						.x_out(x_wire[((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))) >= (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) ? ((ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? j + 1 : ARRAY_SIZE - (j + 1)) : (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) - ((((ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? j + 1 : ARRAY_SIZE - (j + 1))) - (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))))) * DATA_WIDTH+:DATA_WIDTH]),
						.w_out(w_wire[((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))) >= (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) ? ((ARRAY_SIZE >= 0 ? i + 1 : ARRAY_SIZE - (i + 1)) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? j : ARRAY_SIZE - j) : (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) - ((((ARRAY_SIZE >= 0 ? i + 1 : ARRAY_SIZE - (i + 1)) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? j : ARRAY_SIZE - j)) - (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))))) * DATA_WIDTH+:DATA_WIDTH])
					);
				end
				else begin : normal_cols
					mac_cell #(
						.DATA_WIDTH(DATA_WIDTH),
						.ARRAY_SIZE(ARRAY_SIZE)
					) cell_inst(
						.clk(clk),
						.n_rst(n_rst),
						.x_i(x_wire[((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))) >= (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) ? ((ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? j : ARRAY_SIZE - j) : (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) - ((((ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? j : ARRAY_SIZE - j)) - (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))))) * DATA_WIDTH+:DATA_WIDTH]),
						.w_i(w_wire[((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))) >= (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) ? ((ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? j : ARRAY_SIZE - j) : (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) - ((((ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? j : ARRAY_SIZE - j)) - (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))))) * DATA_WIDTH+:DATA_WIDTH]),
						.accum_in(accum_wire[((i * ARRAY_SIZE) + (j - 1)) * ((DATA_WIDTH * 2) + $clog2(ARRAY_SIZE))+:(DATA_WIDTH * 2) + $clog2(ARRAY_SIZE)]),
						.valid_in(valid_wire[((ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? j : ARRAY_SIZE - j)]),
						.valid_out(valid_wire[((ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? j + 1 : ARRAY_SIZE - (j + 1))]),
						.y_i(accum_wire[((i * ARRAY_SIZE) + j) * ((DATA_WIDTH * 2) + $clog2(ARRAY_SIZE))+:(DATA_WIDTH * 2) + $clog2(ARRAY_SIZE)]),
						.x_out(x_wire[((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))) >= (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) ? ((ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? j + 1 : ARRAY_SIZE - (j + 1)) : (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) - ((((ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? j + 1 : ARRAY_SIZE - (j + 1))) - (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))))) * DATA_WIDTH+:DATA_WIDTH]),
						.w_out(w_wire[((ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))) >= (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) ? ((ARRAY_SIZE >= 0 ? i + 1 : ARRAY_SIZE - (i + 1)) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? j : ARRAY_SIZE - j) : (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? 0 : ARRAY_SIZE + 0) : (ARRAY_SIZE >= 0 ? ARRAY_SIZE * (ARRAY_SIZE + 1) : ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE)))) - ((((ARRAY_SIZE >= 0 ? i + 1 : ARRAY_SIZE - (i + 1)) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? j : ARRAY_SIZE - j)) - (ARRAY_SIZE >= 0 ? (ARRAY_SIZE >= 0 ? ((ARRAY_SIZE + 1) * (ARRAY_SIZE + 1)) - 1 : ((ARRAY_SIZE + 1) * (1 - ARRAY_SIZE)) + (ARRAY_SIZE - 1)) : (ARRAY_SIZE >= 0 ? ((1 - ARRAY_SIZE) * (ARRAY_SIZE + 1)) + ((ARRAY_SIZE * (ARRAY_SIZE + 1)) - 1) : ((1 - ARRAY_SIZE) * (1 - ARRAY_SIZE)) + ((ARRAY_SIZE + (ARRAY_SIZE * (1 - ARRAY_SIZE))) - 1))))) * DATA_WIDTH+:DATA_WIDTH])
					);
				end
				assign y_i[((i * ARRAY_SIZE) + j) * ((DATA_WIDTH * 2) + $clog2(ARRAY_SIZE))+:(DATA_WIDTH * 2) + $clog2(ARRAY_SIZE)] = accum_wire[((i * ARRAY_SIZE) + j) * ((DATA_WIDTH * 2) + $clog2(ARRAY_SIZE))+:(DATA_WIDTH * 2) + $clog2(ARRAY_SIZE)];
				assign valid_out[(i * ARRAY_SIZE) + j] = valid_wire[((ARRAY_SIZE >= 0 ? i : ARRAY_SIZE - i) * (ARRAY_SIZE >= 0 ? ARRAY_SIZE + 1 : 1 - ARRAY_SIZE)) + (ARRAY_SIZE >= 0 ? j + 1 : ARRAY_SIZE - (j + 1))];
			end
		end
	endgenerate
endmodule
module sram (
	clk,
	n_rst,
	addr,
	din,
	we,
	dout
);
	parameter DEPTH = 16;
	parameter DATA_WIDTH = 8;
	input wire clk;
	input wire n_rst;
	input wire [$clog2(DEPTH) - 1:0] addr;
	input wire [DATA_WIDTH - 1:0] din;
	input wire we;
	output reg [DATA_WIDTH - 1:0] dout;
	reg [DATA_WIDTH - 1:0] mem [0:DEPTH - 1];
	always @(posedge clk or negedge n_rst)
		if (!n_rst)
			dout <= 1'sb0;
		else if (we)
			mem[addr] <= din;
		else
			dout <= mem[addr];
endmodule
module sram_controller (
	clk,
	n_rst,
	start,
	weight_in,
	we,
	stream_en,
	addr,
	din
);
	reg _sv2v_0;
	parameter DATA_WIDTH = 8;
	parameter DEPTH = 16;
	input wire clk;
	input wire n_rst;
	input wire start;
	input wire [DATA_WIDTH - 1:0] weight_in;
	output wire we;
	output wire stream_en;
	output wire [$clog2(DEPTH) - 1:0] addr;
	output wire [DATA_WIDTH - 1:0] din;
	reg [2:0] state;
	reg [2:0] next_state;
	wire weights_loaded;
	wire drain_fin;
	flex_counter w_ctr(
		.clk(clk),
		.n_rst(n_rst),
		.en((state == 3'd1) || (state == 3'd2)),
		.rollover_flag(weights_loaded),
		.count(addr)
	);
	flex_counter #(.DEPTH(12)) drain(
		.clk(clk),
		.n_rst(n_rst),
		.en(state == 3'd2),
		.rollover_flag(drain_fin),
		.count()
	);
	always @(*) begin
		if (_sv2v_0)
			;
		next_state = state;
		case (state)
			3'd0:
				if (start)
					next_state = 3'd1;
			3'd1:
				if (weights_loaded)
					next_state = 3'd2;
			3'd2:
				if (drain_fin)
					next_state = 3'd3;
			3'd3: next_state = 3'd0;
			default: next_state = 3'd0;
		endcase
	end
	always @(posedge clk or negedge n_rst)
		if (!n_rst)
			state <= 3'd0;
		else
			state <= next_state;
	assign we = state == 3'd1;
	assign din = weight_in;
	assign stream_en = state == 3'd2;
	initial _sv2v_0 = 0;
endmodule
module top_level (
	clk,
	n_rst,
	start,
	w_in,
	x_in,
	valid_out,
	y_i
);
	parameter DATA_WIDTH = 8;
	parameter DEPTH = 16;
	parameter ARRAY_SIZE = 4;
	input wire clk;
	input wire n_rst;
	input wire start;
	input wire [DATA_WIDTH - 1:0] w_in;
	input wire [DATA_WIDTH - 1:0] x_in;
	output wire [(ARRAY_SIZE * ARRAY_SIZE) - 1:0] valid_out;
	output wire [((ARRAY_SIZE * ARRAY_SIZE) * ((DATA_WIDTH * 2) + $clog2(ARRAY_SIZE))) - 1:0] y_i;
	wire weight_buffer_full;
	wire input_buffer_full;
	wire stream_en;
	wire [(ARRAY_SIZE * DATA_WIDTH) - 1:0] weight_buff;
	wire [(ARRAY_SIZE * DATA_WIDTH) - 1:0] input_buff;
	wire [$clog2(DEPTH) - 1:0] addr;
	wire [ARRAY_SIZE - 1:0] valid_in;
	wire we;
	wire [DATA_WIDTH - 1:0] din;
	wire [DATA_WIDTH - 1:0] dout;
	reg valid_latched;
	flex_sr preload_weights(
		.clk(clk),
		.n_rst(n_rst),
		.en(stream_en),
		.data_in(dout),
		.data_out(weight_buff),
		.buffer_full(weight_buffer_full)
	);
	flex_sr preload_inputs(
		.clk(clk),
		.n_rst(n_rst),
		.en(stream_en),
		.data_in(x_in),
		.data_out(input_buff),
		.buffer_full(input_buffer_full)
	);
	sram_controller mem_contr(
		.clk(clk),
		.n_rst(n_rst),
		.start(start),
		.weight_in(w_in),
		.stream_en(stream_en),
		.we(we),
		.addr(addr),
		.din(din)
	);
	sram mem(
		.clk(clk),
		.n_rst(n_rst),
		.addr(addr),
		.din(din),
		.we(we),
		.dout(dout)
	);
	mac_cell_array array(
		.clk(clk),
		.n_rst(n_rst),
		.x_i(input_buff),
		.w_i(weight_buff),
		.valid_in(valid_in),
		.y_i(y_i),
		.valid_out(valid_out)
	);
	always @(posedge clk or negedge n_rst)
		if (!n_rst)
			valid_latched <= 1'sb0;
		else if (weight_buffer_full & input_buffer_full)
			valid_latched <= 1'sb1;
	assign valid_in = {ARRAY_SIZE {valid_latched}};
endmodule