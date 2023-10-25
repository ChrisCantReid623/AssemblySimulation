# asm2.s
# Author: Christopher Reid
# SAVED REGISTERS
#	s0 = printInts
#	s1 = printWords
#	s2 = bubbleSort
#	s3 = printInts_howToFindLen
#	s4 = intsArray
#	s6 = tmp
#	s7 = intsArray




.data
newLine:		.asciiz 		"\n"
print_ints_header: 	.asciiz		"printInts: About to print "
elements:		.asciiz 		" elements.\n"
print_words_header:	.asciiz 		"printWords: There were "
print_words_finish:	.asciiz 		" words.\n"
null_header:	.asciiz 		"printInts: About to print an unknown number of elements.  Will stop at a zero element.\n"
empty_space:	.asciiz 		" "
swap_at:		.asciiz 		"Swap at: "
	
# ---- main() ----
.text

.globl studentMain
studentMain:
#Prologue
	addiu $sp, $sp, -24 			# allocate stack space -- default of 24 here
	sw    $fp, 0($sp) 			# save caller’s frame pointer
	sw    $ra, 4($sp) 			# save return address
	addiu $fp, $sp, 20 			# setup main’s frame pointer

	la    $s0, printInts			# s0 = &printInts
	lb    $s0, 0($s0)			# s0 = printInts
	
	la    $s1, printWords			# s1 = &printWords
	lb    $s1, 0($s1)			# s1 = printWords
	
	la    $s2, bubbleSort			# s2 = &bubbleSort
	lb    $s2, 0($s2)			# s2 = bubbleSort
	
	
# PrintInts()
#
#--------- Registers:
#	t0 = 2, index
#	t1 = count
#	t2 = (printInts_howToFindLen != 0)
#	t3 = intsArray_len
# 	t4 = &intsArray_END
#	t5 = &intsArray
#	t6 = (index < count)
#
#--------- PseudoCode
# if (printInts != 0) {
#   if (printInts_howToFindLen != 2) {
#
#	int count;
#   	if (printInts_howToFindLen == 0) {
#		count = intsArray_len;
#   	}
#   	else {
#		count = intsArray_END - intsArray; // remember to divide by 4!
#
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
#
#      while (*cur != 0) {
#	  printf("%d\n", *cur);
#	  cur++;
#      }
#   }
# }

	beq  $s0, $zero, PRINT_WORDS		# if (printInts == 0): goto PRINT_WORDS
	
	la   $s3, printInts_howToFindLen	# s3 = &printInts_howToFindLen
	lh   $s3, 0($s3)			# s3 = printInts_howToFindLen
	
	addi $t0, $zero, 2			# t0 = 2
	beq  $s3, $t0, NULL_SEARCH		# if (printInts_howToFindLen == 2): goto NULL_SEARCH
	
	addi $t1, $zero, 0			# count = 0
	bne  $s3, $zero, POINTER_SUBTRACT	# if (printInts_howToFindLen != 0): goto POINTER_SUBTRACT

	la   $t3, intsArray_len			# t3 = &intsArray_len
	lw   $t3, 0($t3)			# t3 = intsArray_len
	
	add  $t1, $zero, $t3			# count = intsArray_len
	
	j PRINT_INTS				# goto PRINT_INTS
	
POINTER_SUBTRACT:
	la   $t4, intsArray_END			# t4 = &intsArray_END
	la   $t5, intsArray			# t5 = &intsArray

	sub  $t3, $t4, $t5			# count = (&intsArray_END - &intsArray)
	srl  $t3, $t3, 2			# count // 4

PRINT_INTS:
	addi $v0, $zero, 4	
	la   $a0, print_ints_header		# print( str(print_ints_header) )
	syscall

	addi $v0, $zero, 1
	add  $a0, $zero, $t3			# print( int(count) )
	syscall

	addi $v0, $zero, 4	
	la   $a0, elements			# print( str(elements) )
	syscall



	addi $t0, $zero, 0			# index = 0
	la   $s4, intsArray			# s4 = &intsArray
