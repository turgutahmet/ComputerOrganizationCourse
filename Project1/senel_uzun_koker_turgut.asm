#Koray Emre Þenel - 150117037
#Mehmet Etka Uzun - 150118504
#Alperen Köker - 150117035
#Ahmet Turgut - 150117046

.data
menuText: .asciiz "Welcome to our MIPS project!\nMain Menu:\n1. Count Alphabetic Characters\n2. Sort Numbers\n3. Prime (N)\n4. Huffman Coding\n5. Exit\nPlease select an option: "
enterStrText: .asciiz "Enter the String: "
outputText1: .asciiz "Character Occurence"
outputLine: .asciiz "_______________________"
tab: .asciiz "		"
charA: .byte 'a'
space: .asciiz "\n"
inputString: .space 256
myArray: .space 104
myArray2: .space 104
myArray3: .space 104
buffer: .space 1024
space2: .asciiz " "
str2:  .asciiz "\nYou wrote:"
newLine: .asciiz "\n"
minus: .asciiz "-"
xd: .word 1000000
msg1: .asciiz "Please enter an integer number for num_prime(N): \n"
string1: .space 1024
array: .word 1:1000000
arrayData: .word 0:100 #node data 1 3 5 6 4
arrayChar: .word 0:100 #node char a b c d -
arrayLeft: .word 1:100 #node left data 0 0 0 0 1
arrayRight: .word 1:100 #node right data 0 0 0 0 3
arrayDelete: .word 0:100 #node is delete? 1 1 0 0 0
HufmannInput: .space 256
HufmannStr1: .asciiz "Enter the string to construct Huffman Code:"
HufmannStr2: .asciiz "Enter the string to be converted using Huffman Code:"	
arrayConvertedString: .word 2:10000


