	.text
addi $t0, $zero, 19
addi $t1, $zero, 2
div $t0, $t1
mflo $a0
li $v0, 1
syscall