#Chuong trinh: xac dinh so PI bang phuong phap Monte Carlo
#Data segment
	.data
#Cac dinh nghia bien
	N: .word 50000 # So lan thuc hien vong lap
	SEED: .word 40 # Ma syscall cho chuc nang set seed
	RAND: .word 43 # Ma syscall cho chuc nang phat so ngau nhien
	TIME: .word 30 # Ma syscall cho chuc nang lay thoi gian hien tai
	float_x: .float 0.0 # Bien luu gia tri so ngau nhien cua hoanh do x (0<x<1)
	float_y: .float 0.0 # Bien luu gia tri so ngau nhien cua tung do y (0<y<1)
	int_count: .word 0 # Bien dem so lan lap
	xuongdong: .asciiz "\n"
	khoangcach: .asciiz " "
	count_circle: .word 0 #Bien luu so diem nam trong duong tron
	PI: .float 0.0 # Bien luu gia tri cua PI
	hoanhdotam: .float 0.5 # Bien luu hoanh do tam duong tron
	tungdotam: .float 0.5 # Bien luu tung do tam duong tron
	bankinh: .float 0.5 # Bien luu ban kinh tam duong tron
	mau: .float 4.0 # Bien luu so 4 de su dung cho viec nhan so thuc 
	filename: .asciiz "PI.txt" #Bien luu ten file
	string_1: .asciiz "So diem nam trong hinh tron:" # Xuat thong bao 
	string_2: .asciiz "So PI tinh duoc:" # Xuat thong bao
	xuli_PI: .float 0.0 #Bien dung de xu li PI 
	int_PI: .word 0 # Bien de luu gia tri nguyen cua PI sau khi xu li
	so1000000: .float 1000000.0 # Bien dung de nhan so thuc phuc vu cho viec xu li PI
#Code segment
	.text

