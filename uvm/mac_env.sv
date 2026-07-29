class mac_env extends uvm_env;
  `uvm_component_utils(mac_env);

  mac_agent agent;
  mac_scoreboard scoreboard;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_build_phase phase);
    agent = mac_agent::type_id::create("agent",this);
    scoreboard = mac_scoreboard::type_id::create("scoreboard",this);
  endfunction

  virtual function void connect_phase(uvm_connect_phase phase);
    super.connect_phase(phase);
    agent.monitor.ap.connect(scoreboard.in);
  endfunction
endclass
