# =========================
# Verilator Flow
# =========================

RTL_DIR := rtl
TB_DIR  := tb

MODULE  ?= mac_cell
TOP     := tb_$(MODULE)

RTL_FILES := $(RTL_DIR)/mac_cell.sv $(RTL_DIR)/mac_cell_array.sv
TB  := $(TB_DIR)/$(TOP).sv

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