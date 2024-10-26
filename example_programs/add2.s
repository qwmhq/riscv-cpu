# RISC-V assembly program to compute 4 + 5 - 19
.main:
	addi x5, x0, 4	# load 4 into x5
	addi x6, x0, 5	# load 5 into x6
	add x7, x5, x6		# x7 = x5 + x6
	addi x7, x7, -19	# subtract 19 from t2
	sw x7, 8(x0)	# store x7 into memory location 8

