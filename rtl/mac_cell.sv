`timescale 1ns/1ps
//Individual MAC Cell module
module mac_cell #(
	parameter DATA_WIDTH = 8,
	parameter ARRAY_SIZE = 4
	) (
	input logic clk, n_rst,
	input logic [DATA_WIDTH-1:0] x_i, w_i,
	input logic [DATA_WIDTH*2 + $clog2(ARRAY_SIZE) - 1 : 0] accum_in,
	input logic valid_in,
	output logic valid_out,
	output logic [DATA_WIDTH * 2 + $clog2(ARRAY_SIZE) - 1: 0] y_i
	);
	
	logic [DATA_WIDTH * 2 - 1: 0] mult_res, mult_res_reg;
	logic [DATA_WIDTH * 2 + $clog2(ARRAY_SIZE) - 1: 0] accum_res, mult_reg_ext;
	logic valid_stage1;
	//stage 1 (multiply)
	always_comb begin: multiply_block
		mult_res = w_i * x_i;
	end

	always_ff @(posedge clk, negedge n_rst) begin
		if(!n_rst) begin
			mult_res_reg <= '0;
			valid_stage1 <= '0;
		end else begin
			mult_res_reg <= mult_res;
			valid_stage1 <= valid_in;
		end
	end

	//stage 2 (accumulate)
	always_comb begin: accumulator_block
		mult_reg_ext = {2'b0, mult_res_reg};
		accum_res = mult_reg_ext + accum_in; //tool already accounts for needed sign ext
	end
	
	always_ff @(posedge clk, negedge n_rst) begin
		if(!n_rst) begin
			y_i <= '0;
			valid_out <= '0;
		end else begin
			y_i <= accum_res;
			valid_out <= valid_stage1;
		end
	end		
endmodule
