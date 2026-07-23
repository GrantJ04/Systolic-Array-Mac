class mac_driver extends uvm_driver #(mac_seq_item);
   
    `uvm_component_utils(mac_driver)

    virtual mac_if vif;
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);

            //drive dut

            seq_item_port.item_done();
        end
    endtask

endclass