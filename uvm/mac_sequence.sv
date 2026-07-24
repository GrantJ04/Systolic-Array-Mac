class mac_sequence extends uvm_sequence #(mac_seq_item);
  `uvm_object_utils(mac_sequence);
  
  virtual task body();
    mac_seq_item tr;
    for(int i = 0; i < 50; i++) begin
      tr = mac_seq_item::type_id::create("tr");
      tr.randomize();
      start_item(tr);
      finish_item(tr);
    end
  endtask
endclass
