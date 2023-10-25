#--------------------------------------------------------
# asm3.s
# Author: Christopher Reid
#--------------------------------------------------------
.data 
collatz_str1:	.asciiz	"collatz("
collatz_str2:	.asciiz	") completed after "
collatz_str3:	.asciiz	" calls to collatz_line().\n"

.text

###############################
.globl collatz_line		#
collatz_line:      		#
###############################
# REGISTERS		
#   a0 = val		
#   t0 = (val = odd#)	
#   t1 = cur		
#   t2 = (cur = odd#)
#   t3 = val	
#---------------------------------------------------------------------------------------------------
# int collatz_line(int val):						
#													
# 	if (val % 2 = 1):   //odd value						
#		printf("%d\n", val);						
#		return val;							
#	printf("%d", val);								
#										
#	int cur = val;									
#	while (cur % 2 == 0):							
#		cur /= 2;								
#		printf(" %d", cur);							
#										
#	print('\n);								
#	return cur;								
#---------------------------------------------------------------------------------------------------

#Prologue
	addiu $sp, $sp, -24			# allocate stack space -- default of 24 here
	sw    $fp, 0($sp)			# save caller’s frame pointer
	sw    $ra, 4($sp)			# save return address
	sw    $a0, 8($sp)			# save (a0 = val) arugment
	addiu $fp, $sp, 20			# setup main’s frame pointer
	
	add   $t3, $zero, $a0  			# t3 = val	
	
	andi  $t0, $t3, 1			# t0 = (val == odd#)
	beq   $t0, $zero, even			# if (val != odd#): skip to even
	
	addi  $v0, $zero, 1
	add   $a0, $zero, $t3			# print(odd val)
	syscall
	
	addi  $v0, $zero, 11
	addi  $a0, $zero, '\n'			# print(newline)
	syscall
	
	add   $v0, $zero, $t3			# return (odd val)
	j collatz_line_epilogue			# jump to epilogue
	
even:
	addi  $v0, $zero, 1
	add   $a0, $zero, $t3			# print(even val)
	syscall
	
	
	add   $t1, $zero, $t3			# t1 = cur = val
while_even:
	andi  $t2, $t1,   1			# t2 = (cur == odd#)
	bne   $t2, $zero, odd_again		# if (cur != odd#): skip to odd_again
	
	srl   $t1, $t1, 1			# t1 = cur/2
	
	addi  $v0, $zero, 11
	addi  $a0, $zero, ' '			# print(' ')
	syscall
	
	addi  $v0, $zero, 1
	add   $a0, $zero, $t1			# print(cur)
	syscall
	
	j while_even				# jump to top of while_even
	
odd_again:
	addi  $v0, $zero, 11
	addi  $a0, $zero, '\n'			# print(newline)
	syscall
	
	add   $v0, $zero, $t1			# return cur
	
# Epilogue
collatz_line_epilogue:
        	lw    $fp, 0($sp)		# Restore caller’s frame pointer
        	lw    $ra, 4($sp)		# Restore return address
        	lw    $a0, 8($sp)		# Restore a0 (string)
        	addiu $sp, $sp, 24		# Deallocate stack space
        	jr    $ra			# Return to the caller


###############################
.globl collatz		#
collatz:      		#
###############################
# REGISTERS
#   a0 = val
#   t0 = cur
#   t1 = calls
#   t2 = 1
#   t3 = cur arithmetic
#   t4 = val
#---------------------------------------------------------------------------------------------------
# void collatz(int val):								
#										
#	int cur = val;								
#	int calls = 0;								
#										
#	cur = collatz_line(cur);							
#										
#	while (cur != 1):								
#		cur = 3*cur+1;							
#		cur = collatz_line(cur);						
#		calls++;								
#											
#	printf("collatz(%d) completed after %d calls to collatz_line().\n", val, calls);	
#	printf("\n");								
#---------------------------------------------------------------------------------------------------

#Prologue
	addiu $sp, $sp, -24			# allocate stack space -- default of 24 here
	sw    $fp, 0($sp)			# save caller’s frame pointer
	sw    $ra, 4($sp)			# save return address
	sw    $a0, 8($sp)			# save (a0 = val) arugment
	addiu $fp, $sp, 20			# setup main’s frame pointer
	
	add   $t0, $zero, $a0			# t0 = cur = val
	add   $t4, $zero, $a0			# t4 = val
	addi  $t1, $zero, 0			# t1 = calls = 0
	
	sw    $t1, 12($sp)			# save (t1 = calls)
	add   $a0, $zero, $t0			# argument = cur
	jal   collatz_line			# Call to collatz_line(cur)
	add   $t0, $zero, $v0			# t0 = cur = collatz_line(cur)
	lw    $t1, 12($sp)			# restore (t1 = calls)
	
	addi  $t2, $zero, 1			# t2 = 1
	
while_not_one:
	beq   $t0, $t2, equals_one		# if (t0 = cur == t2 = 1): skip to equals_one
	
	add   $t3, $t0, $t0			# t3 = 2 * cur
	add   $t3, $t3, $t0			# t3 = 3 * cur
	addi  $t0, $t3, 1			# t0 = (3 * cur) + 1
	
	sw    $t1, 12($sp)			# save (t1 = calls)
	add   $a0, $zero, $t0			# argument = cur
	jal   collatz_line			# Call to collatz_line(cur)
	add   $t0, $zero, $v0			# t0 = cur = collatz_line(cur)
	lw    $t1, 12($sp)			# restore (t1 = calls)
	addi  $t1, $t1, 1			# t1 = calls++
	j while_not_one				# jump to top of while_not_one
	
