class mac_monitor extends uvm_monitor;
  `uvm_component_utils(mac_monitor)
  virtual mac_if.monitor vif;
  uvm_analysis_port #(mac_seq_item) ap;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_build_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
    if(!uvm_config_db #(virtual mac_if)::get(this,"","vif",vif)) begin
         `uvm_fatal(get_type_name(), "Did not get handle to virtual interface mac_if")
    end
  endfunction

  virtual task run_phase(uvm_run_phase phase);
    mac_seq_item tr;
    forever begin
      tr = mac_seq_item::type_id::create("tr");
      @(posedge vif.clk);
      tr.valid_out = vif.valid_out;
      tr.y_i = vif.y_i;
      ap.write(tr);
    end
  endtask
endclass
