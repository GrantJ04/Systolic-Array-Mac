`timescale 1ns/1ps

//MAC Cell Array Module
module mac_cell_array #(
	parameter DATA_WIDTH = 8,
	parameter ARRAY_SIZE = 4
) (	
	input logic clk,
	input logic n_rst,
	input logic [ARRAY_SIZE-1:0][DATA_WIDTH-1:0] x_i, w_i,
	input logic [ARRAY_SIZE-1:0] valid_in,
	output logic [ARRAY_SIZE-1:0][ARRAY_SIZE-1:0][DATA_WIDTH * 2 + $clog2(ARRAY_SIZE)-1:0] y_i,
	output logic [ARRAY_SIZE-1:0][ARRAY_SIZE-1:0] valid_out
);
	genvar i;
	genvar j;

	logic [ARRAY_SIZE:0][ARRAY_SIZE:0][DATA_WIDTH-1:0] x_wire, w_wire; //added extra col & row for final outputs
	logic [ARRAY_SIZE-1:0][ARRAY_SIZE-1:0][DATA_WIDTH * 2 + $clog2(ARRAY_SIZE)-1:0] accum_wire;
	logic [ARRAY_SIZE:0][ARRAY_SIZE:0] valid_wire;
	

	//Load initial inputs and weights into respective positions
	generate //Top
          for(i = 0; i < ARRAY_SIZE; i++) begin
		assign w_wire[0][i] = w_i[i];
	  end

	 //Left
          for(i = 0; i < ARRAY_SIZE; i++) begin
		assign x_wire[i][0] = x_i[i];
		assign valid_wire[i][0] = valid_in[i];
		
	  end

	  for (i = 0; i < ARRAY_SIZE; i++) begin
		for(j = 0; j < ARRAY_SIZE; j++) begin
			if(j == 0) begin: init_col
				mac_cell #(
					.DATA_WIDTH(DATA_WIDTH),
					.ARRAY_SIZE(ARRAY_SIZE)
				   	)
				cell_inst(
					.clk(clk),
					.n_rst(n_rst),
					.x_i(x_wire[i][j]),
					.w_i(w_wire[i][j]),
					.accum_in('0),
					.valid_in(valid_wire[i][j]),
					.valid_out(valid_wire[i][j+1]),
					.y_i(accum_wire[i][j]),
					.x_out(x_wire[i][j+1]),
					.w_out(w_wire[i+1][j])
					);
			end else begin: normal_cols
				mac_cell #(
					.DATA_WIDTH(DATA_WIDTH),
					.ARRAY_SIZE(ARRAY_SIZE)
				   	)
				cell_inst(
					.clk(clk),
					.n_rst(n_rst),
					.x_i(x_wire[i][j]),
					.w_i(w_wire[i][j]),
					.accum_in(accum_wire[i][j-1]),
					.valid_in(valid_wire[i][j]),
					.valid_out(valid_wire[i][j+1]),
					.y_i(accum_wire[i][j]),
					.x_out(x_wire[i][j+1]),
					.w_out(w_wire[i+1][j])
					);
			
				end
			assign y_i[i][j] = accum_wire[i][j];
			assign valid_out[i][j] = valid_wire[i][j+1];
			end
		end
	endgenerate
endmodule
