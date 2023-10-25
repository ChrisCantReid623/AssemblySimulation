#--------------------------------------------------------
# asm4.s
# Author: Christopher Reid
#--------------------------------------------------------

.text

#################################
.globl bst_init_node		#
bst_init_node:      		#
#################################
# Registers
#   a0 = BSTNode *node
#   a1 = key
#   t0 = NULL
#------------------------------
# Prologue
	addiu $sp, $sp, -24		# allocate stack space -- default of 24 here
	sw    $fp, 0($sp)		# save caller’s frame pointer
	sw    $ra, 4($sp)		# save return address
	sw    $a0, 8($sp)		# save (a0 = node) arugment
	sw    $a1, 12($sp)		# save (a1 = key) argument
	addiu $fp, $sp, 20		# setup main’s frame pointer

	addi  $t0, $zero, 0		# t0 = NULL
	
	sw    $a1, 0($a0)		# (node -> key)   = key
	sw    $t0, 4($a0) 		# (node -> left)  = NULL
	sw    $t0, 8($a0)		# (node -> right) = NULL
	
# Epilogue
	lw    $fp, 0($sp)		# Restore caller’s frame pointer
        lw    $ra, 4($sp)		# Restore return address
        lw    $a0, 8($sp)		# Restore a0
        lw    $a1, 12($sp)		# Restore a1
        addiu $sp, $sp, 24		# Deallocate stack space
	jr    $ra			# return
	

#################################
.globl bst_search		#
bst_search:      		#
#################################
# Registers
#   a0 = BSTNode *node
#   a1 = key
#   t0 = cur
#   t1 = cur->key
#   t2 = key < (cur -> key)
#------------------------------

# Prologue
	addiu $sp, $sp, -24			# allocate stack space -- default of 24 here
	sw    $fp, 0($sp)			# save caller’s frame pointer
	sw    $ra, 4($sp)			# save return address
	sw    $a0, 8($sp)			# save (a0 = node) arugment
	addiu $fp, $sp, 20			# setup main’s frame pointer
	
	
	add   $t0, $a0, $zero			# t0 = cur = node;
start_loop:
	beq   $t0, $zero, rtn_null_1		# if (cur == NULL): skip to rtn_null_1
	lw    $t1, 0($t0)			# t1 = (cur-> key)
	
	beq   $t1, $a1, rtn_cur			# if (cur == key): skip to rtn_cur
	
	slt   $t2, $a1, $t1			# t2 = (key < (cur-> key))
	beq   $t2, $zero, search_right		# if key >= (cur->key): skip to search_right
	
	lw    $t0, 4($t0)			# cur = (cur-> left)
	j     start_loop
	
search_right:
	lw    $t0, 8($t0)			# cur = (cur-> right)
	j     start_loop
	
rtn_cur:
	add   $v0, $zero, $t0			# return cur
	j     search_epilogue			# jump to epilogue
	
rtn_null_1:
	add   $v0, $zero, $zero			# return null
	j     search_epilogue			# jump to epilogue

# Epilogue
search_epilogue:
	lw    $fp, 0($sp)			# Restore caller’s frame pointer
        lw    $ra, 4($sp)			# Restore return address
        lw    $a0, 8($sp)			# Restore a0
        addiu $sp, $sp, 24			# Deallocate stack space
        jr    $ra				# return

	
#################################
.globl bst_count		#
bst_count:			#
#################################
# Registers
#   a0 = BSTNode *node
#   t0 = bst_count(node -> left) + 1
#   t1 = bst_count(node -> right)
#------------------------------

# Prologue
	addiu $sp, $sp, -24		# allocate stack space -- default of 24 here
	sw    $fp, 0($sp)		# save caller’s frame pointer
	sw    $ra, 4($sp)		# save return address
	sw    $a0, 8($sp)		# save (a0 = node) arugment
	addiu $fp, $sp, 20		# setup main’s frame pointer
	
    	beq   $a0, $zero, rtn_zero  	# if (node == NULL), return 0
    	
    	addi  $sp, $sp, -4		# allocate new stack memory
    	sw    $a0, 0($sp)		# save node on stack
    	
	# Recurse Left
    	lw    $a0, 4($a0)		# arg = (node -> left)
    	jal   bst_count			# bst_count(arg)
    	addi  $t0, $v0, 1		# t0 = bst_count(node -> left) + 1
    	
    	lw    $a0,  0($sp)		# restore node from stack
    	addi  $sp, $sp, 4		# restore stack memory
    	
    	addi  $sp, $sp, -8		# allocate new stack memory
    	sw    $a0,  0($sp)		# save node on stack
    	sw    $t0,  4($sp)		# save t0 on stack
    	
	# Recurse Right	    	
    	lw    $a0,  8($a0)		# arg = (node -> right)
    	jal   bst_count			# bst_count(arg)
    	add   $t1, $v0, $zero    	# t1 = bst_count(node -> right)
    	
    	lw    $a0, 0($sp)		# restore node from stack
    	lw    $t0, 4($sp)		# restore $t0
    	addi  $sp, $sp, 8		# restore stack memory
    	
    	add   $v0, $t0, $t1		# return bst_count(node -> left) + 1  + bst_count(node -> right)
    	
    	j     count_epilogue          	# Jump to Epilogue

