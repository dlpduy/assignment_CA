# Chuong trinh: Chia 2 so nguyen 32 bit
#-----------------------------------
# Data segment
	.data
# Cac dinh nghia bien
fdescr: .word 0 			# Dung de luu file descriptor sau khi doc 
quotient: .word 0		# Dung de luu thuong cua phep chia
truonghop: .word 0 		# Dung de luu truong hop khi thuc hien chia
			  			# 0 tương ứng với so bi chia va so chia deu duong (khong xu li)
			  			# 1 tuong ung voi so bi chia duong va so chia am 
						# 2 tuong ung voi so bi chia am va so chia duong 
						# 3 tuong ung voi so bi chia va so chia deu am
remainder: .space 4 	# Dung de luu so bi chia cung nhu sau khi chia xong la luu so du
divisor: .space 4 	# Dung de luu so chia
tenfile: .asciiz "INT2.BIN"		# Bien luu ten file
xuongdong: .asciiz "\n"   			# Xuong dong in ra de quan sat
loidiv: .asciiz "So chia khong hop le" # Thong bao phep chia khong hop lai (=0)
# Cac cau nhac nhap/xuat du lieu
	xuat_sobichia: .asciiz "So bi chia la: " 	# Thong bao so bi chia
	xuat_sochia: .asciiz "So chia la: "		# Thong bao so chia
	xuat_thuong: .asciiz "Thuong la: "		# Thong bao thuong
	xuat_sodu: .asciiz "So du la:  "			# Thong bao so du
#-----------------------------------
# Code segment
	.text
#-----------------------------------
# Chuong trinh chinh
#-----------------------------------
main:	
# Mo file du lieu
	la	$a0,tenfile
	addi	$a1,$zero,0	# set flag a1=0 de mo file ma doc file
	addi	$v0,$zero,13
	syscall
	sw $v0,fdescr 	# luu file descriptor
# Doc file du lieu
	# Doc 4 bytes dau tien va luu vao lable remainder (chua so bi chia)
  	lw	$a0,fdescr
  	la	$a1,remainder
  	addi	$a2,$zero,4
  	addi	$v0,$zero,14
  	syscall
  	# Doc 4 bytes tiep theo va luu vao nhan divisor (chua so chia)
  	la	$a1,divisor
  	addi	$a2,$zero,4
  	addi	$v0,$zero,14
  	syscall
# Dong file du lieu
	lw	$a0,fdescr
	addi	$v0,$zero,16
	syscall
# Test thu phep chia bang cach gan so
# Xuat thong bao so chia va so bi chia
	addi $v0,$0, 4
   	la $a0, xuat_sobichia
   	syscall
   	addi $v0,$0, 1
   	lw $a0, remainder
   	syscall
   	addi $v0,$0, 4
   	la $a0, xuongdong
   	syscall
   	addi $v0,$0, 4
   	la $a0, xuat_sochia
   	syscall
   	addi $v0,$0, 1
   	lw $a0, divisor
   	syscall
   	addi $v0,$0, 4
   	la $a0, xuongdong
   	syscall
# Lay gia tri so bi chia va so chia luu vao thanh ghi $t1 va $t2
 	lw $t1,remainder
	lw $t2, divisor
	beqz $t2, loiphepchia # Neu so chia bang 0 thi nhay den nhan loiphepchia va xuat ra thong bao
# Xu li so co dau
	# Ham xet dau so bi chia, so chia va tra ve gia tri cua truonghop tuong ung nhu mo ta
	lw $a0, remainder
	lw $a1, divisor
	jal xetdau
	sw $v0, truonghop
	# Ham xu li dau dua so bi chia va so chia ve 2 so duong truoc khi chia
	lw $a0, truonghop
	move $a1,$t1
	move $a2,$t2	
	jal xulitruonghop
	sw $v0,remainder
	sw $v1, divisor
# Thuc hien dich trai thanh ghi va luu gia tri cua so chia 
	lw $t1,remainder
	lw $t2, divisor
shiftbit:
	bge $t2, 1073741824,out_shiftbit  # hoan thanh viec dich biet cua $t2 khi $t2>=0100 0000 0000 0000 0000 0000 0000 0000
	sll $t2,$t2,1 
	j shiftbit # quay ve vong lap 
out_shiftbit:
# Thuc hien phep chia theo giai thuat textbook
	lw $t5, divisor # Luu gia tri cua so chia vao thanh ghi $t5
	addi $t3,$0, 0 # Dung de luu gia tri thuong cua phep chia quotient
	addi $t4,$0, 0  # Luu bien dem dung de kiem tra so lan lap lai neu qua 33 thi thoat khoi vong lap
division:
	addi $t4,$t4,1			# Cong bien dem them 1
	beq $t4,33,out_division 	# Neu bien dem so lan = 33 thi thoat khoi vong lap
	blt $t2, $t5, out_division 	# Neu thanh ghi $t5 luu gia tri cua divisor truoc khi dich lon hon thanh ghi $t2 luu gia tri divisor sau khi dich
						        # thi thoat khoi vong lap
	sub $t1,$t1,$t2
	bgez $t1, statement1		#Neu thanh ghi $t1>=0 thi re nhanh den stament1 nguoc lai thi nhay den stament2
	j statement2