FOR_LOOP:	
	slt  $t6, $t0, $t3			# t6 = (index < count)
	beq  $t6, $zero, PRINT_WORDS		# if (index >= count): goto PRINT_WORDS
	
	add  $t7, $t0, $t0			# t7 = 2 * index
	add  $t7, $t7, $t7			# t7 = 4 * index
	
PRINT_INDEX:
	add  $t7, $s4, $t7			# s7 = base + (index * size)
	lw   $t8, 0($t7)			# t8 = intsArray[index]
	
	addi $v0, $zero, 1
	add  $a0, $zero, $t8			# print(intsArray[i])
	syscall

	addi $v0, $zero, 11
	addi $a0, $zero, '\n'			# print( int(newline) )
	syscall
	
	addi $t0, $t0, 1			# s0(index)++
	
	j FOR_LOOP				# Jump to top of Loop
	
NULL_SEARCH:
	la   $s4, intsArray			# s4 = &intsArray
	
	addi $v0, $zero, 4	
	la   $a0, null_header			# print( str(null_term) )
	syscall
	
WHILE_LOOP:
	lw   $t9, 0($s4)			# t9 = intsArray
	beq  $t9, $zero, PRINT_WORDS		# if (s2 == 0): goto PRINT_WORDS
	
	addi $v0, $zero, 1
	add  $a0, $zero, $t9			# print( int(*cur) )
	syscall
	
	addi $v0, $zero, 11
	addi $a0, $zero, '\n'			# print( int(newline) )
	syscall
	
	addi $s4, $s4, 4 			# increment index
	j WHILE_LOOP

#--------- PrintWords()
#
#--------- Registers:
#	t0 = *start
#	t1 = *cur
#	t2 = count
#	t3 = str(empty_space)
#
#--------- Psuedocode
# if (printWords != 0) {
# 	char *start = theString;
#	char *cur   = start;
#	int   count = 1;
#
#	while (*cur != '\0') {     	//null terminator. ASCII value is 0x00
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

PRINT_WORDS:
	beq  $s1, $zero, BUBBLESORT		# if (printWords == 0): goto BUBBLESORT
	
	la   $t0, theString			# *start = theString
	add  $t1, $zero, $t0 			# *cur   = start
	addi $t2, $zero, 1			# count  = 1
	
WHILE_NOT_NULL:
	lb   $t4, 0($t1)			# t4 = cur_val
	beq  $t4, $zero, PRINT_COUNT		# if (cur_val == 0): goto PRINT_COUNT
	
	addi $t3, $zero, ' '			# t3 = empty_space
	bne  $t4, $t3, NOT_A_SPACE		# if (cur_val != " ") goto NOT_A_SPACE
	
	sb   $zero, 0($t1)			# *cur = 0
	addi $t2, $t2, 1			# count++
	
NOT_A_SPACE:
	addi $t1, $t1, 1			# *cur++
	j WHILE_NOT_NULL			# jump to top of while loop

PRINT_COUNT:
	addi $v0, $zero, 4
	la   $a0, print_words_header		# print ( str(print_words_header) )
	syscall
	
	addi $v0, $zero, 1
	add  $a0, $zero, $t2			# print ( count )
	syscall
	
	addi $v0, $zero, 4
	la   $a0, print_words_finish		# print ( str(print_words_finish) )
	syscall

WHILE_LT_START:
	slt  $t5, $t1, $t0			# t5 = (*cur < *start)
	bne  $t5, $zero, BUBBLESORT		# if (*cur < *start): goto BUBBLESORT
	
	beq  $t1, $t0, GO_IN			# if (*cur == start): goto GOIN
	lb   $t4, -1($t1)			# t4 = cur[-1]
	beq  $t4, $zero, GO_IN			# if ( cur[-1] ==  ) GOIN
	
	j AFTER_LOOP				# jump to after loop
	
