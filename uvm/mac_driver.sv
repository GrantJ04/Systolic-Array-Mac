class mac_driver extends uvm_driver #(mac_seq_item);
   
    `uvm_component_utils(mac_driver)

    virtual mac_if vif;
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db #(virtual mac_if)::get(this,"","vif",vif)) begin
         `uvm_fatal(get_type_name(), "Did not get handle to virtual interface mac_if")
      end
    endfunction
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
       reg_transaction tr;
        forever begin
           seq_item_port.get_next_item(tr);
           @(posedge vif.clk);
           vif.start = tr.start;
           vif.w_in = tr.w_in;
           vif.x_in = tr.x_in;
           @(posedge vif.clk);
           
           //now drive parts for outputs

            seq_item_port.item_done();
        end
    endtask
endclass
