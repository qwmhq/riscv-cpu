transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/RegisterFile.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/ByteEnableEncoder.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/ALU.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/common_pkg.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/IPRAM.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/IPRAM2.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/InstDecoder.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/RAM.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/InstMem.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/ProgramCounter.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/ControlUnit.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/CPU.vhd}
vcom -2008 -work work {/home/quwam/programming-stuff/cpu-stuff/riscv-cpu/src/top.vhd}

