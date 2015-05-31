## EE352 FINAL PROJECT
## Cache Simulation implementing Set Associativity and LRU Policy
## Name: Tiffany Ashley Tjahjadi

.data 
	cache: .space 262144

	cacheSizePrompt: .asciiz "Cache size: 2^"

	lineSizePrompt: .asciiz "Line size: 2^"

	missPenaltyPrompt:.asciiz "Miss penalty: "

	space: .asciiz " "
	
	newline: .asciiz "\n"
	
	fileName: .asciiz "trace.txt"
	
	totalHitRate: .asciiz "Total Hit Rate: "
	
	totalRunTime: .asciiz "Total Run Time: "
	
	averageMemAccLatency: .asciiz "Average Memory Access Latency: " 
	
	percent: .asciiz "%"
	
	fileContents: .space 262144	

.text
main:
	
# Data Input (IF WE HAVE TIME, INCLUDE ERROR HANDLING)
	# input cache size
	li $v0, 4
	la $a0, cacheSizePrompt
	syscall 
    	li $v0, 5
	syscall
	add $t0, $v0, 0
	
	# input line size
	li $v0, 4
	la $a0, lineSizePrompt
	syscall 
    	li $v0, 5
	syscall
	add $t1, $v0, 0
	
	# input miss penalty
	li $v0,4
	la $a0, missPenaltyPrompt
	syscall 
    	li  $v0, 5
	syscall
	add $t2, $v0, 0
	
	li $v0, 4
	la $a0, newline
	syscall
	
# Calculations
	# $t3 = linesPerSetbits
	sub $t3, $t0, $t1 
	div $t3, $t3, 2
	# $t8 = setBits
	sub $t8, $t0, $t1
	sub $t8, $t8, $t3
	# $t7 = tagBits
	add $t7, $0, 32
	sub $t7, $t7, $t8
	sub $t7, $t7, $t1
		
# File Input
	# open a file for writing
	li   $v0, 13       # system call for open file
	la   $a0, fileName      # board file name
	li   $a1, 0        # Open for reading
	li   $a2, 0
	syscall            # open a file (file descriptor returned in $v0)
	move $s6, $v0      # save the file descriptor 
	# read from file
	li   $v0, 14       # system call for read from file
	move $a0, $s6      # file descriptor 
	la   $a1, fileContents   # address of buffer to which to read
	li   $a2, 10000     # hardcoded buffer length
	syscall            # read from file
	# Close the file 
	li   $v0, 16       # system call for close file
	move $a0, $s6      # file descriptor to close
	syscall            # close file
	# parse string by bit
	li $s4, 1 		# initialize 1 bit
	sllv $s4, $s4, $t0	# shift through cache by 1 from the end
	srlv $s4, $s4, $t1	# shift through line by 1 from the beginning
	add $s3, $0, -1		# initialize -1 flag 
	
fillarray:
	#make cache empty
	li $s2, 4		# bits per word
	mult $s4, $s2		# find address in cache
	mflo $s2		
	sw $s3, cache($s2)	# store -1 flag in location
	sub $s4, $s4, 1		# go to next index in cache
	bgez $s4, fillarray	# loop until entire cache is "empty"
 
	li $t0, -1
	li $s7, 268435456
	li $s2, 0		# reinitialize all the values used 
	li $t4, 0
	li $t5, 0
	li $t6, 0
		
readchar: # read each bit, process hex values until '\n'
	add $t0, $t0, 1
	lb $t7, fileContents($t0)
	beq $t7, 'Z', end
	beq $t7, '0', zero
	beq $t7, '1', one
	beq $t7, '2', two
	beq $t7, '3', three
	beq $t7, '4', four
	beq $t7, '5', five
	beq $t7, '6', six
	beq $t7, '7', seven
	beq $t7, '8', eight
	beq $t7, '9', nine
	beq $t7, 'a', A
	beq $t7, 'b', B
	beq $t7, 'c', C
	beq $t7, 'd', D
	beq $t7, 'e', E
	beq $t7, 'f', F
	beq $t7, 'A', A
	beq $t7, 'B', B
	beq $t7, 'C', C
	beq $t7, 'D', D
	beq $t7, 'E', E
	beq $t7, 'F', F
	beq $t7, '\n', endline
