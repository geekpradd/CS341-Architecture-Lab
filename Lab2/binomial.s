.data
prompt_n:
    .asciiz "Enter n: "

wish:
    .asciiz "\nWish to continue?: "

prompt_r:
    .asciiz "Enter r:​ "

C:
    .asciiz "C"

GAP:
    .asciiz ": "

.text

binom:
    addi $sp, $sp, -16
    sw $ra, 8($sp)
    sw $a2, 4($sp)
    sw $a1, 0($sp)

    beq $a2, $zero, RETONE

    li $t5, 1
    slt $t0, $a1, $a2
    beq $t0, $t5, RETZERO # this is the case when  r > n

    beq $a1, $t5, RETONE

    addi $a1, $a1, -1
    addi $a2, $a2, -1

    jal binom 

    sw $v1, 12($sp)
    lw $ra, 8($sp)
    lw $a2, 4($sp)
    lw $a1, 0($sp)

    addi $a1, $a1, -1

    jal binom 

    lw $t4, 12($sp)
    lw $ra, 8($sp)
    lw $a2, 4($sp)
    lw $a1, 0($sp)

    add $v1, $v1, $t4
    addi $sp, $sp, 16
    jr $ra

RETONE:
    li $v1, 1
    addi $sp, $sp, 16
    jr $ra

RETZERO:
    move $v1, $zero
    addi $sp, $sp, 16
    jr $ra


main:
    li $v0, 4 #print string
    la $a0, prompt_n
    syscall

    li $v0, 5
    syscall 
    move $a1, $v0

    li $v0, 4 #print string
    la $a0, prompt_r
    syscall

    li $v0, 5
    syscall 
    move $a2, $v0 #

    jal binom

    move $a0, $a1
    li $v0, 1
    syscall 

    li $v0, 4 #print string
    la $a0, C
    syscall

    move $a0, $a2
    li $v0, 1
    syscall 

    li $v0, 4 #print string
    la $a0, GAP
    syscall

    move $a0, $v1
    li $v0, 1
    syscall 

    li $v0, 4 #print string
    la $a0, wish
    syscall

    li $v0, 12
    syscall

    move $t6, $v0

    li $v0, 12
    syscall

    li $t7, 89

    beq $t6, $t7, main


EXIT:
	li $v0 10 # exit
	syscall
