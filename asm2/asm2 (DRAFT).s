# asm2.s
# Author: Christopher Reid

.data
newLine:
	.asciiz "\n"
printInts:
	.asciiz	"printInts: About to print "
elements:
	.asciiz " elements.\n"
null_header:
	.asciiz "printInts: About to print an unknown number of elements.  Will stop at a zero element.\n"

	
# ---- main() ----
.text

.globl studentMain
studentMain:
#Prologue
addiu $sp, $sp, -24 	# allocate stack space -- default of 24 here
sw $fp, 0($sp) 		# save caller’s frame pointer
sw $ra, 4($sp) 		# save return address
addiu $fp, $sp, 20 	# setup main’s frame pointer


# 		----- Task 1: Print Ints -----
# 			REGISTERS:
#			t0 = printInts
#			t1 = printInts_howToFindLen
#			t3 = count
#			t4 = intsArray_len
#			t5 = &intsArray_END
#			t6 = &intsArray
#			t7 = (index < count) , intsArray[index]
#			s0 = index
#			s1 = base + (index * size)
#			s2 = int(*cur)
#
#
# 			-------- PseudoCode ---------
#
# if (printInts != 0) {
#   if (printInts_howToFindLen != 2) {
#
#	int count;
#   	if (printInts_howToFindLen == 0) {
#		count = intsArray_len;
#   	}
#   	else {
#		count = intsArray_END - intsArray; // remember to divide by 4!

#   	printf("printInts: About to print %d elements.\n", count);
#
#   	for (int i=0; i<count; i++)
#		printf("%d\n", intsArray[i];
#   	}
#
#   else {
#
#      /* searches for a null terminator */
#      int *cur = intsArray; // same as &intsArray[0];
#
#      printf("printInts: About to print an unknown number of elements. "
#      "Will stop at a zero element.\n"); // all one line!

#      while (*cur != 0) {
#	  printf("%d\n", *cur);
#	  cur++;
#      }
#   }
# }
	
	la   $t0 printInts			# t0 = &printInts
	lb   $t0 0($t0)				# t0 = printInts
	
	##OFFICE Hours: incorrectly reading address of printInts variable
	beq  $t0 $zero TASK_2			# if (printInts == 0): goto TASK_2

	la   $t1 printInts_howToFindLen		# t1 = &printInts_howToFindLen
	lh   $t1 0($t1)				# t1 = printInts_howToFindLen
	
	addi $t2 $zero 2			# t2 = 2
	beq  $t1 $t2 NULL_SEARCH		# if (printInts_howToFindLen == 2): goto NULL_SEARCH
	
	addi $t3 $zero 0			# count(t3) = 0
	bne  $t1 $zero FALSE			# if (printInts_howToFindLen != 0): goto FALSE

	la   $t4 intsArray_len			# t4 = &intsArray_len
	lw   $t4 0($t4)				# t4 = intsArray_len
	
	add  $t3 $zero $t4			# count(t3) = intsArray_len(t4)
	
	j PRINT_INTS				# goto PRINT_INTS

FALSE:
	la   $t5 intsArray_END			# t5 = &intsArray_END
	la   $t6 intsArray			# t6 = &intsArray

	sub  $t3 $t5 $t6			# count(t3) = (&intsArray_END - &intsArray)
	srl  $t3 $t3 2

PRINT_INTS:
	add  $v0 $zero 4	
	la   $a0 printInts			# print( str(printInts) )
	syscall

	add  $v0 $zero 1
	add  $a0 $zero $t3			# print( int(count) )
	syscall

	add  $v0 $zero 4	
	la   $a0 elements			# print( str(elements) )
	syscall


	addi $s0 $zero 0			# index(s0) = 0
	la   $t6 intsArray			# t6 = &intsArray	
FOR_LOOP:
	 
	slt  $t7 $s0 $t3			# t7 = (index < count)
	beq  $t7 $zero TASK_2		        # if (index >= count): goto TASK_2
	
	add  $s1 $s0 $s0			# s1 = 2 * s1
	add  $s1 $s1 $s1			# s1 = 4 * s1
	

PRINT_INDEX:
	add  $s1 $t6 $s1			# s1 = base + (index * size)
	lw   $t7 0($s1)			# t7 = intsArray[index]
	
	add  $v0 $zero 1
	add  $a0 $zero $t7			# print(intsArray[i])
	syscall

	add  $v0 $zero 4	
	la   $a0 newLine			# print(str(newLine))
	syscall
	
	addi $s0 $s0 1				# s0(index)++
	
	j FOR_LOOP				# Jump to top of Loop


NULL_SEARCH:
	
	la   $t6 intsArray			# t6 = &intsArray
		
	add  $v0 $zero 4	
	la   $a0 null_header			# print( str(null_term) )
	syscall
	
WHILE: 

	lw   $t8 0($t6)			# t8 = intsArray
	beq  $t8 $zero TASK_2			# if (s2 == 0): goto TASK_2
	
	add  $v0 $zero 1
	add  $a0 $zero $t8			# print( int(*cur) )
	syscall
	
	add  $v0 $zero 4
	la   $a0 newLine			# print ( str(newLine) )
	syscall
	
	addi  $t6 $t6 4 			# increment index
	j WHILE
	
	

#                   ----- Task 2: Print Words -----
#			Registers:
#
#
#
#
#
#
#		
#		----------- Psuedocode -------------
# if (printWords != 0) {
# 	char *start = theString;
#	char *cur   = start;
#	int   count = 1;
#
#	while (*cur != '\0') {     		//null terminator. ASCII value is 0x00
#		if (*cur != ' ') {
#			*cur = '\0';
#			count++;
#		}
#		cur++
#	}
#
#	printf("printWords: There were %d wordds.\n", count);
#	
#	while (cur >= start) {
#		if (cur == start or cur[-1] == '\0') {
#			printf("%s\n", cur);
#		}
#		cur--;
#	}
# }

TASK_2:
	la   $t0 printWords			# t0 = &printWords
	lb   $t0 0($t0)				# t0 = printWords			
	
	add $v0 $zero 1
	add  $a0 $zero $t0
	syscall
	
	add  $v0 $zero 4
	la   $a0 newLine			# print ( str(newLine) )
	syscall
	
	add $v0 $zero 4
	la $a0 theString
	syscall
	
	add  $v0 $zero 4
	la   $a0 newLine			# print ( str(newLine) )
	syscall

#Epilogue
lw $ra, 4($sp) # get return address from stack
lw $fp, 0($sp) # restore the caller’s frame pointer
addiu $sp, $sp, 24 # restore the caller’s stack pointer
jr $ra # return to caller’s code
