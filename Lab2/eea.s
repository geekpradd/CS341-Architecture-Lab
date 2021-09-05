.data
prompt_a:
    .asciiz "Enter a: "

wish:
    .asciiz ")\nWish to continue?: "
newline:
    .asciiz "\n"
prompt_m:
    .asciiz "Enter m:​ "

STAR:
    .asciiz "*"

NEXT:
    .asciiz " = 1 (mod "

GAP:
    .asciiz " and "

.text

eea:
    addi $sp, $sp, -12
    sw $ra, 8($sp)
    sw $a2, 4($sp)
    sw $a1, 0($sp)

    beq $a2, $zero, BASECASE
    div $a1, $a2 
    move $a1, $a2
    mfhi $a2

    jal eea

    lw $ra, 8($sp)
    lw $a2, 4($sp)
    lw $a1, 0($sp)
    div $a1, $a2 

    mflo $t3

    mul $t3, $t3, $v1
    sub $t4, $v0, $t3

    move $v0, $v1
    move $v1, $t4

    addi $sp, $sp, 12
    jr $ra

BASECASE:
    li $v0, 1
    li $v1, 0
    addi $sp, $sp, 12
    jr $ra


main:
    li $v0, 4 #print string
    la $a0, prompt_a
    syscall

    li $v0, 5
    syscall 
    move $a1, $v0

    li $v0, 4 #print string
    la $a0, prompt_m
    syscall

    li $v0, 5
    syscall 
    move $a2, $v0 #

    jal eea

    move $t5, $v0
    div $v0, $a2
    mfhi $t4

    li $t7, -1
    blt $t7, $t4, REM
    add $t4, $t4, $a2

REM:
    move $a0, $a1
    li $v0, 1
    syscall 

    li $v0, 4 #print string
    la $a0, STAR
    syscall

    move $a0, $t4
    li $v0, 1
    syscall

    li $v0, 4 #print string
    la $a0, NEXT
    syscall

    move $a0, $a2
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