zero:
	srl $s7, $s7, 4
	j readchar
one:
	li $t9, 1
	mult $s7, $t9
	mflo $t9
	srl $s7, $s7, 4
	add $s2, $s2, $t9
	j readchar
two:
	li $t9, 2
	mult $s7, $t9
	mflo $t9
	srl $s7, $s7, 4
	add $s2, $s2, $t9
	j readchar
three:
	li $t9, 3
	mult $s7, $t9
	mflo $t9
	srl $s7, $s7, 4
	add $s2, $s2, $t9
	j readchar
four:
	li $t9, 4
	mult $s7, $t9
	mflo $t9
	srl $s7, $s7, 4
	add $s2, $s2, $t9
	j readchar
five:
	li $t9, 5
	mult $s7, $t9
	mflo $t9
	srl $s7, $s7, 4
	add $s2, $s2, $t9
	j readchar
six:
	li $t9, 6
	mult $s7, $t9
	mflo $t9
	srl $s7, $s7, 4
	add $s2, $s2, $t9
	j readchar
seven:
	li $t9, 7
	mult $s7, $t9
	mflo $t9
	srl $s7, $s7, 4
	add $s2, $s2, $t9
	j readchar
eight:
	li $t9, 8
	mult $s7, $t9
	mflo $t9
	srl $s7, $s7, 4
	add $s2, $s2, $t9
	j readchar
nine:
	li $t9, 9
	mult $s7, $t9
	mflo $t9
	srl $s7, $s7, 4
	add $s2, $s2, $t9
	j readchar
A:
	li $t9, 10
	mult $s7, $t9
	mflo $t9
	srl $s7, $s7, 4
	add $s2, $s2, $t9
	j readchar
B:
	li $t9, 11
	mult $s7, $t9
	mflo $t9
	srl $s7, $s7, 4
	add $s2, $s2, $t9
	j readchar
C:
	li $t9, 12
	mult $s7, $t9
	mflo $t9
	srl $s7, $s7, 4
	add $s2, $s2, $t9
	j readchar
D:
	li $t9, 13
	mult $s7, $t9
	mflo $t9
	srl $s7, $s7, 4
	add $s2, $s2, $t9
	j readchar
E:
	li $t9, 14
	mult $s7, $t9
	mflo $t9
	srl $s7, $s7, 4
	add $s2, $s2, $t9
	j readchar
F:
	li $t9, 15
	mult $s7, $t9
	mflo $t9
	srl $s7, $s7, 4
	add $s2, $s2, $t9
	j readchar
endline: # actually process each address here, address decimal value stored in s2
	li $s3, 1
	add $s7, $t8, $t1
	sllv $s3, $s3, $s7
	div $s2, $s3
	mfhi $s3 # s3 = value of setBits and lineBits of address
	li $s4, 1
	sllv $s4, $s4, $t1
	div $s2, $s4
	mfhi $s4 # s4 = value of lineBits of address
	sub $s7, $s3, $s4
	li $s0, 1
	sllv $s0, $s0, $t1
	div $s7, $s0
	mflo $s0 # s0 = setIndex
	sub $s1, $s2, $s3 # s1 = tag
	
	add $t6, $t6, 1 # increment totalMemAcc
	
	li $s3, 1
	sllv $s3, $s3, $t3 # Math.pow(2, t3) is saved in $s3 because its used so often
	mult $s0, $s3
	mflo $s5 # s5 = counter1
findHit: # loop through set and find tag
	add $s4, $s0, 1
	mult $s3, $s4
	mflo $s4
	beq $s4, $s5, miss # didnt find tag
	li $s4, 4
	mult $s5, $s4
	mflo $s4
	lw $s4, cache($s4)
	beq $s4, $s1, foundHit # found tag
	add $s5, $s5, 1
	j findHit
	
foundHit:
	add $t4, $t4, 1 # increment totalHits
	add $s6, $s5, 1 # s6 = counter2
