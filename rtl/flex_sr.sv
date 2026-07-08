`timescale 1ns/1ps

module flex_sr #(
    parameter DATA_WIDTH = 8,
    parameter ARRAY_SIZE = 4
)(
    input logic clk,
    input logic n_rst,
    input logic en,
    input logic [DATA_WIDTH-1:0] data_in,
    output logic [ARRAY_SIZE-1:0][DATA_WIDTH-1:0] data_out,
    output logic buffer_full
);
    flex_counter #(.DEPTH(ARRAY_SIZE)) 
    buffer_full_counter (
        .clk(clk),
        .n_rst(n_rst),
        .en(en),
        .rollover_flag(buffer_full),
        .count()
    );

    always_ff @(posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            data_out <= '0;
        end else begin
            data_out <= {data_out[ARRAY_SIZE-2:0], data_in};
        end
    end

endmodule