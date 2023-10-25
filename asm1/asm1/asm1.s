# asm1.s
# Author: Christopher Reid
#
# REGISTERS:
#
# s0: termporaries
# s1: so_far
#
# t0: 	minimum
# t1:	negate
# t2:	evens
# t3:	print
#
# t4: 	jan
# t5: 	feb
# t6: 	mar
# t7: 	apr
# t8: 	may
# t9: 	jun

.data
MINIMUM:      .asciiz "minimum: "
NEWLINE:      .asciiz "\n"
NEGATE:       .asciiz "NEGATE"
EVENS_START:  .asciiz "EVENS START"
EVENS_END:    .asciiz "EVENS END"
JAN:	      .asciiz "jan: "
FEB:	      .asciiz "feb: "
MAR:	      .asciiz "mar: "
APR:	      .asciiz "apr: "
MAY:	      .asciiz "may: "
JUN:	      .asciiz "jun: "

.text 
# PROLOGUE - starts a function.

.globl studentMain # Declares function studentMain().
studentMain:
	addiu 	$sp, $sp, -24 		# allocate stack space -- default of 24 here
	sw 	$fp, 0($sp) 		# save caller’s frame pointer
	sw 	$ra, 4($sp) 		# save return address
	addiu 	$fp, $sp, 20 		# setup main’s frame pointer
	
	la 	$t0, minimum		# t0 = &minimum 
	lw	$t0, 0($t0)		# t0 = minimum  
	
	la	$t1, negate		# t1 = &negate 
	lw	$t1, 0($t1)		# t1 = negate  
	
	la	$t2, evens		# t2 = &evens 
	lw	$t2, 0($t2)		# t2 = evens 
	
	la	$t3, print		# t3 = &print 
	lw	$t3, 0($t3)		# t3 = print  
	
	la	$t4, jan 		# t4 = &jan
	lw	$t4, 0($t4)		# t4 = jan
	
	la	$t5, feb		# t5 = &feb
	lw	$t5, 0($t5)		# t5 = feb
	
	la	$t6, mar		# t6 = &mar
	lw	$t6, 0($t6)		# t6 = mar
	
	la	$t7, apr		# t7 = &apr
	lw	$t7, 0($t7)		# t7 = apr
	
	la	$t8, may		# t8 = &may
	lw	$t8, 0($t8)		# t8 = may
	
	la	$t9, jun		# t9 = &jun
	lw	$t9, 0($t9)		# t9 = jun
		

# TASK 1 - minimum
#
# if (minimum != 0)
# {
# 	int so_far = jan;
# 	
#	if (feb < so_far)
#		so_far = feb;
#	if (mar < so_far)
#		so_far = mar; 
#	if (apr < so_far)
#		so_far = apr;
#	if (may < so_far)
#		so_far = may;
#	if (jun < so_far)
#		so_far = jun;
#	printf("minimum: %d\n", so_far);
# }
	beq 	$t0, $zero, AFTER_minimum	# if (minimum == 0) SKIP
	add	$s1, $zero, $t4			# s1 = so_far = jan
	
	slt	$s0, $t5, $s1			# s0 = 1 if (feb < so_far), else = 0
	beq	$s0, $zero, NEXT1		# if s0 = 0, SKIP to NEXT1
	add	$s1, $zero, $t5			# s1 = so_far = feb
NEXT1:	
	slt	$s0, $t6, $s1			# s0 = 1 if (mar < so_far), else = 0
	beq	$s0, $zero, NEXT2		# if s0 = 0, SKIP to NEXT2
	add	$s1, $zero, $t6			# s1 = so_far = mar
NEXT2:	
	slt	$s0, $t7, $s1			# s0 = 1 if (apr < so_far), else = 0
	beq	$s0, $zero, NEXT3		# if s0 = 0, SKIP to NEXT3
	add	$s1, $zero, $t7			# s1 = so_far = apr
NEXT3:
	slt	$s0, $t8, $s1			# s0 = 1 if (may < so_far), else = 0
	beq	$s0, $zero, NEXT4		# if s0 = 0, SKIP to NEXT4
	add	$s1, $zero, $t8			# s1 = so_far = may
NEXT4:	
	slt	$s0, $t9, $s1			# s0 = 1 if (jun < so_far), else = 0
	beq	$s0, $zero, PRINTMIN		# if s0 = 0, SKIP to NEXT4
	add	$s1, $zero, $t9			# s1 = so_far = jun

PRINTMIN:
	addi	$v0, $zero, 4			# print_string(MINIMUM)
	la	$a0, MINIMUM
	syscall
	
	addi	$v0, $zero, 1			# print_int()
	add	$a0, $zero, $s1			# a0 = s1 = so_far
	syscall
	
	addi	$v0, $zero, 4			# print_string(NEWLINE)
	la	$a0, NEWLINE			
	syscall
AFTER_minimum:


