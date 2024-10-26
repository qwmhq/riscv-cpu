# RISC-V assembly program to compute the factorial of a positive number stored in a1, saving the result in a0

.main:
	addi a1, zero, 6	# a1 = 6
	addi a0, zero, 1	# prod = 1
	addi t0, zero, 1	# index = 1

.loop:
	mul a0, a0, t0		# prod = prod * index
	addi t0, t0, 1		# index++
	bge	a1, t0, .loop	# loop condition


#  assembly code:
#	00600593
#	00100513
#	00100293
#	02550533
#	00128293
#	fe55dce3

