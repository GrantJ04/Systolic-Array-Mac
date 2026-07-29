interface mac_if(input bit clk, input bit n_rst);
  logic start;
  logic [7:0] w_in, x_in;
  logic [3:0][3:0] valid_out;
  logic [3:0][3:0][17:0] y_i; 

  modport driver(
    input clk, n_rst,
    output start,w_in,x_in,
    input valid_out,y_i
  );

  modport monitor(
    input clk, n_rst, start, w_in, x_in, valid_out, y_i
  );
endinterface
