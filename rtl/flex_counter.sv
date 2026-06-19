`timescale 1ns/1ps

module flex_counter #(
    parameter DEPTH = 16
) (
    input logic clk,
    input logic n_rst,
    input logic en,
    output logic rollover_flag
);
    logic [$clog2(DEPTH)-1:0] count;
    always_ff @(posedge clk) begin
        if(!n_rst) begin
            count <= '0;
            rollover_flag <= 1'b0;
        end else begin
            rollover_flag <= en && (count == DEPTH-1);
            if (en) begin
                if(count == DEPTH-1) begin
                    count <= '0;
                end else begin
                    count <= count + 1;
                end
            end
        end
    end

endmodule