shift: # shift values in set to make space for insert
	add $s4, $s0, 1
	mult $s4, $s3
	mflo $s4
	beq $s4, $s6, endshift # reached adjacent set, stop
	li $s4, 4
	mult $s4, $s6
	mflo $s4
	lw $s4, cache($s4)
	beq $s4, -1, endshift # found empty spot, stop
	li $s2, 4
	add $s4, $s6, -1
	mult $s4, $s2
	mflo $s4
	mult $s2, $s6
	mflo $s2
	lw $s2, cache($s2)
	sw $s2, cache($s4)
	add $s6, $s6, 1
	j shift
	
endshift: # done shifting, now insert in MRU position
	sub $s6, $s6, 1
	li $s4, 4
	mult $s4, $s6
	mflo $s4
	sw $s1, cache($s4)
	li $s7, 268435456
	li $s2, 0
	j readchar
miss:
	add $t5, $t5, 1
	add $s5, $s0, 1
	mult $s5, $s3
	mflo $s5
	sub $s5, $s5, 1 # set counter1 (s5)
	mult $s0, $s3
	mflo $s6
	add $s6, $s6, 1 # set counter2 (s6)
	li $s4, 4
	mult $s4, $s5
	mflo $s4
	lw $s4, cache($s4)
	bne $s4, -1, fullset # last element in set is not -1, so set is full
emptyset: # set has free spots
	mult $s0, $s3
	mflo $s4
	beq $s4, $s5, endmiss1 # set is completely empty
	li $s2, 4
	add $s4, $s5, -1
	mult $s4, $s2
	mflo $s4
	lw $s4, cache($s4)
	bne $s4, -1, endmiss2 # found spot to be filled
	sub $s5, $s5, 1
	j emptyset

fullset: # set is full, need to shift and replace LRU
	add $s4, $s0, 1
	mult $s4, $s3
	mflo $s4
	beq $s4, $s6, endmiss3 # shifted all elements
	li $s2, 4
	add $s4, $s6, -1
	mult $s4, $s2
	mflo $s4
	mult $s6, $s2
	mflo $s2
	lw $s2, cache($s2)
	sw $s2, cache($s4)
	add $s6, $s6, 1
	j fullset # keep shifting
	
endmiss1: # store in first element of set (MRU)
	li $s2, 4
	mult $s4, $s2
	mflo $s4
	sw $s1, cache($s4)
	li $s7, 268435456
	li $s2, 0
	j readchar

endmiss2: # store at counter position of set (MRU)
	li $s2, 4
	mult $s5, $s2
	mflo $s5
	sw $s1, cache($s5)
	li $s7, 268435456
	li $s2, 0
	j readchar
	
endmiss3: # insert tag in MRU position
	sub $s6, $s6, 1
	li $s4, 4
	mult $s4, $s6
	mflo $s6
	sw $s1, cache($s6)
	li $s7, 268435456
	li $s2, 0
	j readchar

end: # load into floating point registers, calculate, print
	mtc1 $t4, $f4
	cvt.s.w $f4, $f4
	mtc1 $t5, $f5
	cvt.s.w $f5, $f5
	mtc1 $t6, $f6
	cvt.s.w $f6, $f6
	mtc1 $t2, $f7
	cvt.s.w $f7, $f7
	
	div.s $f1, $f4, $f6
	li $s4, 100
	mtc1 $s4, $f0
	cvt.s.w $f0, $f0
	mul.s $f1, $f1, $f0
	mul.s $f2, $f5, $f7
	add.s $f2, $f2, $f6
	div.s $f3, $f2, $f6
	
	mtc1 $0, $f0
	cvt.s.w $f0, $f0
	li $v0, 4
	la $a0, totalHitRate
	syscall
	li $v0, 2
	add.s $f12, $f1, $f0
	syscall
	li $v0, 4
	la $a0, percent
	syscall
	la $a0, newline
	syscall
	la $a0, totalRunTime
	syscall
	li $v0, 2
	add.s $f12, $f2, $f0
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	la $a0, averageMemAccLatency
	syscall
	li $v0, 2
	add.s $f12, $f3, $f0
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 10
	syscall