main:	
#Xu ly
	# Lay thoi gian hien tai
  	lw $v0, TIME # Dat ma syscall cho chuc nang lay thoi gian hien tai vao thanh ghi $v0
  	syscall # Goi ham he thong
 	move $a0, $v0 # Luu thoi gian hien tai vao thanh ghi $a0

  	# Dung thoi gian hien tai lam gia tri hat giong
  	lw $v0, SEED # Dat ma syscall cho chuc nang set seed vao thanh ghi $v0
 	syscall # Goi ham he thong
	lw $t2 N # Luu gia tri N vao thanh ghi $t2
  # Lap lai Random N lan theo yeu cau de bai
  loop:
    # Phat ra mot so ngau nhien kieu float cho x
    lw $v0, RAND # Dat ma syscall cho chuc nang phat so ngau nhien vao thanh ghi $v0
    syscall # Goi ham he thong
    move $a0, $v0 # Luu so ngau nhien kieu float vao thanh ghi $a0
    swc1 $f0, float_x # Luu so ngau nhien x (0<x<1) vao bien x
    
    # Phat ra mot so ngau nhien kieu float cho y
    lw $v0, RAND # Dat ma syscall cho chuc nang phat so ngau nhien vao thanh ghi $v0
    syscall # Goi ham he thong
    move $a0, $v0 # Luu so ngau nhien kieu float vao thanh ghi $a0
    swc1 $f0, float_y # Luu so ngau nhien y (0<x<1) vao bien y
    
    # In ra so ngau nhien x
    li $v0, 2 # Dat ma syscall cho chuc nang in so kieu float vao thanh ghi $v0
    lwc1 $f12, float_x # Dat so ngau nhien x (0<x<1) vao thanh ghi $f12
    syscall # Goi ham he thong
    # In ra khoang cach cho de quan sat
    li $v0 4
    la $a0 khoangcach
    syscall
    # In ra so ngau nhien y
    li $v0, 2 # Dat ma syscall cho chuc nang in so kieu float vao thanh ghi $v0
    lwc1 $f12, float_y # Dat so ngau nhien y (0<y<1) vao thanh ghi $f12
    syscall # Goi ham he thong
    #In dau xuong dong cho de quan sat
    li $v0 4
    la $a0 xuongdong
    syscall 
    # Tang bien dem count len 1
    lw $t1, int_count # Doc gia tri cua bien count vao thanh ghi $t1
    addi $t1, $t1, 1 # Tang gia tri cua thanh ghi $t1 len 1
    sw $t1, int_count # Luu gia tri cua thanh ghi $t1 vao bien count
    
    #Goi ham kiem tra diem nam trong duong tron
    	la $a2, float_x # dung thanh ghi $a2 truyen tham so cho float_x
    	la $a3, float_y # dung thanh ghi $a3  truyen tham so cho float_y
    	jal checkincircle # Goi ham
    	lw $t0, count_circle # lay gia tri cua bien count_circle luu vao $t0
    	add $t0,$t0,$v0 # cong gia tri cua $t0 voi gia tri tra ve cua ham la thanh ghi $v0
    	sw $t0, count_circle # luu gia tri cua bien count_circle la gia tri cua thanh ghi $t0
    
    # Kiem tra dieu kien lap
    bne $t1, $t2, loop # Neu gia tri cua thanh ghi $t1 khac N, thi nhay ve nhan loop
    #Tinh so PI bang cach thuc hien phep chia so thuc giua count_circle va N
    lw $t1, count_circle # Lay gia tri count_circle
	mtc1 $t1, $f1 # Chuyen so nguyen tu thanh ghi $t1 sang so thuc va luu vao thanh ghi $f1
	lw $t2, N # Lay gia tri N
	mtc1 $t2,$f2 # Chuyen so nguyen tu  thanh ghi $t2 sang so thuc va luu vao thanh ghi $f2
	div.s $f1,$f1, $f2 # Thuc hien phep chia so thuc
	lwc1 $f2, mau # Lay gia tri cua 4.0 de nhan cho thuong cua phep chia tren
	mul.s $f1,$f1,$f2 # Thuc hien nhan 4.0 thi ket qua cua $f1 chinh la PI
	swc1 $f1,PI # Luu gia tri cua $f1 vao nhan PI
	# Xuat so diem nam trong duong tron ra man hinh
	li $v0 4
	la $a0 string_1
	syscall
   	li $v0 1
   	lw $a0 count_circle
   	syscall
   	#Xuong dong tien cho viec quan sat
    	li $v0 4
    	la $a0 xuongdong
    	syscall 
	# Xuat so PI ra man hinh
	li $v0 4
	la $a0 string_2
	syscall 
	li $v0, 2 # Dat ma syscall cho chuc nang in so kieu float vao thanh ghi $v0
   	lwc1 $f12, PI# Dat PI (0<x<1) vao thanh ghi $f12
   	syscall # Goi ham he thong
   	
    	
   	
  # Chuyen gia tri cua bien count_circle thanh dang chuoi asciiz de ghi vao file bang viec them tung ki tu vao theo dang ASCII
   	#Cap phat bo nho cho $s0
   	li $v0, 9
	li $a0, 3   
	syscall
	move $s0, $v0
	
	addi $s0, $s0, 6   # Cap phat do dai chuoi buffer.
	                         # Do gia tri cua N la 50000 nen ta co the yen tam rang gia tri cua count_circle khong vuot qua 5 chu so.
	lw $t0, count_circle # Lay gia tri cua count_circle de xu li 
	#Them dau \n de xuong dong
	li $t3, 10     
	sb $t3, 0($s0)
	addi $s0, $s0, -1
	# Bat dau chuyen doi bang viec su dung vong lap cho den khi gia tri $t0 la 0
	loopwrite:
 		li $t1,10
 		# Thuc hien chia 10 de lay phan du va luu phan du 
 		div $t2, $t0,$t1 
 		mul $t2,$t2,$t1
 		sub $t2,$t0,$t2
 		addi $t2,$t2,48 # Cong phan du cho 48 de dua ve ASCII
 		sb $t2, 0($s0) # Luu vao thanh ghi $s0 
 		addi $s0, $s0, -1
 		div $t0,$t0,$t1 # Chia lay phan nguyen
 		bne $t0, 0, loopwrite
 		
 #Xu li so PI de in vao file
 	#Nhan 100000 vao so PI va dua ve so nguyen
 	lwc1 $f1, PI
 	lwc1 $f2, so1000000
 	mul.s $f1,$f1,$f2
 	swc1 $f1,xuli_PI
 	#Doi ve so nguyen
 	la $t1, xuli_PI
	l.s $f12, ($t1)             #f12 = xuli_PI 
	cvt.w.s $f0, $f12           #f0 = (int) xuli_PI 
	mfc1 $t1, $f0             # luu gia tri nguyen cua PI vao $t1
	sw $t1,int_PI            # luu gia tri cua $t1 vao int_PI
	# Chuyen gia tri cua bien int_PI thanh dang chuoi asciiz de ghi vao file bang viec them tung ki tu vao theo dang ASCII
	#Cap phat bo nho cho $a1
	li $v0, 9
	li $a0, 3   
	syscall
	move $s1, $v0
	addi $s1, $s1, 11    # Cap phat so luong ki tu trong chuoi
	lw $t0, int_PI 
	li $t5,6 # Vi ta da nhan gia tri PI cho 100000 roi dua ve so nguyen nen ta se ghi them dau "." vao file khi
	          # gia tri $t5 la 0
	# Bat dau chuyen doi gia tri int_PI va bao gom dau "." vao vi tri phu hop
	loop_PI:
 		li $t1,10
 		#Chia lay du cho 10 va luu phan du
 		div $t2, $t0,$t1
 		mul $t2,$t2,$t1
 		sub $t2,$t0,$t2
 		addi $t2,$t2,48 #Cong so du cho 48 de dua ve ASCII
 		sb $t2, 0($s1) # Luu ki tu vao thanh ghi $s1
 		addi $s1, $s1, -1
 		div $t0,$t0,$t1 # Chia lay phan nguyen
 		addi $t5,$t5,-1
 		beq $t5,0,addpoint # Kiem tra xem neu $t5 la 0 thi tien hanh ghi dau "." vao file
 		bne $t0, 0, loop_PI #Kiem tra xem neu $t0 khac 0 thi thuc hien lai vong lap loop_PI
 		j out_PI # Thoat ra khoi vong lap
	addpoint:
		li $t2,46 # Luu $t2 la gia tri cua "." trong ma ASCII 
 		sb $t2, 0($s1) # Luu vao thanh ghi $s1
 		addi $s1, $s1, -1
 		j loop_PI # Tro ve vong lap 
	out_PI:
 	
