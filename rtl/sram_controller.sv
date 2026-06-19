`timescale 1ns/1ps
typedef enum logic[2:0]{
    IDLE, 
    LOAD_WEIGHTS,
    STREAM_INPUT,
    OUTPUT_READY
} state_t;

module sram_controller #()(
    input clk,
    input n_rst,
    
);
    state_t state, next_state;

    always_comb begin

    end

    always_ff @(posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

endmodule
