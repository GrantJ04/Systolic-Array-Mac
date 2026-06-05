# Directories
RTL_DIR := rtl
TB_DIR  := tb
SIM_DIR := sim
OBJ_DIR := obj_dir

# Top module and files
TOP_MODULE := tb_mac_cell
TB_FILE    := $(TB_DIR)/tb_mac_cell.sv
RTL_FILE   := $(RTL_DIR)/mac_cell.sv
SIM_EXE    := $(SIM_DIR)/$(TOP_MODULE)
WAVE_FILE  := $(SIM_DIR)/waveform.vcd

# Verilator Flags
# Include standard search paths if your testbench includes or instantiates the RTL
VERILATOR_FLAGS := --binary --trace -sv -Wall --Mdir $(OBJ_DIR) -I$(RTL_DIR) -I$(TB_DIR)

# Default target
.PHONY: all
all: $(SIM_EXE)

# Build the simulator executable
$(SIM_EXE): $(RTL_FILE) $(TB_FILE)
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(SIM_DIR)
	verilator $(VERILATOR_FLAGS) --top-module $(TOP_MODULE) $(RTL_FILE) $(TB_FILE) -o ../$(SIM_EXE)

# Run the simulation
.PHONY: run_mac
run_mac: $(SIM_EXE)
	@echo "== Running Simulation =="
	cd $(SIM_DIR) && ./$(TOP_MODULE)

# Open waveforms in GTKWave
.PHONY: wave_mac
wave_mac:
	@if [ -f $(WAVE_FILE) ]; then \
		gtkwave $(WAVE_FILE) & \
	else \
		echo "Error: $(WAVE_FILE) not found. Run 'make run_mac' first."; \
	fi

# Clean build artifacts
.PHONY: clean
clean:
	rm -rf $(OBJ_DIR) $(SIM_DIR)