GO_IN:
	addi $v0, $zero, 4
	add  $a0, $zero, $t1			# print( int(*cur) )
	syscall
	
	addi $v0, $zero, 11
	addi $a0, $zero, '\n'			# print( int(newline) )
	syscall
	
AFTER_LOOP:
	addi $t1, $t1, -1			# cur--
	j WHILE_LT_START

#--------- BubbleSort()
#
#--------- Registers:
#	s6 = tmp
#	s7 = intsArray

#				
#	t0 = intsArray_len
#	t1 = i
#	t2 = (i < intsArray_len)
#	t3 = j
#	`t4 = (intsArray_len - 1)
# 	t5 = (j < (intsArray_len - 1))
# 	t6 = intsArray[j]
# 	t7 = j+1
# 	t8 = intsArray[j + 1]
#	t9 = (intsArray[j+1] < intsArray[j]
#
#--------- Psuedocode
# if (bubbleSort != 0) {
#	for (int i = 0; i < intsArray_len; i++) {  
#		for (int j = 0; j < intsArray_len -1; j++) {
#			if (intsArray[j] > intsArray[j+1]) {
#				print("Swap at j")
#				int tmp	intsArray[j]
#				intsArray[j] = intsArray[j+1]
#				intsArray[j+1] = tmp;
#			}
#		}
#	}
# }

BUBBLESORT:
	beq  $s2, $zero, END			# if (bubbleSort == 0): goto END
	
	la   $s7, intsArray			# s7 = &intsArray	
	la   $t0, intsArray_len			# t0 = &intsArray_len
	lw   $t0, 0($t0)			# t0 = intsArray_len
	
	addi $t1, $zero, 0			# i = 0
OUTER_FOR:
	slt  $t2, $t1, $t0 			# t2 = (i < intsArray_len)
	beq  $t2, $zero, END			# if (i >= intsArray_len): goto OUTER_END
	
	addi  $t3, $zero, 0			# j = 0
	addi  $t4, $t0, -1			# t4 = (intsArray_len - 1)
INNER_FOR:
	slt  $t5, $t3, $t4			# t5 = (j < (intsArray_len - 1))
	beq  $t5, $zero, OUTER_END		# if (j >= (intsArray_len - 1)): goto INNER_END
	
	lw   $t6, 0($s7)			# t6 = intsArray[j]
	addi $t7, $s7, 4			# t7 = j+1
	lw   $t8, 4($s7)			# t8 = intsArray[j + 1]
	
	slt  $t9, $t8, $t6			# t9 = (intsArray[j+1] < intsArray[j] )
	bne  $t9, $zero, SWAP			# if (intsArray[j+1] < intsArray[j]) goto SWAP
	
	j INNER_END
	
SWAP:
	addi  $v0, $zero, 4	
	la    $a0, swap_at			# print(str(swap_at))
	syscall
	
	addi  $v0, $zero, 1
	add   $a0, $zero, $t3			# print( int(j) )
	syscall
	
	addi  $v0, $zero, 11
	addi  $a0, $zero, '\n'			# print( int(newline) )
	syscall
	
	add   $s6, $zero, $t6			# tmp(s6) = intsArray[j]
	sw    $t8, 0($s7)			# intsArray[j] = intsArray[j+1]
	sw    $s6, 4($s7)			# intsArray[j+1] = tmp

INNER_END:	
	addi  $t3, $t3, 1			# j++
	addi  $s7, $s7, 4			# reset array index
	j INNER_FOR				# jump to top of loop
	
OUTER_END:
	addi  $t1, $t1, 1			# i++
	la   $s7, intsArray			# s7 = &intsArray
	j OUTER_FOR				# jump to top of loop

END:


#Epilogue
	lw    $ra, 4($sp) 			# get return address from stack
	lw    $fp, 0($sp) 			# restore the caller’s frame pointer
	addiu $sp, $sp, 24 			# restore the caller’s stack pointer
	jr    $ra 				# return to caller’s code
