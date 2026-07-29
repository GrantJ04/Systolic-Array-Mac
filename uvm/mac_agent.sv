class mac_agent extends uvm_agent;
  `uvm_component_utils(mac_agent);
  
  uvm_sequencer #(mac_seq_item) sequencer;
  mac_driver driver;
  mac_monitor monitor;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_build_phase phase);
    sequencer = uvm_sequencer#(mac_seq_item)::type_id::create("sequencer", this);
    driver = mac_driver::type_id::create("driver", this);
    monitor = mac_monitor::type_id::create("monitor", this);
  endfunction

  virtual function void connect_phase(uvm_connect_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);     
  endfunction
  
endclass
  
