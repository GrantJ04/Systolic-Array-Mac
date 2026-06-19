`timescale 1ns/1ps

module tb_sram();
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

    logic [3:0] addr;
    logic [7:0] din, dout;
    logic we;

    sram #() DUT (
        .clk(clk),
        .n_rst(n_rst),
        .addr(addr),
        .din(din),
        .we(we),
        .dout(dout)
    );

    string test_name;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_mac_cell_array);

        addr = '0;
        din = '0;
        we = 0;

        test_name = "RESET TEST";
        
        reset_dut();
        if(dout !== '0) $display("%s FAILED", test_name);
        $finish;
    end
    
endmodule
