GHDL=ghdl
FLAGS="--std=08"
GTKWAVE=gtkwave
VSIM=vsim

common:
	@$(GHDL) -a $(FLAGS) src/common_pkg.vhd

alteramf:
	@$(GHDL) -a $(FLAGS) 

registerfile: common
	@$(GHDL) -a $(FLAGS) src/RegisterFile.vhd tb/RegisterFile_TB.vhd
	@$(GHDL) -e $(FLAGS) RegisterFile_TB
	@$(GHDL) -r $(FLAGS) RegisterFile_TB --wave=waves/registerfile_wave.ghw --stop-time=10000ns

alu:
	@$(GHDL) -a $(FLAGS) src/ALU.vhd tb/ALU_TB.vhd
	@$(GHDL) -e $(FLAGS) ALU_TB
	@$(GHDL) -r $(FLAGS) ALU_TB --wave=waves/alu_wave.ghw --stop-time=10000ns

programcounter: common
	@$(GHDL) -a $(FLAGS) src/ProgramCounter.vhd tb/ProgramCounter_TB.vhd
	@$(GHDL) -e $(FLAGS) ProgramCounter_TB
	@$(GHDL) -r $(FLAGS) ProgramCounter_TB --wave=waves/programcounter_wave.ghw --stop-time=10000ns

memory:
	@$(VSIM) -c -do tcl/sim_memory.tcl
	
instdecoder: common
	@$(GHDL) -a $(FLAGS) src/InstDecoder.vhd tb/InstDecoder_TB.vhd
	@$(GHDL) -e $(FLAGS) InstDecoder_TB
	@$(GHDL) -r $(FLAGS) InstDecoder_TB --wave=waves/instdecoder_wave.ghw --stop-time=10000ns

controlunit:
	@$(GHDL) -a $(FLAGS) src/ControlUnit.vhd tb/ControlUnit_TB.vhd
	@$(GHDL) -e $(FLAGS) ControlUnit_TB
	@$(GHDL) -r $(FLAGS) ControlUnit_TB --wave=waves/controlunit_wave.ghw --stop-time=10000ns

cpu: common instdecoder alu registerfile controlunit programcounter memory
	@$(GHDL) -a $(FLAGS) src/CPU.vhd tb/CPU_TB.vhd
	@$(GHDL) -e $(FLAGS) CPU_TB
	@$(GHDL) -r $(FLAGS) CPU_TB --wave=waves/cpu_wave.ghw --stop-time=10000ns

top: 
	$(VSIM) -c -do tcl/sim_top.tcl

sevensegctrl:
	@$(GHDL) -a $(FLAGS) src/SevenSegmentController.vhd tb/SevenSegmentController_TB.vhd
	@$(GHDL) -e $(FLAGS) SevenSegmentController_TB
	@$(GHDL) -r $(FLAGS) SevenSegmentController_TB --wave=waves/sevensegctrl_wave.ghw --stop-time=10000ns

keypad:
	@$(GHDL) -a $(FLAGS) src/KeypadScanner.vhd tb/KeypadScanner_TB.vhd
	@$(GHDL) -e $(FLAGS) KeypadScanner_TB
	@$(GHDL) -r $(FLAGS) KeypadScanner_TB --wave=waves/keypad_wave.ghw --stop-time=10000ms

lcddriver:
	@$(GHDL) -a $(FLAGS) src/LCDDriver.vhd tb/LCDDriver_TB.vhd
	@$(GHDL) -e $(FLAGS) LCDDriver_TB
	@$(GHDL) -r $(FLAGS) LCDDriver_TB --wave=waves/lcddriver_wave.ghw --stop-time=10000ns


clean:
	@$(GHDL) --clean
	@rm waves/*.ghw waves/*.vcd
