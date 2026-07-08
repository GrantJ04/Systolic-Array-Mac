`timescale 1ns/1ps

module tb_flex_sr();
    localparam CLK_PERIOD = 10ns; //safe time value to use (analysis will show fastest)                                                                                                                                                                                                                                                 

                                                                                                                                                                                                                                    
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

        logic en, buffer_full;
        logic [7:0] data_in;
        logic [3:0][7:0] data_out;

        flex_sr #() DUT (
            .clk(clk),
            .n_rst(n_rst),
            .en(en),
            .data_in(data_in),
            .data_out(data_out),
            .buffer_full(buffer_full)
        );

        string test_name;
        int i;
        logic [3:0][7:0] test_vec;

        initial begin
                //set initials
                $dumpfile("waveform.vcd");
                $dumpvars(0, tb_flex_sr);
               
               test_name = "RESET TEST";
               en = 0;
               data_in = '0;
               test_vec = '{8'hAA, 8'hBB, 8'hCC, 8'hDD};

               reset_dut;

               if(data_out !== '0 || buffer_full) $display("%s FAILED", test_name);

               test_name = "LOAD 4 VALS TEST";
               en = 1;
               data_in = 8'hAA;
               @(posedge clk);
               data_in = 8'hBB;
               @(posedge clk);
               data_in = 8'hCC;
               @(posedge clk);
               data_in = 8'hDD;
               @(posedge clk);

               for(i = 0; i < 4; i++) begin
                if(data_out[i] != test_vec[i]) $display("%s FAILED: %0d", test_name, i);
               end
               test_name = "BUFFER FULL CHECK";
               if(!buffer_full) $display("%s FAILED", test_name);

                $finish;
        end
endmodule
