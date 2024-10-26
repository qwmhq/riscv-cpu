# RISC-V assembly program to swap two numbers stored in x1 and x2

add x3, x0, x1	# x3 = x1
add x1, x0, x2	# x1 = x2
add x2, x0, x3	# x2 = x3 (old x1)

/* machine code
	001001b3
	002000b3
	00300133
*/