#Ghi vao file PI.txt
	#Mo file va dat quyen ghi vao file
	li $v0, 13 # Dat ma syscall cho chuc nang mo file vao thanh ghi $v0
	la $a0, filename  # Dat dia chi cua ten file vao thanh ghi $a0
	li $a1, 1 # Dat quyen truy cap file la ghi (write) vao thanh ghi $a1
	li $a2, 0 # Dat che do tao file la tao moi (create) vao thanh ghi $a2
	syscall
	move $s6, $v0 # Luu gia tri tra ve la mo ta file (file descriptor) vao thanh ghi $s6
	
	# Ghi thong bao 1 vao file
  	li $v0, 15 # Dat ma syscall cho chuc nang ghi chuoi vao thanh ghi $v0
  	move $a0, $s6 # Dat mo ta file vao thanh ghi $a0
 	la $a1, string_1 # Dat dia chi cua chuoi 1 vao thanh ghi $a1
 	li $a2, 28 # Dat do dai cua chuoi 1 vao thanh ghi $a2
 	syscall # Goi ham he thong
 	
 	#Ghi gia tri cua bien dem so diem trong duong tron vao file
 		#Tinh do dai cua so N de tinh duoc do dai chuoi cua count phu hop cho viec ghi vao file
 		lw $t0 N
 		li $t1,1
 		while:
 			div $t0,$t0, 10
 			addi $t1,$t1,1
 			bne $t0,0,while
 	li $v0, 15 # Dat ma syscall cho chuc nang ghi chuoi vao thanh ghi $v0
  	move $a0, $s6 # Dat mo ta file vao thanh ghi $a0
 	move $a1, $s0 # Dat dia chi cua chuoi count_circle vao thanh ghi $a1
 	move $a2, $t1 # Dat do dai cua chuoi count_circle vao thanh ghi $a2
 	syscall # Goi ham he thong
 	# Xuong dong trong file bang cach khi ki tu "\n" vao file
 	li $v0, 15 # Dat ma syscall cho chuc nang ghi chuoi vao thanh ghi $v0
  	move $a0, $s6 # Dat mo ta file vao thanh ghi $a0
 	la $a1, xuongdong # Dat dia chi cua xuongdong vao thanh ghi $a1
 	li $a2, 1 # Dat do dai cua xuongdong vao thanh ghi $a2
 	syscall # Goi ham he thong
 	
 	#Ghi thong bao 2 vao file
 	li $v0, 15 # Dat ma syscall cho chuc nang ghi chuoi vao thanh ghi $v0
  	move $a0, $s6 # Dat mo ta file vao thanh ghi $a0
 	la $a1, string_2 # Dat dia chi cua chuoi string_2 vao thanh ghi $a1
 	li $a2, 16 # Dat do dai cua chuoi string_2 vao thanh ghi $a2
 	syscall # Goi ham he thong
 	#Ghi gia tri cua PI vao file theo dang so thuc
 	li $v0, 15 # Dat ma syscall cho chuc nang ghi chuoi vao thanh ghi $v0
  	move $a0, $s6 # Dat mo ta file vao thanh ghi $a0
 	move $a1, $s1 # Dat dia chi cua chuoi PI vao thanh ghi $a1
 	li $a2, 9 # Dat do dai cua chuoi PI vao thanh ghi $a2
 	syscall # Goi ham he thong
 	# Dong file 
	li $v0, 16 # Dat ma syscall cho chuc nang dong file vao thanh ghi $v0
  	move $a0, $s0 # Dat mo ta file vao thanh ghi $a0
  	syscall # Goi ham he thong
  
