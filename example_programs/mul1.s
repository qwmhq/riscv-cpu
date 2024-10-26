# RISC-V assembly program to multiply 3 with -17 and save the result in t3


.main:
	addi t1, zero, 3	# t1 = 3
	addi t2, zero, -17	# t2 = -17
	mul t3, t1, t2		# t3 = t1 * t2

