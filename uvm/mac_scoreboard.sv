class mac_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(mac_scoreboard);

  uvm_analysis_imp #(mac_seq_item, mac_scoreboard) in;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_build_phase phase);
    super.build_phase(phase);
    in = new("in", this);
  endfunction

  virtual function void write(mac_seq_item tr);
    if(tr.valid_out) begin
      if(tr.y_i == '0) begin
        uvm_error("SCOREBOARD", "Output y_i should not be zero when valid_out is high");
        end
    end
    
  endfunction
endclass
  
