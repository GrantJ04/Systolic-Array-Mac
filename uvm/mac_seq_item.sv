class mac_seq_item extends uvm_sequence_item;
    rand logic [7:0] w_in;
    rand logic [7:0] x_in;
    rand logic start;
    `uvm_object_utils(mac_seq_item)
    function new(string name = "mac_seq_item");
        super.new(name);
    endfunction
    constraint c_array {
       w_in inside {[1:50]};
       x_in inside {[1:50]};
       start dist {0 :=95, 1:= 5};
    }
endclass
