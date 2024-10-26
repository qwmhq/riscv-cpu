# risc-v assembly code to create a copy of a 10-element array

.main :
	addi t1, zero, 0	# counter (t1) = 0
	addi t2, zero, 10	# number of iterations

.loop :
	lw t0, 0(a1)		# load an element from the source array
	sw t0, 0(a2)		# store an element in the destination array

	addi a1, a1, 4		# get the address of the next element : src array
	addi a2, a2, 4		# destination array
	addi t1, t1, 1		# increment the counter
	bne t1, t2, .loop	# loop back
