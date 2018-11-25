    .data
key:        .float  0
number:     .word   19
heso1:	    .float  20.0         # He so ramdom tu -1000.0 toi 1000.0
heso2:	    .float  -10.0         # Tang he so neu ban muon ramdom lon hon. (heso1 + 2*heso2 = 0)
data:       .float  0:20
endline:    .asciiz "\n"            # Xuong dong
luachon:    .asciiz "Lua chon phuong an: "
pa1:        .asciiz "1. Nhap vao mang."
pa2:        .asciiz "2. Ramdom mot mang."
nhappt:     .asciiz "Nhap vao phan tu thu "
sai:        .asciiz "Ban chon sai!"
truoc:      .asciiz "Mang cua ban truoc khi su dung quickSort: "
sau:        .asciiz "Mang cua ban sau khi su dung quickSort: "
space:      .asciiz " "
space1:     .asciiz ": "
    .text
    .globl main
main:
    li $v0, 4		                # print("1. Nhap vao mang.\n")
    la $a0, pa1
    syscall
    li $v0, 4
    la $a0, endline
    syscall
    
    li $v0, 4		                # print("2. Ramdom mot mang\n")
    la $a0, pa2
    syscall
    li $v0, 4
    la $a0, endline
    syscall
    
    li $v0, 4		                # print("Lua chon phuong an: \n")
    la $a0, luachon
    syscall
    
    li $v0, 5		                # read integer
    syscall
    addi $t0, $zero, 1
    addi $t1, $zero, 2
    
    beq $v0, $t0, nhapmang		    # if $v0 == 1 then jump to nhapmang
    beq $v0, $t1, ramdom		    # if $vo == 2 then jump to ramdom
    
    li $v0, 4		                # print("Ban chon sai!\n")
    la $a0, sai
    syscall
    li $v0, 4
    la $a0, endline
    syscall
    j exit			                # jump to exit


# Thuc hien nhap mang
nhapmang:
    addi $t0, $zero, 0		        # i = 0
    lw $t1, number			        # load Max index cua array
    la $s0, data			        # load Array
loopnhap:
    bgt $t0, $t1, exitnhap	        # if i > index then jump to exitnhap
    li $v0, 4				        # print("Nhap vao phan tu thu %d", i)
    la $a0, nhappt
    syscall
    
    li $v0, 1
    addi $a0, $t0, 1
    syscall
    li $v0, 4
    la $a0, space1
    syscall
    li $v0, 6				        # read float to $f0
    syscall
    sll $t3, $t0, 2			        # $t3 = i*4
    add $t2, $s0, $t3		        # $t2 = data + i*4
    swc1 $f0, 0($t2)		        # data[i] = $f0
    addi $t0, $t0, 1		        # i++
    j loopnhap				        # jump to loopnhap
exitnhap:
    j sort					        # jump to sort
    
ramdom:
    addi $t0, $zero, 0		        # i = 0
    lw $t1, number			        # load max index of array := size(array) - 1
    la $s0, data			        # load data
loopRamdom:
    bgt $t0, $t1, sort		        # if i > index then jump to sort
    li $v0, 43					    # ramdom so thuc tu 0 toi 1, luu vao thanh ghi $f0
    syscall
    lwc1 $f1, heso1			    # $f1 = heso1
    lwc1 $f2, heso2			    # $f2 = heso32
    mul.s $f0, $f0, $f1			    # $f0 = $f0 * 64
    add.s $f0, $f0, $f2			    # $f0 = heso2 + heso1 * $f0{ = -Maxrand + (Maxrand + Maxrand) * rand() / RAND_MAX;}
    
    sll $t3, $t0, 2				    # $t3 = i*4
    add $t2, $s0, $t3			    # $t2 = data + i*4
    swc1 $f0, 0($t2)			    # data[i] = $f0
    addi $t0, $t0, 1			    # i++
    j loopRamdom				    # jump to loopRamdom



# Bat dau thuc hien sap xep
sort:
    la $s0, data				    # In mang truoc khi chay quick Sort
    li $v0, 4
    la $a0, truoc
    syscall
    li $v0, 4
    la $a0, endline
    syscall
    
    move $a0, $s0				    # $a0 = $s0
    addi $a1, $zero, 0			    # $a1 = 0
    lw $a2, number				    # $a2 = number
    jal printArray				    # printf(Data, 0, number) // goi ham in ra mang
    
    move $a0, $s0				    # $a0 = $s0
    addi $a1, $zero, 0			    # $a1 = 0
    lw $a2, number				    # $a2 = number
    jal quickSort				    # quickSort(data, 0, number) // goi ham quick sort
    
    li $v0, 4					    # In mang sau khi chay quick Sort
    la $a0, sau
    syscall
    li $v0, 4
    la $a0, endline
    syscall
    
    move $a0, $s0				    # $a0 = $s0
    addi $a1, $zero, 0			    # $a1 = 0
    lw $a2, number				    # $a2 = number
    jal printArray                  # printf(Data, 0, number) // goi ham in ra mang
    
    j exit                          # Nhay toi exit



#################################################
# Hàm quick sort
# void quickSort(data[], int a,int b);
#################################################
quickSort:
    # luu cac thanh ghi vao stack truoc khi goi ham
    addi $sp, $sp, -32
    swc1 $f2, 28($sp)
    swc1 $f1, 24($sp)
    sw $s0, 20($sp)
    sw $s1, 16($sp)
    sw $s2, 12($sp)
    sw $t0, 8($sp)
    sw $t1, 4($sp)
    sw $ra, 0($sp)

    move $s0, $a0					# data
    move $s1, $a1					# low
    move $s2, $a2					# high
        
                
    bgt $s1, $s2, exitquickSort		# if low > high then jump to exitquickSort
    add $t0, $s1, $s2				# $t0 = low + high
    
    addi $t1, $zero, 2				# $t1 = 2
    div $t0, $t1					# $t0/$t1
    mflo $t0						# $t0 = (low + high) / 2
    
    
    sll $t2, $t0, 2					# $t0 = t0 * 4
    add $t2, $s0, $t2				# $t2 = (data) + t0
    lwc1 $f1, 0($t2)				# key = data[(low + high)/2]
    
    move $t0, $s1					# i
    move $t1, $s2					# j
    