equals_one:
	addi $v0, $zero, 4
	la  $a0, collatz_str1			# print(collatz_str1)
	syscall

	addi  $v0, $zero, 1
	add   $a0, $zero, $t4			# print(val)
	syscall
	
	addi $v0, $zero, 4
	la  $a0, collatz_str2			# print(collatz_str2)
	syscall
	
	addi  $v0, $zero, 1
	add   $a0, $zero, $t1			# print(calls)
	syscall
	
	addi $v0, $zero, 4
	la  $a0, collatz_str3			# print(collatz_str3)
	syscall
	
	addi  $v0, $zero, 11
	addi  $a0, $zero, '\n'			# print(newline)
	syscall
	
#Epilogue
        	lw    $fp, 0($sp)		# Restore caller’s frame pointer
        	lw    $ra, 4($sp)		# Restore return address
        	lw    $a0, 8($sp)		# Restore a0 (string)
        	addiu $sp, $sp, 24		# Deallocate stack space
        	jr    $ra			# Return to the caller
	
###############################
.globl percentSearch  	#
percentSearch:        	#
###############################
# REGISTERS
#   a0 = string
#   t0 = &string
#   t1 = index
#   t2 = '%'
#   t2 = 
#   t3 = char = string[index]
#---------------------------------------------------------------------------------------------------
# int percentSearch(string):								
#	int index = 0								
#	for (char in string):												
#		if (char = '%'):							
#			return index;						
#		index++;								
#	return -1;								
#---------------------------------------------------------------------------------------------------

#Prologue
	addiu $sp, $sp, -24			# allocate stack space -- default of 24 here
	sw    $fp, 0($sp)			# save caller’s frame pointer
	sw    $ra, 4($sp)			# save return address
	sw    $a0, 8($sp)			# save (a0 = val) arugment
	addiu $fp, $sp, 20			# setup main’s frame pointer
	
	lw    $t0, 8($sp)			# t0 = &string
	addi  $t1, $zero, 0			# t1 = index = 0
	
	addi  $t2, $zero, '%'			# t2 = '%'
loop_string:
	lb    $t3, 0($t0)			# t3 = char = string[index]
	beq   $t3, $zero, not_found_percent	# if (char == null terminator): skip to not_found_percent
	beq   $t3, $t2, found_percent		# if (char == '%') skip to found_percent
	
	addi  $t1, $t1, 1			# index++
	addi  $t0, $t0, 1			# string[index +1]
	j loop_string				# jump to top of loop_string
	
found_percent:
	add   $v0, $zero, $t1			# return index
	j percent_epilogue			# jump to percent_epilogue

not_found_percent:
	addi  $v0, $zero, -1			# return -1
	j percent_epilogue			# jump to percent_epilogue

#Epilogue
percent_epilogue:
        	lw    $fp, 0($sp)		# Restore caller’s frame pointer
        	lw    $ra, 4($sp)		# Restore return address
        	lw    $a0, 8($sp)		# Restore a0 (string)
        	addiu $sp, $sp, 24		# Deallocate stack space
        	jr    $ra			# Return to the caller

###############################
.globl letterTree  		#
letterTree:       	 	#
###############################
# REGISTERS
#   a0 = step
#   t0 = count
#   t1 = pos
#   t2 = c = getNextLetter(pos)
#   t3 = i
#   t4 = (count < i)
#   t5 = step
#---------------------------------------------------------------------------------------------------
# int letterTree(int step):								
#										
#		int count = 0;							
#		int pos   = 0;							
#										
#		while(1):								
#			char c = getNextLetter(pos);								
#			if (c == '\0'):						
#				break;						
#										
#			for (int i = 0; i <= count; i++):				
#				printf("%c", c);					
#			printf("\n");						
#										
#			count++;							
#			pos += step						
#										
#		return pos;							
#---------------------------------------------------------------------------------------------------

#Prologue
	addiu $sp, $sp, -24			# allocate stack space -- default of 24 here
	sw    $fp, 0($sp)			# save caller’s frame pointer
	sw    $ra, 4($sp)			# save return address
	sw    $a0, 8($sp)			# save (a0 = val) arugment
	addiu $fp, $sp, 20			# setup main’s frame pointer
	
	addi  $t0, $zero, 0			# t0 = count = 0
	addi  $t1, $zero, 0			# t1 = pos   = 0
	
while_true:
	add   $a0, $zero, $t1			# a0 = pos
	jal   getNextLetter			# call getNextLetter()
	
	add   $t2, $zero, $v0			# t2 = c = getNextLetter(pos)
	beq   $t2, $zero, exit_while_loop	# if (c == 0): skip to exit_while_loop
	
	addi  $t3, $zero, 0			# t3 = i = 0
print_loop:
	slt   $t4, $t0, $t3			# t4 = (count < i)
	bne   $t4, $zero, end_for_loop		# if (count < i): skip to end_for_loop
	
	addi  $v0, $zero, 11
	add   $a0, $zero, $t2			# print(c)
	syscall
	
	addi  $t3, $t3, 1			# t3 = i++
	j print_loop				# jump to top of print_loop
	
end_for_loop:
	addi  $v0, $zero, 11
	addi   $a0, $zero, '\n'			# print(newline)
	syscall
	
	addi  $t0, $t0, 1			# t0 = count++
	
	lw    $t5, 8($sp)			# t5 = step
	add   $t1, $t1, $t5			# pos += step
	j while_true				# jump to top of while_true
	
exit_while_loop:
	add   $v0, $zero, $t1			# return pos

# Epilogue
    	lw    $fp, 0($sp)			# Restore caller’s frame pointer
        	lw    $ra, 4($sp)		# Restore return address
        	lw    $a0, 8($sp)		# Restore a0 (string)
        	addiu $sp, $sp, 24		# Deallocate stack space
        	jr    $ra			# Return to the caller
	
