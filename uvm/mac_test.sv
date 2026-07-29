import uvm_pkg::*;
`include "uvm_macros.svh"
class mac_test extends uvm_test;
  `uvm_component_utils(mac_test);

  mac_env env;
  mac_sequence seq;
  virtual function void build_phase(uvm_build_phase phase);
    super.build_phase(phase);
    env = mac_env::type_id::create("env", this);
  endfunction

  virtual task run_phase(uvm_run_phase phase);
    seq = mac_sequence::type_id::create("seq");
    phase.raise_objection(this);
    seq.start(env.agent.sequencer);
    phase.drop_objection(this);
  endtask
endclass
    