rtn_zero:
    	addi  $v0, $zero, 0           	# return 0 (empty tree)
    	j     count_epilogue

# Epilogue
count_epilogue:
	lw    $fp, 0($sp)		# Restore caller’s frame pointer
        lw    $ra, 4($sp)		# Restore return address
        lw    $a0, 8($sp)		# Restore a0
        addiu $sp, $sp, 24		# Deallocate stack space
        jr    $ra
    

#################################
.globl bst_in_order_traversal 	#
bst_in_order_traversal:       	#
#################################
# Registers
#   a0 = BSTNode *node
#   t0 = (node -> key)
#------------------------------

# Prologue
	addiu $sp, $sp, -24		# allocate stack space -- default of 24 here
	sw    $fp, 0($sp)		# save caller’s frame pointer
	sw    $ra, 4($sp)		# save return address
	sw    $a0, 8($sp)		# save (a0 = node) arugment
	addiu $fp, $sp, 20		# setup main’s frame pointer


    	beq   $a0, $zero, rtn_null_2  	# if (node == NULL), skip to rtn_null_2
    	
	# Recurse Left    	
    	addi  $sp, $sp, -4		# allocate stack memory
    	sw    $a0, 0($sp)		# save node on stack
    	
    	lw    $a0, 4($a0)		# arg = (node -> left)
    	jal   bst_in_order_traversal	# bst_in_order_traversal(node -> left);
    	
    	lw    $a0, 0($sp)       	# restore node from stack
    	addi  $sp, $sp, 4        	# restore stack memory
    	
	# Printf  	
    	addi  $sp, $sp, -4		# allocate stack memory
    	sw    $a0, 0($sp)		# save node on stack

	lw    $t0, 0($a0)		# t0 = (node -> key)
		
	addi  $v0, $zero, 1
	add   $a0, $zero, $t0		# printf(node->key)
	syscall
	
	addi  $v0, $zero, 11
	addi  $a0, $zero, '\n'		# print( '\n' )
	syscall
	
	lw    $a0, 0($sp)       	# restore node from stack
    	addi  $sp, $sp, 4        	# restore stack memory
	
	# Recurse Right
    	addi  $sp, $sp, -4       	# allocate new stack memory
    	sw    $a0, 0($sp)       	# save node on stack

	lw    $a0, 8($a0)		# arg = (node -> right)
	jal   bst_in_order_traversal	# bst_in_order_traversal(node -> right);
	
	lw    $a0, 0($sp)		# restore stack memory
	addi  $sp, $sp, 4
 
    	j   in_order_epilogue

rtn_null_2:
    	j   in_order_epilogue

# Epilogue
in_order_epilogue:
	lw    $fp, 0($sp)		# Restore caller’s frame pointer
        lw    $ra, 4($sp)		# Restore return address
        lw    $a0, 8($sp)		# Restore a0
        addiu $sp, $sp, 24		# Deallocate stack space
	jr    $ra

################################
.globl bst_pre_order_traversal #
bst_pre_order_traversal:       #
################################
# Registers
#   a0 = BSTNode *node
#   t0 = (node -> key)
#------------------------------

