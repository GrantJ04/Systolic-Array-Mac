`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"

module top #() ();
   localparam CLK_PERIOD = 10ns;
  
   initial begin                                                                                                                                                                                                                                   
                $dumpfile("waveform.vcd");                                                                                                                                                                                                              
     $dumpvars(0, top);                                                                                                                                                                                                        
  end 

  logic clk, n_rst;
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

  mac_if vif(clk, n_rst);
  top_level #() DUT (.clk(clk),.n_rst(n_rst),.start(vif.start),.w_in(vif.w_in),.x_in(vif.x_in),.valid_out(vif.valid_out),.y_i(vif.y_i));
  
  uvm_config_db#(virtual mac_if)::set(null, "*", "vif", vif);
  
  initial begin
    reset_dut;
    run_test("mac_test");
    $finish;
  end
endmodule