# TASK 2 - negate
#
# if (negate != 0)
# {
#	negate jan, store
#	negate feb, store
#	negate mar, store
#	negate apr, store
#	negate may, store
#	negate jun, store
#	printf("NEGATE");
# }
	beq 	$t1, $zero, AFTER_negate	# if (negate == 0) SKIP
	
	sub	$s0, $zero, $t4			# s0 = -jan
	la	$t4, jan 			# t4 = &jan
	sw 	$s0, 0($t4)			# Mem[jan] = s0 = -jan
	
	sub	$s0, $zero, $t5			# s0 = -feb
	la	$t5, feb 			# t5 = &feb
	sw	$s0, 0($t5)			# Mem[feb] = -s0 = -feb

	sub	$s0, $zero, $t6			# s0 = -mar
	la	$t6, mar 			# t6 = &mar
	sw	$s0, 0($t6)			# Mem[mar] = s0 = -mar

	sub	$s0, $zero, $t7			# s0 = -apr
	la	$t7, apr 			# t7 = &apr
	sw	$s0, 0($t7)			# Mem[apr] = s0 = -apr

	sub	$s0, $zero, $t8			# s0 = -may
	la	$t8, may 			# t8 = &may
	sw	$s0, 0($t8)			# Mem[may] = s0 = -may
	
	sub	$s0, $zero, $t9			# s0 = -jun
	la	$t9, jun 			# t9 = &jun
	sw	$s0, 0($t9)			# Mem[jun] = s0 = -jun
	
	addi	$v0, $zero, 4			# print_string(NEGATE)
	la	$a0, NEGATE			
	syscall
	
	addi	$v0, $zero, 4			# print_string(NEWLINME)
	la	$a0, NEWLINE			
	syscall
AFTER_negate:


# TASK 3 - evens
#
# printf("EVENS START")
# if (evens != 0)
# {
#	if jan = even 
#		print(jan) 
#	if feb = even 
#		print(feb)
#	if mar = even 
#		print(mar) 
#	if apr = even  
#		print(apr) 
#	if may = even 
#		print(may)
#	if jun = even 
#		print(jun)
# printf("EVENS_END")
# }
	beq 	$t2, $zero, AFTER_evens		# if (evens == 0) SKIP
	
	addi	$v0, $zero, 4			# print_string(EVENS_START)
	la	$a0, EVENS_START
	syscall
	
	addi	$v0, $zero, 4			# print_string(NEWLINE)
	la 	$a0, NEWLINE			
	syscall
	
	la	$t4, jan 			# t4 = &jan
	lw	$t4, 0($t4)			# t4 = jan
	
	andi 	$s0, $t4, 0x1			# if (jan = even): s0 = 0, else: s0 = 1
	bne	$s0, $zero, FEB_EVEN		# if (s0 = 1 = odd) SKIP
		
	addi	$v0, $zero, 1			# print_int()
	add	$a0, $zero, $t4			# a0 = t4 = jan
	syscall
	
	addi	$v0, $zero, 4			# print_string(NEWLINE)
	la 	$a0, NEWLINE			
	syscall
	
FEB_EVEN:
	la	$t5, feb 			# t5 = &feb
	lw	$t5, 0($t5)			# t5 = feb
	
	andi 	$s0, $t5, 0x1			# if (feb = even): s0 = 0, else: s0 = 1
	bne	$s0, $zero, MAR_EVEN		# if (s0 = 1 = odd) SKIP
		
	addi	$v0, $zero, 1			# print_int()
	add	$a0, $zero, $t5			# a0 = t5 = feb
	syscall
	
	addi	$v0, $zero, 4			# print_string(NEWLINE)
	la 	$a0, NEWLINE			
	syscall
		
MAR_EVEN:
	la	$t6, mar 			# t6 = &mar
	lw	$t6, 0($t6)			# t6 = mar
	
	andi 	$s0, $t6, 0x1			# if (mar = even): s0 = 0, else: s0 = 1
	bne	$s0, $zero, APR_EVEN		# if (s0 = 1 = odd) SKIP
	
	addi	$v0, $zero, 1			# print_int()
	add	$a0, $zero, $t6			# a0 = t6 = mar
	syscall
	
	addi	$v0, $zero, 4			# print_string(NEWLINE)
	la 	$a0, NEWLINE			
	syscall

APR_EVEN:
	la	$t7, apr 			# t7 = &apr
	lw	$t7, 0($t7)			# t7 = apr
	
	andi 	$s0, $t7, 0x1			# if (apr = even): s0 = 0, else: s0 = 1
	bne	$s0, $zero, MAY_EVEN		# if (s0 = 1 = odd) SKIP
	
	addi	$v0, $zero, 1			# print_int()
	add	$a0, $zero, $t7			# a0 = t7 = APR
	syscall
	
	addi	$v0, $zero, 4			# print_string(NEWLINE)
	la 	$a0, NEWLINE			
	syscall

