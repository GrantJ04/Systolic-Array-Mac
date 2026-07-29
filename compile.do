vlib work
vlog -sv +incdir+/home/grant/questa/questa_fse/verilog_src/uvm-1.2/src \
  /home/grant/questa/questa_fse/verilog_src/uvm-1.2/src/uvm_macros.svh \
  uvm/top.sv \
  uvm/mac_seq_item.sv \
  uvm/mac_sequence.sv \
  uvm/mac_driver.sv \
  uvm/mac_monitor.sv \
  uvm/mac_scoreboard.sv \
  uvm/mac_agent.sv \
  uvm/mac_env.sv \
  uvm/mac_test.sv \
  rtl/*.sv

vsim -c -do "run; exit" top