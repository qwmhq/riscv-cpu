transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/db {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/db/PLL_altpll.v}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/KeypadScanner.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/SevenSegmentController.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/RegisterFile.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/ByteEnableEncoder.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/common_pkg.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/IpMem.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/Divider.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/Multiplier.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/PLL.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/LCDDriver.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/InstDecoder.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/ProgramCounter.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/ControlUnit.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/ALU.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/Memory.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/CPU.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/top.vhd}

