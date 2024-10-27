
.main:
	addi x5, x0, 0x69
	addi x6, x0, 0x420
	sw x5, 40(x0)
	sw x6, 44(x0)
	lw x7, 40(x0)
	lw x8, 44(x0)
