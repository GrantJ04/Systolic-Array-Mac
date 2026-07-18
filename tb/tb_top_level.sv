`timescale 1ns/1ps



module tb_top_level();

	localparam CLK_PERIOD = 10ns; //safe time value to use (analysis will show fastest)

	initial begin
		$dumpfile("waveform.vcd");
		$dumpvars;
	end

	logic clk, n_rst;
	
	//clockgen
	always begin
		clk = 0;
		#(CLK_PERIOD / 2.0);
		clk = 1;
		#(CLK_PERIOD / 2.0);
	end
	

	task reset_dut;
	begin
	 	n_rst = 0;
         	@(posedge clk);
         	@(posedge clk);
         	@(negedge clk);
         	n_rst = 1;
         	@(posedge clk);
         	@(posedge clk);
    	end
      endtask
    localparam DATA_WIDTH = 8, DEPTH = 16, ARRAY_SIZE = 4;
	logic start;
	logic [DATA_WIDTH-1:0] w_in, x_in;
    logic [ARRAY_SIZE-1:0][ARRAY_SIZE-1:0] valid_out;
    logic [ARRAY_SIZE-1:0][ARRAY_SIZE-1:0][DATA_WIDTH * 2 + $clog2(ARRAY_SIZE)-1:0]  y_i;
	top_level #() DUT (.clk(clk),.n_rst(n_rst),.start(start),.w_in(w_in),.x_in(x_in),.valid_out(valid_out),.y_i(y_i));
	string test_name;
	
	initial begin
		n_rst = 1;
		reset_dut;
		start = 0;
		w_in = '0;
		x_in = '0;

		test_name = "RESET TEST";
		if(y_i != '0 || valid_out != '0) $display("%s FAILED", test_name);
		
		test_name = "FULL TEST";
		
		start = 1;
		@(posedge clk);
		start = 0;
		for(int i = 0; i < 16; i++) begin
			w_in = i[7:0];
			@(posedge clk);
		end

		for(int i = 0; i < 16; i++) begin
			x_in = i[7:0];
			@(posedge clk);
		end

		if(valid_out !== '1) $display("%s FAILED - valid_out", test_name);
		
		
		
				
		$finish;	
	end
endmodule
	