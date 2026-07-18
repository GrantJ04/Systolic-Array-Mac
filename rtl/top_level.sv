`timescale 10ns/1ps

module top_level #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16,
    parameter ARRAY_SIZE = 4
    ) (
    input logic clk, 
    input logic n_rst,
    input logic start,
    input logic [DATA_WIDTH-1:0] w_in, x_in,
    output logic [ARRAY_SIZE-1:0][ARRAY_SIZE-1:0] valid_out,
    output logic [ARRAY_SIZE-1:0][ARRAY_SIZE-1:0][DATA_WIDTH * 2 + $clog2(ARRAY_SIZE)-1:0] y_i
    );
     
    logic weight_buffer_full, input_buffer_full, stream_en;
    logic [ARRAY_SIZE-1:0][DATA_WIDTH-1:0] weight_buff, input_buff;
    logic [$clog2(DEPTH)-1:0] addr;
    logic [ARRAY_SIZE-1:0] valid_in;
    logic we;
    logic [DATA_WIDTH-1:0] din, dout;
    logic valid_latched;
    flex_sr #() preload_weights (.clk(clk),.n_rst(n_rst),.en(stream_en),.data_in(dout),.data_out(weight_buff),.buffer_full(weight_buffer_full));
    flex_sr #() preload_inputs (.clk(clk),.n_rst(n_rst),.en(stream_en),.data_in(x_in),.data_out(input_buff),.buffer_full(input_buffer_full));

    sram_controller #() mem_contr (.clk(clk),.n_rst(n_rst),.start(start),.weight_in(w_in),.stream_en(stream_en),.we(we),.addr(addr),.din(din));
    sram #() mem (.clk(clk),.n_rst(n_rst),.addr(addr),.din(din),.we(we),.dout(dout));

    mac_cell_array #() array (.clk(clk),.n_rst(n_rst),.x_i(input_buff),.w_i(weight_buff),.valid_in(valid_in),.y_i(y_i),.valid_out(valid_out));

    always_ff @(posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            valid_latched <= '0;
        end else if (weight_buffer_full & input_buffer_full) begin
            valid_latched <= '1;
        end
    end
    assign valid_in = {ARRAY_SIZE{valid_latched}};
endmodule