.text
main:
	menu:
		li $v0, 4
		la $a0, menuText
		syscall
		li $v0, 5
		syscall
		move $t0, $v0
		beq $t0, 1, countChar
		beq $t0, 2, sortNumbers
		beq $t0, 3, prime
		beq $t0, 4, huffman
		beq $t0, 5, exitCode
		
		
		
	countChar:
		li $t0, 0
		li $t1, 26
		loopZero:
			beq $t1, $t0, exitZero
			sb $zero, myArray($t0)	
			sb $zero, myArray2($t0)	
			sb $zero, myArray3($t0)	
			addi $t0, $t0, 1
			j loopZero 
		exitZero:
		
		li $v0, 4
		la $a0, enterStrText
		syscall
		li $v0, 8
		la $a0, inputString
		li $a1, 256
		syscall
	
		li $t3, -87 #t3 = -87
		la $s0, charA #s0 = 'a'
		la $s1, inputString #s1 = input
		
		loop:
			lb $t1, 0($s1) #t1 = input[i] 
			lb $t2, 0($s0) #t2 = 'a'
			beqz $t1, exit 
    			ble $t1, 90, fun
			sub $t0, $t1, $t2 #t0 = t1 - t2
			beq $t3, $t0, exit #if t0 == -87 exit
			lb $t4, myArray($t0)
			addi $t4, $t4, 1
			sb $t4, myArray($t0)
			addi $s1, $s1, 1
			j loop 
		
		fun:
			addi $t5, $t1, 32
			sub $t0, $t5, $t2 #t0 = t1 - t2
			beq $t3, $t0, exit
			lb $t4, myArray($t0)
			addi $t4, $t4, 1	
			sb $t4, myArray($t0)
			addi $s1, $s1, 1
			j loop
		
		exit:
		
		li $t0, 0
		li $t1, 26
		loop2:
			beq $t1, $t0, exit2
			sb $t0, myArray2($t0)	
			addi $t0, $t0, 1
			j loop2 
		exit2:
		
		li $t0, 0
		li $t1, 26
		loop42:
			beq $t1, $t0, exit42
			lb $t2, myArray($t0)
			sb $t2, myArray3($t0)	
			addi $t0, $t0, 1
			j loop42 
		exit42:
		
		li $t0, 0 # t0 = 0
		li $t1, 25 # t1 = 25
		
		forloop:
			beq $t1, $t0, exit3 # if  t0 == t1 exit3
			li $t2, 0 #t2 = 0
			sub $t3, $t1, $t0 # t3 = $t1 - $t0
		forloopInner:
			beq $t3, $t2, exit4# if t3 == t2 exit4		
		 	addi $t4, $t2, 1 #t4 = t2 + 1
		 	lb $t5, myArray3($t2) # t5 = myArray[t2]
		 	lb $t6, myArray3($t4) # t6 = myArray[t4]	
		 	blt $t5, $t6, fun1 # if t5 < t6 fun1 
		 	addi $t2, $t2, 1 #t2++
			j forloopInner
		
		fun1:
			lb $t5, myArray2($t2) #t5 = myArray2[t2]
		 	lb $t6, myArray2($t4) #t6 = myArray2[t4]
		 	sb $t6, myArray2($t2) #myArray2[t2] = t6
		 	sb $t5, myArray2($t4) #myArray2[t4] = t5
		 	lb $t5, myArray3($t2) #t5 = myArray2[t2]
		 	lb $t6, myArray3($t4) #t6 = myArray2[t4]
		 	sb $t6, myArray3($t2) #myArray2[t2] = t6
		 	sb $t5, myArray3($t4) #myArray2[t4] = t5
		 	addi $t2, $t2, 1 #t2++
			j forloopInner
		

		exit4:
			addi $t0, $t0, 1 # t0++
			j forloop
		
		exit3:
		li $v0, 4
		la $a0, outputText1 	
		syscall	
		li $v0, 4
		la $a0, space
		syscall
		li $v0, 4
		la $a0, outputLine
		syscall
		li $v0, 4
		la $a0, space
		syscall
		li $t0, 0
		li $t1, 26
		loop3:
			beq $t1, $t0, exit10
			lb $t2, myArray2($t0)
			lb $t4, myArray($t2)
			lb $t5, 0($s0) #t2 = 'a'
			add $t5, $t5, $t2
			beq $t4, 0, increaseI
			move $s2, $t5
			li $v0, 11
			move $a0, $s2
			syscall
			li $v0, 4
			la $a0, tab
			syscall	
			li $v0, 1
			move $a0, $t4
			syscall
			li $v0, 4
			la $a0, space
			syscall	
			addi $t0, $t0, 1
			j loop3
		increaseI:
		 	addi $t0, $t0, 1
			j loop3
		exit10:
			j menu	
		
		
		
		
	sortNumbers:
		la $a0, enterStrText    # Load and print string asking for string
    		li $v0, 4
    		syscall

    		la $a0,space2
    		li $v0,4
    		syscall
    		li $v0, 8       # take in input

    		la $a0, buffer  # load byte space into address
    		li $a1, 1024      # allot the byte space for string


   		move $t0, $a0   # save string to t0
    		syscall
		
		li $t1, 0 # arrays input 
    		li $t5,10 # 10
    		la $t6, newLine # to end loop
   		lb $t6, 0($t6) 
    		li $t7, 1 # minusFlag
    		li $t8,0
   		li $t9,0
		loopSort:
    			lb $t2, 0($t0) # load the next character into t2   1 6 23 -31
    			beq $t2,$t6,exitSort
   			lb $t4 , minus
    			beq $t2,$t4,minusFlag
    			lb $t3,space2
    			beq $t2,$t3,arrayFill # increment the string pointer
    			mul $t1 , $t1 ,$t5 
    			andi $t2,$t2,0x0F # where $t0 contains the ascii digit .
   			add $t1 , $t1 , $t2
    			addi $t0, $t0, 1 
    			j loopSort # return to the top of the loop
    		exitSort:
			mul $t1 , $t1 , $t7
        		addi $t8, $t8, 1 
        		sb $t1, xd($t9)
        		li $t0, 0 # t0 = 0
    			subi $t9, $t8, 1  # t9 = t8 - 1
    		forloopSort:
        		beq $t9, $t0, exit3Sort # if  t0 == t1 exit3
        		li $t2, 0 #t2 = 0
        		sub $t3, $t9, $t0 # t3 = $t1 - $t0
    		forloopInnerSort:
        		beq $t3, $t2, exit4Sort# if t3 == t2 exit4
        		sll $t7, $t2, 2
        		addi $t4, $t7, 4 #t4 = t2 + 1
        		lb $t5, xd($t7) # t5 = myArray[t2]
        		lb $t6, xd($t4) # t6 = myArray[t4]
        		bgt $t5, $t6, fun1Sort # if t5 < t6 fun1 
       			addi $t2, $t2, 1 #t2++
        		j forloopInnerSort

    		fun1Sort:
       			lb $t5, xd($t7) #t5 = myArray2[t2]
        		lb $t6, xd($t4) #t6 = myArray2[t4]
        		sb $t6, xd($t7) #myArray2[t2] = t6
       			sb $t5, xd($t4) #myArray2[t4] = t5
        		addi $t2, $t2, 1 #t2++
        		j forloopInnerSort


    		exit4Sort:
        		addi $t0, $t0, 1 # t0++
        		j forloopSort

    		exit3Sort:
    		
    		li $t0, 0 # t0 = 0
        	printSort:
        		beq $t8, $t0, exit5Sort
        		sll $t2, $t0, 2
        		lb $a0, xd($t2)
        		li $v0, 1
        		syscall
        		li $v0, 4
			la $a0, newLine
			syscall
        		addi $t0, $t0, 1
			j printSort
	
		exit5Sort:
			j menu
		
		arrayFill:
      			mul $t1 , $t1 , $t7
       			sb $t1, xd($t9)
       			addi $t9,$t9,4
        		li $t1, 0
        		li $t7, 1
        		addi $t0, $t0, 1 
        		addi $t8, $t8, 1 
    		j loopSort

    		minusFlag:
        		addi $t0, $t0, 1 
        		addi $t7 , $t7, -2
    		j loopSort
	prime:	
		la $a0, enterStrText    # Load and print string asking for string
        	li $v0, 4
        	syscall

        	la $a0,space2
        	li $v0,4
        	syscall
        	li $v0, 8       # take in input

        	la $a0, buffer  # load byte space into address
        	li $a1, 1024      # allot the byte space for string

    		move $t0, $a0   # save string to t0
        	syscall
		li $t1,0
		li $t5,10
		la $t6, newLine
		lb $t6, 0($t6)
		
		loopPrime:
			lb   $t2,0($t0)
			beq  $t2,$t6,exitPrime
			mul  $t1,$t1,$t5
			andi $t2,$t2,0x0F
			add  $t1,$t1,$t2
    			addi $t0,$t0,1
			j loopPrime
		exitPrime:
       			addi $t0,$zero,2 # $t0 = 2 = p
        		addi $t2,$zero,0
        		addi $t3,$zero,0
        		addi $t4,$zero,0
       		 	addi $t5,$zero,0
        		addi $t6,$zero,0
        		addi $t9,$zero,0
			j calculatePrime
		calculatePrime: 
			mul $t2,$t0,$t0 #t0 = p , $t2 = p*p
			addi $t3,$zero,2 # t3 = i = 2 for print section
			bgt $t2, $t1, printPrime  #greater than p^2 > n
			add $t4,$zero,$t0  #t4 = p
			sll $t4,$t4,2		#t4=p*4
			lw  $t5,array($t4)   #t5 = array[p]
			addi $t6,$zero,1     #t6=1 true 
			mul $t7,$t0,$t0     #t7 = i = p^2
			beq  $t5,$t6, forloop2Prime
			addi $t0,$t0,1 # p++
			j calculatePrime
		forloop2Prime:
			bgt $t7,$t1,increment  
			sll $t4,$t7,2	#t4 = p*4
			sb  $zero,array($t4) #array[i] = 0
			add $t7,$t7,$t0  #i = i + p
			j forloop2Prime
		printPrime:
			bgt $t3,$t1,exit2Prime
			add $t4,$zero,$t3	 #t4 = i
			sll $t4,$t4,2		#t4=i*4
			lw  $t5,array($t4)   #t5 = array[i]
			addi $t6,$zero,1		#t6 = 1	
			beq $t5,$t6,printFuncPrime
			addi $t3,$t3,1  #i = i+1
			j printPrime
		printFuncPrime:
        		addi $t9,$t9,1
        		addi $t3,$t3,1
        		j printPrime
		exit2Prime:
			la $a0,($t9) 
       			li $v0, 1
        		syscall
        		li $v0, 4
			la $a0, space
			syscall
        		j menu
		increment:
			addi $t0,$t0,1 # p++
			j calculatePrime
		
	huffman:
		li $t0, 0
		li $t1, 26
		loopZeroHuffman2:
			beq $t1, $t0, exitZeroHuffman2
			sb $zero, myArray($t0)	
			sb $zero, myArray2($t0)	
			sb $zero, myArray3($t0)	
			addi $t0, $t0, 1
			j loopZeroHuffman2 
		exitZeroHuffman2:
		li $t0, 0
		li $t1, 100
		li $t2, 1
		loopZeroHuffman:
			beq $t1, $t0, exitZeroHuffman
			sb $zero, arrayData($t0)	
			sb $zero, arrayChar($t0)	
			sb $t2, arrayLeft($t0)
			sb $t2, arrayRight($t0)	
			sb $zero, arrayDelete($t0)
			addi $t0, $t0, 1
			j loopZeroHuffman
		exitZeroHuffman:
		li $t0, 0
		li $t1, 10000
		li $t2, 2
		loopZeroHuffman1:
			beq $t1, $t0, exitZeroHuffman1
			sb $t2, arrayConvertedString($t0)	
			addi $t0, $t0, 1
			j loopZeroHuffman1
		exitZeroHuffman1:
		li $v0, 4
		la $a0, HufmannStr1
		syscall
					
		li $v0, 8
		la $a0, inputString
		li $a1, 256
		syscall
		
		
		
		
	
		li $t3, -87 #t3 = -87
		la $s0, charA #s0 = 'a'
		la $s1, inputString #s1 = input
		
		loopHuffman:
			lb $t1, 0($s1) #t1 = input[i] 
			lb $t2, 0($s0) #t2 = 'a'
			beqz $t1, exitHuffman 
    			ble $t1, 90, funHuffman
			sub $t0, $t1, $t2 #t0 = t1 - t2
			beq $t3, $t0, exitHuffman #if t0 == -87 exit
			lb $t4, myArray($t0)
			addi $t4, $t4, 1
			sb $t4, myArray($t0)
			addi $s1, $s1, 1
			j loopHuffman 
		
		funHuffman:
			addi $t5, $t1, 32
			sub $t0, $t5, $t2 #t0 = t1 - t2
			beq $t3, $t0, exitHuffman
			lb $t4, myArray($t0)
			addi $t4, $t4, 1	
			sb $t4, myArray($t0)
			addi $s1, $s1, 1
			j loopHuffman
			
		exitHuffman:
			
		li $t0, 0
		li $t1, 26
		loop2Huffman:
			beq $t1, $t0, exit2Huffman
			sb $t0, myArray2($t0)	
			addi $t0, $t0, 1
			j loop2Huffman 
		exit2Huffman:
		
		li $t0, 0
		li $t1, 26
		loop42Huffman:
			beq $t1, $t0, exit42Huffman
			lb $t2, myArray($t0)
			sb $t2, myArray3($t0)	
			addi $t0, $t0, 1
			j loop42Huffman 
		exit42Huffman:
		
		
		

		
		li $t0, 0 # t0 = 0
		li $t1, 25 # t1 = 25
		
		forloopHuffman:
			beq $t1, $t0, exit3Huffman # if  t0 == t1 exit3
			li $t2, 0 #t2 = 0
			sub $t3, $t1, $t0 # t3 = $t1 - $t0
		forloopInnerHuffman:
			beq $t3, $t2, exit4Huffman# if t3 == t2 exit4		
		 	addi $t4, $t2, 1 #t4 = t2 + 1
		 	lb $t5, myArray3($t2) # t5 = myArray[t2]
		 	lb $t6, myArray3($t4) # t6 = myArray[t4]	
		 	blt $t5, $t6, fun1Huffman # if t5 < t6 fun1 
		 	addi $t2, $t2, 1 #t2++
			j forloopInnerHuffman
		
		fun1Huffman:
			lb $t5, myArray2($t2) #t5 = myArray2[t2]
		 	lb $t6, myArray2($t4) #t6 = myArray2[t4]
		 	sb $t6, myArray2($t2) #myArray2[t2] = t6
		 	sb $t5, myArray2($t4) #myArray2[t4] = t5
		 	lb $t5, myArray3($t2) #t5 = myArray2[t2]
		 	lb $t6, myArray3($t4) #t6 = myArray2[t4]
		 	sb $t6, myArray3($t2) #myArray2[t2] = t6
		 	sb $t5, myArray3($t4) #myArray2[t4] = t5
		 	addi $t2, $t2, 1 #t2++
			j forloopInnerHuffman
		

		exit4Huffman:
			addi $t0, $t0, 1 # t0++
			j forloopHuffman
			
		exit3Huffman:
		
		
		li $t0, 0
		li $t1, 26
		loop3Huffman:
			beq $t1, $t0, exit10Huffman
			lb $t2, myArray2($t0)
			lb $t4, myArray($t2)
			beq $t4,$zero,exit10Huffman
			lb $t5, 0($s0) #t2 = 'a'
			add $t5, $t5, $t2
			
			addi $t0, $t0, 1
			j loop3Huffman
		exit10Huffman:
			li $t1,0
			li $t6,0
			li $t9,0 #q.size()
			
		
		
		
		storeArrayLoop:
			beq $t0,$zero,initializeForAddingNode
			subi $t0,$t0,1
			lb $t2, myArray2($t0)
			lb $t5, 0($s0) #t2 = 'a'
			add $t5, $t5, $t2
			move $s2, $t5
			
			sw $s2,arrayChar($t1) #new array store process
			
			lb $t4, myArray3($t0)
			move $s2, $t4
			sw $s2,arrayData($t1)
			
			addi $t1,$t1,4
			addi $t9,$t9,1
			
			
			j storeArrayLoop
			
		
		
		FindHufmannChar :
    			lb   $t2,0($t0)
    			beq  $t2,$t6,exit
    			mul  $t1,$t1,$t5
   			andi $t2,$t2,0x0F
    			add  $t1,$t1,$t2
        			addi $t0,$t0,1
    			j FindHufmannChar
    			
    					
		initializeForAddingNode:
			li $s0,0 #address x
			li $s1,1 #size control 
			li $s2,0 #x data
			li $s3,0 #y data
			li $s4,0 #x delete 
			li $s5,0
			li $s6,0
			li $s7,0
			addi $t8,$t9,0 #size2
		
			j startAddingNode
			
		startAddingNode:

			beq $t9,$s1,startAddingNodeExit
			lb $s4,arrayDelete($s0)
			bne $s4,$zero,returnAddingNode
			lb $s2,arrayData($s0) #x for left of node
			sb $s1, arrayDelete($s0) #x's delete is 1
			mul $s6,$t8,4      #size*4 = 6*4 =24
			sb $s0, arrayLeft($s6)   #left added
			addi $s0,$s0,4 #t0+4 = $t0

			lb $s3,arrayData($s0) #y for right of node
			sb $s1, arrayDelete($s0) #y's delete is 1
			add $s5,$s2,$s3     #x.data+y.data

			sb $s5, arrayData($s6)  #newArray indexing
			
			sb $s0, arrayRight($s6)  #right added
			
			addi $t9,$t9,-1
			addi $t8, $t8, 1
			move $s5,$t8
			addi $s5,$s5,-1
			sll $s5,$s5,2
			
			j sorting
			
			
		sorting :
			li $t0, 0 # t0 = 0
			subi $t1, $t8, 1 # t1 = 25
		
			forloopSortHuffman:
        			beq $t1, $t0, exit3SortHuffman # if  t0 == t1 exit3
        			li $t2, 0 #t2 = 0
        			sub $t3, $t1, $t0 # t3 = $t1 - $t0
        			
    			forloopInnerSortHuffman:
    			
        			beq $t3, $t2, exit4SortHuffman# if t3 == t2 exit4
        			sll $t7, $t2, 2
        			addi $t4, $t7, 4 #t4 = t2 + 1
        			lb $t5, arrayData($t7) # t5 = myArray[t2]
        			lb $t6, arrayData($t4) # t6 = myArray[t4]
        			bgt $t5, $t6, fun1SortHuffman # if t5 < t6 fun1 
       			addi $t2, $t2, 1 #t2++
        			j forloopInnerSortHuffman

    			fun1SortHuffman:
       				lb $t5, arrayData($t7) #t5 = myArray2[t2]
        				lb $t6, arrayData($t4) #t6 = myArray2[t4]
        				sb $t6, arrayData($t7) #myArray2[t2] = t6
       				sb $t5, arrayData($t4) #myArray2[t4] = t5
       				lb $t5, arrayLeft($t7) #t5 = myArray2[t2]
        				lb $t6, arrayLeft($t4) #t6 = myArray2[t4]
        				sb $t6, arrayLeft($t7) #myArray2[t2] = t6
       				sb $t5, arrayLeft($t4) #myArray2[t4] = t5
       				
       				lb $t5, arrayRight($t7) #t5 = myArray2[t2]
        				lb $t6, arrayRight($t4) #t6 = myArray2[t4]
        				sb $t6, arrayRight($t7) #myArray2[t2] = t6
       				sb $t5, arrayRight($t4) #myArray2[t4] = t5
       				lb $t5, arrayChar($t7) #t5 = myArray2[t2]
        				lb $t6, arrayChar($t4) #t6 = myArray2[t4]
        				sb $t6, arrayChar($t7) #myArray2[t2] = t6
       				sb $t5, arrayChar($t4) #myArray2[t4] = t5
        				addi $t2, $t2, 1 #t2++
        				j forloopInnerSortHuffman


    			exit4SortHuffman:
        			addi $t0, $t0, 1 # t0++
        			j forloopSortHuffman

    			exit3SortHuffman:
				
			
			j startAddingNode
			
		returnAddingNode:
			addi $s0,$s0,4
			j startAddingNode	
			
		startAddingNodeExit:
			li $v0, 4
			la $a0, HufmannStr2
			syscall	
			li $v0, 8
			la $a0, HufmannInput
			li $a1, 256
			move $t0, $a0 
        			syscall	
			li $t1,0
    			la $t6, newLine
    			lb $t6, 0($t6)
			addi $t6, $t6, 32
			j convertHufmann
			
		convertHufmann: 
    			lb   $t2,0($t0)
    			addi $t2, $t2, 32
    			beq  $t2,$t6,exitConvert
   			li   $t3,0
   			li   $t4,0
   			li   $t5,0
   			li   $t7,0
   			li   $t8,0
   			li   $t9,0
   			addi $t0,$t0,1
    			j findCharInArray #$t2 = a $t0 is address input ,$t6 equal to newline
    		
    			
		
		findCharInArray: 
			lb $t4,arrayChar($t3) 
			beq $t2,$t4,equalChar
			addi $t3,$t3,4
			j findCharInArray
		
		equalChar:

			move $t4,$t3 #char data is 5 in $t4, t2 is 'a' and s5 is root node 100
			li $t3,0
			li $s1,0 		#counter is $s1 is size of char
			
			j findLeftOrRightPattern
			
		findLeftOrRightPattern:
			
			
			beq $t4,$s5,printConvertString  #if last node found jump print

			lb $t7,arrayLeft($t3)	#t7 is arrayLeft data
			lb $t8,arrayRight($t3)   #t8 is arrayRight data
			
			beq $t7,$t4,leftEqual    #if 5 == arrayLeft 
			beq $t8,$t4,rightEqual   #if 5 == arrayRight any element jump rightEqual
			
			addi $t3,$t3,4
			j findLeftOrRightPattern
				
		leftEqual:
			add $t4,$t3,$zero
			li $s0,0 #for print 0
			mul $s3,$s1,4
			sb $s0,arrayConvertedString($s3)
			addi $s1,$s1,1
			li $t3,0
			j findLeftOrRightPattern
			
		rightEqual:
			add $t4,$t3,$zero
			li $s0,1 #for print 1
			mul $s3,$s1,4
			sb $s0,arrayConvertedString($s3)
			addi $s1,$s1,1
			li $t3,0
			j findLeftOrRightPattern
				
		printConvertString:
			
			blt $s3,$zero,convertHufmann  
			lb $t4,arrayConvertedString($s3)
			addi $s3,$s3,-4
			
			move $s2, $t4
			li $v0, 1
			move $a0, $s2
			syscall
			
			j printConvertString	
																																																																															
		exitConvert:
			li $v0, 4
			la $a0, space
			syscall
			j menu

	exitCode:
		li $v0, 10
   		syscall
