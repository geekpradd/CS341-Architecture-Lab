
.data 
array:
    .space 240 #60 element array

dp_pos:
    .space 240 # dp[i][0] essentially, where 0 indicates startin index is local maxima

dp_neg:
    .space 240 # dp[i][1] essentially, where 0 indicates startin index is local minima,

# space for 60 entries allocated

prompt:
    .asciiz "Enter the size of the array\n"

prompt_second:
    .asciiz "Enter the elements of the array\n"

.text
main:
	li $t0, 0 # equivalent to setting i=0
    li $v0, 4 #print string
    la $a0, prompt
    syscall

    li $v0, 5
    syscall 
    move $s0, $v0 # store the size in s0
    sll $s0, $s0, 2 # s0 = s0*4, since size should be in bytes

    li $v0, 4 # print prompt_second
    la $a0, prompt_second
    syscall

LOOP:

	li $v0 5 #read int syscall
    syscall
    sw $v0, array($t0) #storeread  int in array
    sw $0, dp_pos($t0) # set dp values to 0
    sw $0, dp_neg($t0)
    addi $t0, $t0, 4 # increment counter
    bne $t0, $s0, LOOP

    #at the end of the above iteration $t0 = $s0, which points to just beyond array allocated memory

    add $s1, $0, $0 # set s1 to 0, which will point to start of array allocated memory
    #answer will be stored in s4, set it to 0 intially
    add $s4, $0, $0
    j DP_POPULATE # fill DP table


CUSTOM_MAX:
    # a simple max function that sets 
    # t5 = max(t6, t5)
    blt $t5, $t6, SET_T6
    jr $ra

SET_T6:
    move $t5 $t6
    jr $ra
    
FINISH_ZERO:
    # this is the final code that runs when we have finished computing dp[i][0]
    sw $t5, dp_pos($t0) # store the value of dp[i][0] which was being stored in t5 so far into the array in memory
    addi $t1, $t0, 4 # set j = i +1
    addi $t5, $0, 1 # store dp[i][1] in t5 initially,set to one
    j ITERATE_J_ONE

# the code below updates the final answer $s4, to max of dp[i][0], s4, dp[i][1], beginning at FINISH_ONE (after dp[i][1] computed)

SET_NEG:
    lw $s4 dp_neg($t0)
    j FINISH_ONE_PART_TWO

SET_POS:
    lw $s4 dp_pos($t0)
    j DP_POPULATE

FINISH_ONE:
    sw $t5, dp_neg($t0)
    blt $s4, $t5, SET_NEG

FINISH_ONE_PART_TWO:
    lw $t5, dp_pos($t0)
    blt $s4, $t5, SET_POS

# main dp loop

DP_POPULATE:
    beq $t0, $s1, PRINT_ANSWER # once t0 becomes 0 we are done iterating (i+1 becomes 0), address corresponding to i+1 in t0 intiially
    move $t1, $t0 # t1 is basically j > i (i+1 stored in t0 intiially is j)
    addi $t0, $t0, -4 #i stored in $t0 now
    addi $t5, $0, 1 #t5 = dp[i][0], set to 1

ITERATE_J_ZERO:
    beq $t1, $s0, FINISH_ZERO # j = n, finish for zero

    lw $t7, dp_neg($t1)
    lw $t8, array($t1)
    lw $t9, array($t0) # load values into reisters

    addi $t6, $t7, 1 # set t6 = 1 + dp[j][1]

    blt $t8, $t9, UPDATE_ZERO # if a[j] < a[i], try to update
    j NEXT_STEP_ZERO # else move to next step (next iteration)

UPDATE_ZERO:
    jal CUSTOM_MAX

NEXT_STEP_ZERO:
    addi $t1, $t1, 4 # move j to next index
    j ITERATE_J_ZERO

ITERATE_J_ONE:
    # now compute dp[i][1], analgous to zero case
    beq $t1, $s0, FINISH_ONE # j = n, finish 

    lw $t7, dp_pos($t1)
    lw $t8, array($t1)
    lw $t9, array($t0) # load values

    addi $t6, $t7, 1 # set t6 = 1 + dp[j][0]
    blt $t9, $t8, UPDATE_ONE # if a[i] < a[j] update
    j NEXT_STEP_ONE

UPDATE_ONE:
    jal CUSTOM_MAX

NEXT_STEP_ONE:
    addi $t1, $t1, 4 # move j to next index
    j ITERATE_J_ONE

PRINT_ANSWER:
    # at the end print the answer
    li $v0 1
    move $a0, $s4
    syscall 

# Exit code
EXIT:
	li $v0 10 # exit
	syscall


