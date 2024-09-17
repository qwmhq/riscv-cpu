# RISC-V assembly program to compute 12^3 + 1 and save the result in t4

# load the registers with required values
addi t1, zero, 1	# t1 = 1
addi t2, zero, 12	# t2 = 12
addi t3, zero, 12	# t3 = 12

#perform the arithmetic operations
mul t3, t2, t2	# t3 = 12 * 12
mul t3, t3, t2	# t3 = 12 * 12 * 12
add t4, t3, t1	# 12^3 + 1


/*
	00100313
	00c00393
	00c00e13
	02738e33
	027e0e33
	006e0eb3	
*/
