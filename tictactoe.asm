#Tic-Tac-Toe
#Ronny Valtonen

.data
grid: .word '_' '_' '_' '_' '_' '_' '_' '_' '_'
prompt: .asciiz "\nAre you 'X' or 'O':"
input: .asciiz "\nEnter a number from 1-9 starting from the top left:"
player2: .asciiz "\nO has won."
player1: .asciiz "\nX has won."
playAgain: .asciiz "\nNew game? (Y/n)"

#Begin program
.text
start:

	#Player 1 Prompt
	la $a0, prompt
	li $v0, 4
	syscall
	
	#Check for entry
	li $v0, 12
	syscall
	
	#Set player 1 move
	move $s0, $v0
	
	#Set player 2 entry
	beq $s0, 'X', setPlayer2
	li $s1, 'X'

setPlayer2:
	li $s1, 'O'
	la $s2, grid
	
	#Print the board
	move $a0, $s2
	jal gridDisplay
	
#Loop until win
repeat:
	#Player 1 Moves
	move $a0, $s2
	move $a1, $s0
	jal placeMark
	move $a0, $s2
	jal gridDisplay
	move $a0, $s2
	move $a1, $s0
	jal checkWinner
	beq $v0, 0, next
	li $v0, 4
	la $a0, player1
	syscall
	j nextGame
	
next:
	#Player 2 Moves
	move $a0, $s2
	move $a1, $s1
	jal placeMark
	move $a0, $s2
	jal gridDisplay
	move $a0, $s2
	move $a1, $s1
	jal checkWinner
	beq $v0, 0, repeat
	li $v0, 4
	la $a0, player2
	syscall
	j nextGame
	
nextGame:
	la $a0, playAgain
	li $v0, 4
	syscall
	li $v0, 12
	syscall
	beq $v0, 'Y', start
#End of Tic-Tac-Toe

end:
	li $v0, 10
	syscall

#Board Printing
gridDisplay:
	li $t0, 1
	move $t1, $a0
	li $t3, 3
	li $a0, 10
	li $v0, 11
	syscall
	
dispLoop:
	bgt $t0, 9, retDisp
	lw $a0, ($t1)
	li $v0, 11
	syscall
	div $t0, $t3
	mfhi $t2
	beqz $t2, nextLine
	#Space
	li $a0, 32
	li $v0, 11
	syscall
	addi $t0, $t0, 1
	addi $t1, $t1, 4
	j dispLoop
	
nextLine:
	li $a0, 10
	li $v0, 11
	syscall
	addi $t0, $t0, 1
	addi $t1, $t1, 4
	j dispLoop

retDisp:
	jr $ra
	
placeMark:
	move $t0, $a0
	la $a0, input
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	addi $v0, $v0, -1
	mul $v0, $v0, 4
	add $t0, $t0, $v0
	lw $t1, ($t0)
	beq $t1, '_', change
	jr $ra

change:
	sw $a1, ($t0)
	jr $ra
	
checkWinner:
	move $t0, $a0
	li $t1, 1
	li $v0, 1
	
loop:
	bgt $t1, 9, ret
	lw $t2, ($t0)
	beq $t2, $a1, nextCol2
	addi $t0, $t0, 4
	lw $t2, ($t0)
	addi $t1, $t1, 1
	beq $t2, $a1, nextCol2
	addi $t0, $t0, 4
	lw $t2, ($t0)
	addi $t1, $t1, 1
	beq $t2, $a1, nextCol3
	li $v0, 0
	j ret
	
nextCol2:
	addi $t0, $t0, 4
	lw $t2, ($t0)
	addi $t1, $t1, 1
	beq $t2, $a1, nextCol3
	addi $t0, $t0, 8
	lw $t2, ($t0)
	addi $t1, $t1, 1
	beq $t2, $a1, nextRow
	addi $t0, $t0, 8
	lw $t2, ($t0)
	addi $t1, $t1, 1
	beq $t2, $a1, nextDiag
	
nextCol3:
	addi $t0, $t0, 4
	lw $t2, ($t0)
	addi $t1, $t1, 1
	beq $t2, $a1, ret
	j loop
	
nextRow:
	addi $t0, $t0, 12
	lw $t2, ($t0)
	addi $t1, $t1, 1
	beq $t2, $a1, ret
	j loop
	
nextDiag:
	addi $t0, $t0, 16
	lw $t1, ($t0)
	addi $t1, $t1, 1
	beq $t2, $a1, ret
	j loop
	
ret:
	jr $ra
	
	