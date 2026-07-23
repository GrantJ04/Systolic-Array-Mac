class mac_seq_item extends uvm_sequence_item;
    rand logic [7:0] w_in;
    rand logic [7:0] x_in;
    `uvm_object_utils(mac_seq_item)
    function new(string name = "mac_seq_item");
        super.new(name);
    endfunction
    constraint c_array {
        foreach(w_in[i]) w_in[i] inside {[1:50]};
        foreach(x_in[i]) x_in[i] inside {[1:50]};
    }
endclass