loopWhile:
    bgt $t0, $t1, exitWhile	 		# if (i > j) then jump to exitWhile
    
loopWhile1:
    addi $t2, $zero, 0
    sll $t2, $t0, 2
    add $t2, $s0, $t2
    lwc1 $f2, 0($t2)				# $f2 =  data[i]
    
    c.le.s $f1, $f2					# if key <= data[i] then jump to loopWhile2
    bc1t loopWhile2
    
    addi $t0, $t0, 1				# i ++;
    
    j loopWhile1
loopWhile2:
    addi $t2, $zero, 0
    sll $t2, $t1, 2
    add $t2, $s0, $t2
    lwc1 $f3, 0($t2)				# $f3 = data[j]

    c.le.s $f3, $f1					# if data[j] <= key then jump to exitWhile2
    bc1t exitWhile2
    
    addi $t1, $t1, -1				# j--;
    
    j loopWhile2
exitWhile2:
    bgt $t0, $t1, next				# if i > j then jump to next
    
    move $a0, $s0					
    move $a1, $t0
    move $a2, $t1	
    jal swap						# swap(data, i, j)	// goi ham swap vi tri i va j
    
    addi $t0, $t0, 1				# i++
    addi $t1, $t1, -1				# j--
next:
    j loopWhile
exitWhile:
    
    bge $s1, $t1, next1				# if (low >= j) then jump to next1
    
    move $a0, $s0
    move $a1, $s1
    move $a2, $t1
    jal quickSort					# quickSort(data, low, j)
    
next1:
    ble $s2, $t0, exitquickSort		# if (high <= i) then jump to exitquickSort
    
    move $a0, $s0
    move $a1, $t0
    move $a2, $s2
    jal quickSort					# quickSort(data, i, high)

exitquickSort:
    # Phuc hoi cac thanh ghi sau khi goi ham
    lw $ra, 0($sp)
    lw $t1, 4($sp)
    lw $t0, 8($sp)
    lw $s2, 12($sp)
    lw $s1, 16($sp)
    lw $s0, 20($sp)
    lwc1 $f1, 24($sp)
    lwc1 $f2, 28($sp)
    addi $sp, $sp, 32

    jr $ra


#################################################
# Hamm in ra mang data tu a toi b
# void printArray(data[], int a,int b);
#################################################
printArray:
    # Luu cac thanh ghi vao stack truoc khi goi ham
    addi $sp, $sp, -20
    sw $s0, 16($sp)
    sw $t0, 12($sp)
    sw $t1, 8($sp)
    sw $t2, 4($sp)
    sw $t3, 0($sp)

    move $s0, $a0				    # $s0 = data
    move $t0, $a1				    # $t0 = a
    addi $t1, $a2, 1			    # $t1 = b
    
loopPrint:
    bge $t0, $t1, exitPrint		    # if a >= b then jump to exitPrint
    sll $t3, $t0, 2				    # $t3 = a*4
    add $t2, $s0, $t3			    # $t2 = data + a*4
    lwc1 $f12, 0($t2)			    # $f12 = data[a]
    li $v0, 2					    # print(data[a])
    syscall
    li $v0, 4					    # print(" ")
    la $a0, space		
    syscall
    addi $t0, $t0, 1			    # a = a+1
    j loopPrint					    # jump to loopPrint
exitPrint:
    li $v0, 4					    # print("\n")
    la $a0, endline
    syscall

    # Phuc hoi cac thanh ghi sau khi goi ham
    lw $t3, 0($sp)
    lw $t2, 4($sp)
    lw $t1, 8($sp)
    lw $t0, 12($sp)
    lw $s0, 16($sp)
    addi $sp, $sp, 24

    jr $ra						



#################################################
# Ham swap hai vi tri a va b trong mang data
# void swap(data[], int a,int b); 
#################################################
swap:
    # Luu cac thanh ghi vao stack truoc khi goi ham
    addi $sp, $sp, -20
    swc1 $f2, 16($sp)
    swc1 $f1, 12($sp)
    sw $t0, 8($sp)
    sw $t1, 4($sp)
    sw $t2, 0($sp)

    move $t0, $a0				    # $t0 = data
    move $t1, $a1   			    # $t1 = a
    move $t2, $a2				    # $t2 = b
    
    sll $t1, $t1, 2				    # $t1 = t1 * 4
    add $t1, $t0, $t1			    # $t1 = data + t1 * 4
    lwc1 $f1, 0($t1)			    # $f1 = data[a]
    
    sll $t2, $t2, 2				    # $t2 = t2 * 4
    add $t2, $t0, $t2			    # $t2 = data + t2 * 4
    lwc1 $f2, 0($t2)			    # $f2 = data[b]
    
    swc1 $f2, 0($t1)			    # data[a] = $f2
    swc1 $f1, 0($t2)			    # data[b] = $f1
    
    # Phuc hoi cac thanh ghi sau khi goi ham
    lw $t2, 0($sp)
    lw $t1, 4($sp)
    lw $t0, 8($sp)
    lwc1 $f1, 12($sp)
    lwc1 $f2, 16($sp)
    addi $sp, $sp, 20
    jr $ra
exit:
    li $v0, 10
    syscall
