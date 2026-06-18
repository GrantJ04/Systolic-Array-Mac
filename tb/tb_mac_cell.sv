`timescale 1ns/1ps

typedef struct packed {
        logic valid_out_exp;
        logic [17:0] y_exp_o;
} test_vector_t;                                                                                                                                                                                                                                                                                                                        

module tb_mac_cell();                                                                                                                                                                                                                                                                                                                   
        localparam CLK_PERIOD = 10ns; //safe time value to use (analysis will show fastest)                                                                                                                                                                                                                                                 

        initial begin                                                                                                                                                                                                                                   
                $dumpfile("waveform.vcd");                                                                                                                                                                                                              
                $dumpvars(0, tb_mac_cell);                                                                                                                                                                                                        
        end                                                                                                                                                                                                                                     
        logic clk, n_rst;                                                                                                                                                                                                                               
        //clockgen                                                                                                                                                                                                                              
        always begin                                                                                                                                                                                                                                    
                clk <= 0;                                                                                                                                                                                                                                       
                #(CLK_PERIOD / 2.0);                                                                                                                                                                                                                            
                clk <= 1;                                                                                                                                                                                                                                       
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

        logic valid_in, valid_out;                                                                                                                                                                                                                      
        logic [7:0] x_i, w_i, x_out, w_out;                                                                                                                                                                                                                           
        logic [17:0] accum_in, y_i;                                                                                                                                                                                                                     

        mac_cell #() DUT ( //only testing 8 bit inputs/weights and 4x4 structure here                                                                                                                                                                                                                                           
                .clk(clk),                                                                                                                                                                                                             	             .n_rst(n_rst),                                                                                                                                                                                                                       .x_i(x_i),                                                                                                                   
                .w_i(w_i),                                                                                                                                                                               
                .accum_in(accum_in),                                                                                                                                                                                       
                .valid_in(valid_in),                                                                                                                                                                                  
                .valid_out(valid_out),                                                                                                                                                                                                        	     .y_i(y_i),
		.x_out(x_out),
		.w_out(w_out)		
        );                                                                                                                                                                                                                                      

        string test_name;                                                                                                                                                                                                                               
        test_vector_t test_vectors[5];                                                                                                                                                                                                                  

        initial begin
                // Global Initializations
                x_i      = '0;
		w_i      = '0;
                accum_in = '0;
                valid_in = '0;
               $display("Starting tests..."); 
               test_name = "RESET TEST";
               reset_dut();
               if(y_i !== 18'b0 || valid_out !== 1'b0) begin
                       $display("%s: Failed", test_name);
               end else begin
                       $display("%s: Passed", test_name);
               end

               test_name = "SINGLE MAC TEST";
               reset_dut();
               
               test_vectors[0] = {1'b1, 18'd2550};

               x_i      = 8'b00001111;
               w_i      = 8'b10101010;
               accum_in = '0;
               valid_in = 1'b1;

               @ (posedge clk);
	       @(posedge clk);
               valid_in = 1'b0;
               x_i      = '0;
               w_i      = '0;

               @ (negedge clk); 
               if(y_i !== test_vectors[0].y_exp_o || valid_out !== test_vectors[0].valid_out_exp) begin
                       $display("%s: Failed", test_name);
               end else begin
                       $display("%s: Passed", test_name);
               end

               test_name = "VALID PROPG.";
               reset_dut();
               $display("Reset done, starting matrix test...");
               test_vectors[1] = {1'b1, 18'b0};

               x_i      = '0;
               w_i      = '0;
               accum_in = '0;
               valid_in = 1'b1;

               @(posedge clk);
	       @(posedge clk);
               valid_in = 1'b0;

               @(negedge clk);
               if(valid_out !== test_vectors[1].valid_out_exp) begin
                       $display("%s: Failed", test_name);
               end else begin
                       $display("%s: Passed", test_name);
               end

                test_name = "B2B OPS";
                reset_dut();

                test_vectors[2] = {1'b1, 18'd15};
                test_vectors[3] = {1'b1, 18'd31};

                x_i      = 8'h04;
                w_i      = 8'h02;
                accum_in = 18'h15;
                valid_in = 1'b1;

                @ (posedge clk);
                
                x_i      = 8'h04;
                w_i      = 8'h05;
                accum_in = 18'h17;
                valid_in = 1'b1;

                @ (posedge clk);
                valid_in = 1'b0;
                x_i      = '0;
                w_i      = '0;
                accum_in = '0;

                if(y_i !== test_vectors[3].y_exp_o) begin
                        $display("%s: Failed", test_name);
                end else begin
                        $display("%s: Passed", test_name);
                end

                test_name = "MAX INPUT TEST";
                reset_dut();

                test_vectors[4] = {1'b1, 18'h0FE01};

                @ (posedge clk);
                x_i      = 8'hFF;
                w_i      = 8'hFF;
                accum_in = '0;
                valid_in = 1'b1;

                @ (posedge clk);
                valid_in = 1'b0;
                x_i      = '0;
                w_i      = '0;

                @(negedge clk);

                if(y_i !== test_vectors[4].y_exp_o) begin
                        $display("%s: Failed", test_name);
                end else begin
                        $display("%s: Passed", test_name);
                end

                $finish;
        end
endmodule
