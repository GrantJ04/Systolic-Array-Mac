`timescale 1ns/1ps

module tb_mac_cell_array();
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

        logic [3:0][7:0] x_i, w_i;
        logic [3:0] valid_in;
        logic [3:0][3:0][17:0] y_i;
        logic [3:0][3:0] valid_out;

        mac_cell_array #() (
            .clk(clk),
            .n_rst(n_rst),
            .x_i(x_i),
            .w_i(w_i),
            .valid_in(valid_in),
            .y_i(y_i),
            .valid_out(valid_out)
        );

        
endmodule
