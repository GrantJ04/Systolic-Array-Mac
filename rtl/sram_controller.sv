`timescale 1ns/1ps
typedef enum logic[2:0]{
    IDLE, 
    LOAD_WEIGHTS,
    STREAM_INPUT,
    OUTPUT_READY
} state_t;

module sram_controller #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16
)(
    input logic clk,
    input logic n_rst,
    input logic start,
    input logic [DATA_WIDTH-1:0] weight_in,
    output logic we, stream_en,
    output logic [$clog2(DEPTH)-1:0] addr,
    output logic [DATA_WIDTH-1:0] din
);
    state_t state, next_state;
    logic weights_loaded, drain_fin;

    flex_counter #() w_ctr(
        .clk(clk),
        .n_rst(n_rst),
        .en(state == LOAD_WEIGHTS || state == STREAM_INPUT),
        .rollover_flag(weights_loaded),
        .count(addr)
    );

    flex_counter #(.DEPTH(12)) drain(
        .clk(clk),
        .n_rst(n_rst),
        .en(state == STREAM_INPUT),
        .rollover_flag(drain_fin),
        .count()
    );

    always_comb begin
        next_state = state;
        case(state)
        IDLE: begin
            if(start) next_state = LOAD_WEIGHTS;
        end
        LOAD_WEIGHTS: begin
            if(weights_loaded) next_state = STREAM_INPUT;
        end
        STREAM_INPUT: begin
            if(drain_fin) next_state = OUTPUT_READY;
        end
        OUTPUT_READY: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
        endcase
    end

    always_ff @(posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    assign we = (state == LOAD_WEIGHTS);
    assign din = weight_in;
    assign stream_en = (state == STREAM_INPUT);

endmodule