MAY_EVEN:
	la	$t8, may 			# t7 = &may
	lw	$t8, 0($t8)			# t7 = may
	
	andi 	$s0, $t8, 0x1			# if (may = even): s0 = 0, else: s0 = 1
	bne	$s0, $zero, JUN_EVEN		# if (s0 = 1 = odd) SKIP
	
	addi	$v0, $zero, 1			# print_int()
	add	$a0, $zero, $t8			# a0 = t8 = MAY
	syscall
	
	addi	$v0, $zero, 4			# print_string(NEWLINE)
	la 	$a0, NEWLINE			
	syscall

JUN_EVEN:
	la	$t9, jun 			# t7 = &jun
	lw	$t9, 0($t9)			# t7 = jun
	
	andi 	$s0, $t9, 0x1			# if (jun = even): s0 = 0, else: s0 = 1
	bne	$s0, $zero, AFTER_evens		# if (s0 = 1 = odd) SKIP
	
	addi	$v0, $zero, 1			# print_int()
	add	$a0, $zero, $t9			# a0 = t8 = JUN
	syscall
	
	addi	$v0, $zero, 4			# print_string(NEWLINE)
	la 	$a0, NEWLINE			
	syscall
	
	addi	$v0, $zero, 4			# print_string(EVENS_END)
	la	$a0, EVENS_END
	syscall
AFTER_evens:


# TASK 4 - print
#
# if (print != 0)
# {
#	printf("jan: " + value)
#	printf("feb: " + value)
#	printf("mar: " + value)
#	printf("apr: " + value)
#	printf("may: " + value)
#	printf("jun: " + value)
# }	
	beq 	$t3, $zero, AFTER_print		# if (print == 0) SKIP
	
	addi	$v0, $zero, 4			# print_string(NEWLINE)
	la 	$a0, NEWLINE			
	syscall
	
	la	$t4, jan 			# t4 = &jan
	lw	$t4, 0($t4)			# t4 = jan
	
	addi	$v0, $zero, 4			# print_string(Jan)
	la 	$a0, JAN			
	syscall
	
	addi	$v0, $zero, 1			# print_int()
	add	$a0, $zero, $t4			# a0 = t4 = JAN
	syscall

	addi	$v0, $zero, 4			# print_string(NEWLINE)
	la 	$a0, NEWLINE			
	syscall
	
	la	$t5, feb 			# t5 = &feb
	lw	$t5, 0($t5)			# t5 = feb
	
	addi	$v0, $zero, 4			# print_string(FEB)
	la 	$a0, FEB			
	syscall
	
	addi	$v0, $zero, 1			# print_int()
	add	$a0, $zero, $t5			# a0 = t5 = FEB
	syscall
	
	addi	$v0, $zero, 4			# print_string(NEWLINE)
	la 	$a0, NEWLINE			
	syscall
	
	la	$t6, mar 			# t6 = &mar
	lw	$t6, 0($t6)			# t6 = mar
	
	addi	$v0, $zero, 4			# print_string(MAR)
	la 	$a0, MAR			
	syscall
	
	addi	$v0, $zero, 1			# print_int()
	add	$a0, $zero, $t6			# a0 = t6 = MAR
	syscall
	
	addi	$v0, $zero, 4			# print_string(NEWLINE)
	la 	$a0, NEWLINE			
	syscall
	
	la	$t7, apr 			# t7 = &apr
	lw	$t7, 0($t7)			# t7 = apr
	
	addi	$v0, $zero, 4			# print_string(APR)
	la 	$a0, APR			
	syscall
	
	addi	$v0, $zero, 1			# print_int()
	add	$a0, $zero, $t7			# a0 = t7 = APR
	syscall
	
	addi	$v0, $zero, 4			# print_string(NEWLINE)
	la 	$a0, NEWLINE			
	syscall
	
	la	$t8, may 			# t8 = &may
	lw	$t8, 0($t8)			# t8 = may
	
	addi	$v0, $zero, 4			# print_string(MAY)
	la 	$a0, MAY			
	syscall
	
	addi	$v0, $zero, 1			# print_int()
	add	$a0, $zero, $t8			# a0 = t8 = MAY
	syscall
	
	addi	$v0, $zero, 4			# print_string(NEWLINE)
	la 	$a0, NEWLINE			
	syscall
	
	la	$t9, jun			# t9 = &jun
	lw	$t9, 0($t9)			# t9 = jun
	
	addi	$v0, $zero, 4			# print_string(JUN)
	la 	$a0, JUN			
	syscall
	
	addi	$v0, $zero, 1			# print_int()
	add	$a0, $zero, $t9			# a0 = t9 = JUN
	syscall
	
	addi	$v0, $zero, 4			# print_string(NEWLINE)
	la 	$a0, NEWLINE			
	syscall
AFTER_print:


# EPILOGUE - return() statement at end of function.
DONE: # Restore stack & frame pointers and return. Clean up function/memory. Return() instruction.	
	lw 	$ra, 4($sp)	# get rettunr address from stack
	lw 	$fp, 0($sp)	# restore the caller's frame pointer
	addiu 	$sp, $sp, 24	# restore the caller's stack pointer
	jr 	$ra		# return() to caller's code	
