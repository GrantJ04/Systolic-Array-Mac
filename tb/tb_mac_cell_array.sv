`timescale 1ns/1ps
typedef struct packed {
        logic [3:0][3:0][17:0] y_i_exp;
        logic [3:0][3:0] valid_out_exp;
} test_vector_t;

module tb_mac_cell_array();
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

        logic [3:0][7:0] x_i, w_i;
        logic [3:0] valid_in;
        logic [3:0][3:0][17:0] y_i;
        logic [3:0][3:0] valid_out;

        mac_cell_array #() DUT (
            .clk(clk),
            .n_rst(n_rst),
            .x_i(x_i),
            .w_i(w_i),
            .valid_in(valid_in),
            .y_i(y_i),
            .valid_out(valid_out)
        );

        test_vector_t test_vectors[5];
        int i, j;
        string test_name;

        initial begin
                //set initials
                $dumpfile("waveform.vcd");
                $dumpvars(0, tb_mac_cell_array);
                valid_in = '0;
                x_i = '0;
                w_i = '0;

                //RESET TEST
                reset_dut();
                test_name = "RESET TEST";
                if(y_i !== '0 || valid_out !== '0) $display("%s FAILED", test_name);
                

                test_name = "FULL MATRIX MULT. TEST";
                x_i = '0;
                w_i = '0;
                for(i = 0; i < 4; i++) begin
                        x_i[i] = 8'd1;
                        w_i[i] = 8'd1;
                end
                
                //cycle thru all cells

                repeat(12)@(posedge clk); //cycles + buffer
                for(i = 0; i < 4;i++) begin
                        for(j = 0; j < 4; j++) begin
                                if(y_i[i][j] !== 18'(j+1)) begin
                                        $display("%s FAILED @ [%0d][%0d] got %0d, exp %0d", test_name, i, j, y_i[i][j],j+1);
                                end
                        end
                end

                reset_dut();
                test_name = "VALID PROP. TEST";
                valid_in = '1;
                repeat(12)@(posedge clk);

                if(valid_out !== '1) $display("%s FAILED", test_name);
                

                $finish;
        end
endmodule
