# =========================
# Verilator Flow (Fixed)
# =========================

RTL_DIR := rtl
TB_DIR  := tb
TOP     := tb_mac_cell

RTL := $(RTL_DIR)/mac_cell.sv
TB  := $(TB_DIR)/tb_mac_cell.sv

BUILD_DIR := obj_dir
EXEC := V$(TOP)

VCD := waveform.vcd

# =========================
# Default
# =========================
all: run

# =========================
# Build (no trace)
# =========================
build:
	@echo "=== Building (no wave) ==="
	verilator --binary -sv $(RTL) $(TB) \
		--top-module $(TOP) \
		--Mdir $(BUILD_DIR)

# =========================
# Run (PRINT ONLY)
# =========================
run: build
	@echo "=== Running (prints only) ==="
	./$(BUILD_DIR)/$(EXEC)

# =========================
# Build WITH tracing
# =========================
build_wave:
	@echo "=== Building (with waveform trace) ==="
	verilator --binary -sv $(RTL) $(TB) \
		--top-module $(TOP) \
		--trace \
		--Mdir $(BUILD_DIR)

# =========================
# Run + generate VCD
# =========================
wave: build_wave
	@echo "=== Running (with wave dump) ==="
	./$(BUILD_DIR)/$(EXEC)

	@echo "=== Opening GTKWave ==="
	gtkwave $(VCD)

# =========================
# Clean
# =========================
clean:
	rm -rf $(BUILD_DIR) $(VCD)