statement1: # Thuc hien viec dich trai thanh ghi chua gia tri quotient va cong them 1 sau do dich phai thanh ghi $t2
	sll $t3,$t3,1		#Dich trai thanh ghi $t3 mot bit
	addi $t3,$t3,1		#Cong thanh $t3 cho 1
	srl $t2,$t2,1		#Dich phai thanh ghi $t2
	j division			# Tro ve vong lap
statement2:	# Thuc hien khoi phuc gia tri $t1 va dich trai thanh ghi chua gia tri quotient nhung khong cong them 1 sau do dich phai thanh ghi $t2
	add $t1,$t1,$t2		# Khoi phuc lai gia tri $t1
	sll $t3,$t3,1		# Dich trai thanh ghi $t3 1 bit
	srl $t2,$t2,1		# Dich phai thanh ghi $t2 1 bit
	j division			# Tro ve vong lap
out_division: 
	sw $t3, quotient		# Luu lai gia tri $t3 vao nhan quotient
 	sw $t1, remainder	# Luu lai gia tri $t1 vao nhan remainder
# Khoi phuc dau cua phep chia - ham thu tuc khong chua gia tri tra ve
	lw $a0, truonghop	#Load gia tri cua truonghop cho tham so $a0
	lw $a1, divisor		#Load gia tri cua divisor cho tham so $a1
	lw $a2, remainder	#Load gia tri cua remainder cho tham so $a2
	lw $a3, quotient	#Load gia tri cua quotient cho tham so $a3
	jal khoiphucdau		#Thuc thi ham khoi phuc dau
# In ra man hinh kiem thu chuong trinh
	addi $v0,$0, 4
   	la $a0, xuat_thuong
   	syscall
   	addi $v0,$0, 1
   	lw $a0, quotient
   	syscall
   	addi $v0,$0, 4
   	la $a0, xuongdong
   	syscall
   	addi $v0,$0, 4
   	la $a0, xuat_sodu
   	syscall
   	addi $v0,$0, 1
   	lw $a0, remainder
   	syscall
   	addi $v0,$0, 4
   	la $a0, xuongdong
   	syscall
#Ket thuc chuong trinh
ketthuc:
	addi $v0,$zero,10
	syscall
#Thong bao loi phep chia khi so chia la 0
loiphepchia:
	addi $v0,$0, 4
	la $a0, loidiv
	syscall
	j ketthuc
	

# Ham xet dau
	# Tham so dau vao: $a0 chua gia tri cua so bi chia, $a1 chua gia tri cua so chia
	# Gia tri tra ve: 
		#$v0 chua gia tri 0 neu nhu $a0, $a1 deu duong; 
		#$v0 chua gia tri 1 neu nhu $a0 duong, $a1 am;
		#$v0 chua gia tri 2 neu nhu $a0 am , $a1 duong;
		#$v0 chua gia tri 3 neu nhu $a0, $a1 deu am; 
xetdau:
	bgt $a0,0, sobichiaduong
	j sobichiaam
	sobichiaduong:
		bgt $a1,0,return0
		j return1
	sobichiaam:
		bgt $a1,0,return2
		j return3
	return0:
		addi $v0,$0,0
		jr $ra
	return1:
		addi $v0,$0,1
		jr $ra
	return2:
		addi $v0,$0,2
		jr $ra
	return3:
		addi $v0,$0,3
		jr $ra
# Ham xu li dau dua ca hai so bi chia va so chia ve thanh hai so duong de thuc hien phep chia
	#Tham so dau vao: $a0 chua gia tri cua truonghop, $a1 chua gia tri cua so bi chia, $a2 chua gia tri cua so chia
	# Khong co gia tri tra ve
xulitruonghop:
	beq $a0, 1, truonghop1 
	beq $a0, 2, truonghop2
	beq $a0, 3, truonghop3
	j return
	truonghop1:
		not $a2,$a2
		addi $a2,$a2, 1
		j return
	truonghop2:
		not $a1,$a1
		addi $a1,$a1,1
		j return
	truonghop3:
		not $a1,$a1
		addi $a1,$a1,1
		not $a2,$a2
		addi $a2,$a2, 1
		j return
	return:
		move $v0, $a1
		move $v1, $a2
		jr $ra
# Ham khoi phuc va xu li dau de co phep chia hop li
	# Tham so dau vao:
		#a0 chua gia tri truong hop
		#a1 chua gia tri divisor
		#a2 chua gia tri remainder
		#a3 chua gia tri quotient
	# Khong co gia tri tra ve
khoiphucdau:
	beq $a0, 1, procedure1
	beq $a0, 2, procedure2
	beq $a0, 3, procedure3
	j finish_procedure
	procedure1:
		not $a1,$a1
		addi $a1,$a1,1
		not $a3,$a3
		addi $a3,$a3,1
		j finish_procedure
	procedure2:
		not $a2,$a2
		addi $a2,$a2,1
		not $a3,$a3
		addi $a3,$a3,1
		j finish_procedure
	procedure3:
		not $a1,$a1
		addi $a1,$a1,1
		not $a2,$a2
		addi $a2,$a2,1
		j finish_procedure
	finish_procedure:
		sw $a1, divisor
		sw $a2, remainder
		sw $a3, quotient
		jr $ra
#-----------------------------------
