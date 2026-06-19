`timescale 1ns/1ps

module sram #(
    parameter DEPTH = 16,
    parameter DATA_WIDTH = 8
)(
    input logic clk,
    input logic n_rst,
    input logic [$clog2(DEPTH)-1:0] addr,
    input logic [DATA_WIDTH-1:0] din,
    input logic we,
    output logic [DATA_WIDTH-1:0] dout
);

    logic [DATA_WIDTH-1:0] mem [DEPTH]; //our memory array for storing weights

    always_ff @(posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            dout <= '0;
            //currently not resetting mem for faster processing, though controller MUST write before read
        end else begin
            if(we) begin //write op
                mem[addr] <= din;
            end else begin //read op
                dout <= mem[addr];
            end
        end
    end

endmodule