# Prologue
	addiu $sp, $sp, -24		# allocate stack space -- default of 24 here
	sw    $fp, 0($sp)		# save caller’s frame pointer
	sw    $ra, 4($sp)		# save return address
	sw    $a0, 8($sp)		# save (a0 = node) arugment
	addiu $fp, $sp, 20		# setup main’s frame pointer


    	beq   $a0, $zero, rtn_null_3   	# if (node == NULL): skip to rtn_null_3

	# Printf
	addi  $sp, $sp, -4		# allocate stack memory
	sw    $a0, 0($sp)		# save node on stack	
    	lw    $t0, 0($a0)		# t0 = (node -> key)
    	
    	addi  $v0, $zero, 1
	add   $a0, $zero, $t0		# printf(t0)
	syscall
	
	addi  $v0, $zero, 11
	addi  $a0, $zero, '\n'		# print( '\n' )
	syscall
	
	lw    $a0,  0($sp)       	# restore node from stack
	addi  $sp, $sp, 4        	# restore stack memory
	
	# Recurse Left
	addi  $sp, $sp, -4		# allocate stack memory
	sw    $a0, 0($sp)		# save node on stack
	lw    $a0, 4($a0)		# arg = (node -> left)
    	jal   bst_pre_order_traversal	# bst_pre_order_traversal(node -> left);
    	lw    $a0,  0($sp)       	# restore node from stack
	addi  $sp, $sp, 4        	# restore stack memory
	
	# Recurse Right
	addi  $sp, $sp, -4		# allocate stack memory
	sw    $a0, 0($sp)		# save node on stack
	lw    $a0, 8($a0)		# arg = (node -> left)
    	jal   bst_pre_order_traversal	# bst_pre_order_traversal(node -> left);
    	lw    $a0,  0($sp)       	# restore node from stack
	addi  $sp, $sp, 4        	# restore stack memory
	
	j     pre_order_epilogue
    	
rtn_null_3:
   	j     pre_order_epilogue
   	
#Epilogue
pre_order_epilogue:
	lw    $fp, 0($sp)		# Restore caller’s frame pointer
        lw    $ra, 4($sp)		# Restore return address
        lw    $a0, 8($sp)		# Restore a0
        addiu $sp, $sp, 24		# Deallocate stack space
	jr    $ra


###############################
.globl bst_insert             #
bst_insert:                   #
###############################
# Registers
#   a0 = BSTNode *root
#   a1 = BSTNode *newNode
#   t0 = root
#   t1 = (newNode -> key)
#   t2 = (root -> key)
#   t3 = ((newNode->key) < (root->key))
#   t4 = (root -> left)/(root -> right)
#------------------------------
# Prologue
	addiu $sp, $sp, -24			# allocate stack space -- default of 24 here
	sw    $fp, 0($sp)			# save caller’s frame pointer
	sw    $ra, 4($sp)			# save return address
	sw    $a0, 8($sp)			# save (a0 = root) arugment
	sw    $a1, 12($sp)			# Save (a1 = newNode) argument
	addiu $fp, $sp, 20			# setup main’s frame pointer
	
    	lw    $t0, 8($sp)			# t0 = root
    	beq   $t0, $zero, root_null		# if (root = NULL): EMPTY TREE, skip to root_null
    	
    	lw    $t1, 0($a1)			# t1 = (newNode -> key)
    	lw    $t2, 0($a0)			# t2 = (root -> key)
    	
    	slt   $t3, $t1, $t2			# t3 = ((newNode->key) < (root->key))
    	
    	beq   $t3, $zero, insert_right_child	# if (((newNode->key) >= (root->key)): insert right
    	
insert_left_child:
	lw    $t4, 4($a0)			# t4 = (root -> left)
	beq   $t4, $zero, empty_left_child	# if (root -> left == NULL): insert empty left child
	
	add   $a0, $t4, $zero			# bst_insert(root->left, newNode)
	jal   bst_insert
	j     insert_epilogue
	
empty_left_child:
	sw    $a1, 4($a0)			# (root->left) = newNode
	j     insert_epilogue

insert_right_child:
    	lw    $t4, 8($a0)    			# t4 = (root -> right)
    	beq   $t4, $zero, empty_right_child	# if (root -> right == NULL): insert empty right child

    	add   $a0, $t4, $zero  			# bst_insert(root->right, newNode)
    	jal   bst_insert
    	j     insert_epilogue
    	
empty_right_child:
	sw    $a1, 8($a0)			# (root->right) = newNode
	j     insert_epilogue
    	
root_null:
    	add   $v0, $zero, $a1        		# return newNode as the root

# Epilogue
insert_epilogue:
    	lw    $fp, 0($sp)        		# Restore caller’s frame pointer
    	lw    $ra, 4($sp)        		# Restore return address
    	lw    $a0, 8($sp)        		# Restore a0
    	lw    $a1, 12($sp)       		# Restore a1
    	addiu $sp, $sp, 24       		# Deallocate stack space
    	jr    $ra