#Ket thuc chuong trinh (syscall)
	addiu	$v0,$zero,10
	syscall


#Ham kiem tra diem co nam trong duong tron khong, tra ve 1 neu co va nguoc lai thi 0
checkincircle:
    lwc1 $f1, ($a2) #lay gia tri x 
    lwc1 $f2 hoanhdotam  #lay gia tri hoanh do cua tam duong tron
    sub.s $f1, $f1, $f2 # thuc hien tinh x-I(x)
    lwc1 $f2, ($a3) #lay gia tri y
    lwc1 $f3 tungdotam
    sub.s $f2, $f2, $f3 # thuc hien tinh y-I(y)
    mul.s $f1 $f1 $f1 # thuc hien tinh [x-x(I)]*[x-x(I)] roi luu vao thanh ghi $f1
    mul.s $f2 $f2 $f2 # thuc hien tinh [y-y(I)]*[y-y(I)] roi luu vao thanh ghi $f2
    add.s $f1 $f1 $f2 # tinh [x-x(I)]*[x-x(I)]+[y-y(I)]*[y-y(I)] roi luu vao thanh ghi $f1
    lwc1 $f2 bankinh # lay gia tri ban kinh R
    mul.s $f2,$f2,$f2 # Tinh R^2
    c.le.s $f1, $f2 # Kiem tra [x-x(I)]^2+[y-y(I)]^2 <= R^2, neu dung thi co CC co gia tri la 1, nguoc lai la 0
    bc1t return1 # nhay den nhan return1 neu nhan CC la 1
    j return0 # neu nhan CC la 0 nhay den return 0
     return1:
    	li $v0 1 # tra ve gia tri la 1
    	jr $ra
    return0:
    	li $v0 0 # tra ve gia tri la  0
    	jr $ra

