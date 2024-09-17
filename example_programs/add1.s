# RISC-V assembly program to add 409932 + 409823

.text
.main:
	lui t0, 100			# t0 = 4096 * 100 = 409600
	addi t0, t0, 332	# t0 = t0 + 332
	lui t1, 100			# t1 = 4096 * 100 = 409600
	addi t1, t1, 223	# t1 = t1 + 223
	add t2, t0, t1		# t2 = t0 + t1

# machine code:
# 000642b7
# 14c28293
# 00064337
# 0df30313
# 006283b3
