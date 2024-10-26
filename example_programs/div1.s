# risc-v assemly code to divide -50 by 3.

main:
	addi t0 , zero , -50	# t0 = -50
	addi t1 , zero , 3 		# t1 = 3
	div t2 , t0 , t1		# quotient in t2
	rem t3 , t0 , t1		# remainder in t3
