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
  
  logic [7:0] x_history[$];
  logic [7:0] w_history[$];

  virtual function void write(mac_seq_item tr);
    x_history.push_back(tr.x_in);
    w_history.push_back(tr.w_in);
    if(x_history.size() > 4) x_history.pop_front();
    if(w_history.size() > 4) w_history.pop_front();
    for(int i = 0; i < 4; i++) begin
      for(int j = 0; j < 4; j++) begin
        if(tr.valid_out[i][j]) begin
          logic [17:0] expected = 0;
          for(int k = 0; k <= j && k < x_history.size(); k++) begin
            expected += tr.w_in * x_history[k];
          end
          if(tr.y_i[i][j] != expected) begin
            uvm_error("SCOREBOARD", $sformatf(
              "Cell[%0d][%0d]: Expected %0d, got %0d",
              i, j, expected, tr.y_i[i][j]
            ));
          end
        end
      end
    end
  endfunction
endclass
  
