# =========================
# Verilator Flow
# =========================

RTL_DIR := rtl
TB_DIR  := tb

MODULE ?= mac_cell
TOP    := tb_$(MODULE)

# Compile all RTL files automatically
RTL_FILES := $(wildcard $(RTL_DIR)/*.sv)

TB := $(TB_DIR)/$(TOP).sv

BUILD_DIR := obj_dir
EXEC := V$(TOP)
VCD := waveform.vcd

all: run

build:
	verilator --binary -sv $(RTL_FILES) $(TB) \
		--top-module $(TOP) \
		--Mdir $(BUILD_DIR)

run: build
	./$(BUILD_DIR)/$(EXEC)

build_wave:
	verilator --binary -sv $(RTL_FILES) $(TB) \
		--top-module $(TOP) \
		--trace \
		--Mdir $(BUILD_DIR)

wave: build_wave
	./$(BUILD_DIR)/$(EXEC)
	gtkwave $(VCD)

clean:
	rm -rf $(BUILD_DIR) $(VCD)


# =========================
# UVM Flow
# =========================

UVM_DIR := uvm
UVM_FILES := $(wildcard $(UVM_DIR)/*.sv)
UVM_TOP := top
UVM_EXEC := V$(UVM_TOP)

uvm_build:
	verilator --binary -sv +incdir+/usr/share/verilator/include/vltstd \
		-I/usr/share/verilator/include \
		$(RTL_FILES) $(UVM_FILES) \
		--top-module top \
		--trace \
		--Mdir $(BUILD_DIR)

uvm_sim: uvm_build
	./$(BUILD_DIR)/$(UVM_EXEC)
	gtkwave $(VCD)

uvm_run: uvm_build
	./$(BUILD_DIR)/$(UVM_EXEC)