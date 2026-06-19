`timescale 1ns/1ps

module flex_counter #(
    parameter DEPTH = 16
) (
    input logic clk,
    input logic n_rst,
    input logic en,
    output logic rollover_flag,
    output logic [$clog2(DEPTH)-1:0] count
);
    localparam CNT_WIDTH = $clog2(DEPTH);

    always_ff @(posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            count <= '0;
            rollover_flag <= 1'b0;
        end else begin
            rollover_flag <= en && (count == CNT_WIDTH'(DEPTH-1));
            if (en) begin
                if(count == CNT_WIDTH'(DEPTH-1)) begin
                    count <= '0;
                end else begin
                    count <= count + 1;
                end
            end
        end
    end

endmodule