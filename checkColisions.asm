#a4 = hitmap
#fa0 = x obstaculo
#fa1 = y obstaculo
#fa2 = raio obstaculo
#fs0 = pos x
#fs1 = pos y
#fs2 = vel x
#fs3 = vel y
#fs4 = raio bola
#fs5 = perda de energia
#fa3 = sen da perpendicular
#fa4 = cos da perpendicular 
#macro de li pra float
.macro fli (%reg,%num)
addi sp,sp,-4
sw t0,(sp)
li t0, %num
fcvt.s.w %reg,t0
lw t0,(sp)
addi sp,sp,4
.end_macro



.macro pitagoras (%reg, %cat1, %cat2)
	addi sp,sp,-8
	fsw ft0,(sp)
	fsw ft1,(sp)
	fli (ft0,%cat1)
	fli (ft1,%cat2)
	fmul.s ft0,ft0,ft0
	fmul.s ft1,ft1,ft1
	fadd.s ft0,ft0,ft1
	fsqrt.s %reg,ft0
	flw ft0,(sp)
	flw ft1,(sp)
	addi sp,sp,8
.end_macro
.macro sen (%reg,%oposto,%hip)
	addi sp,sp,-4
	fsw ft0,(sp)
	fli(ft0,%oposto)
	fdiv.s %reg,ft0,%hip
	flw ft0,(sp)
	addi sp,sp,4
.end_macro
.macro cos (%reg,%adj,%hip)
	addi sp,sp,-4
	fsw ft0,(sp)
	fli(ft0,%adj)
	fdiv.s %reg,ft0,%hip
	flw ft0,(sp)
	addi sp,sp,4
.end_macro

checkColision:

#colisões laterais
li t2,0 #flag de colisão das bordas
#proxima posição x

fadd.s ft0,fs2,fs0#posição futura x
fadd.s ft1,fs3,fs1
fcvt.w.s t0,ft0	
fcvt.w.s t1,ft1

#sub t0,t0,t3	#subtrai raio para checar a borda da esquerda
li t3,320
mul t3,t3,t1	#posição do y na matriz
add t0,t0,t3 	#posição x+320y(ponto no vetor)
add t0,t0,a4	#adiciona o endereço do vetor
lbu t0,(t0)
li t1,7
bne t0,t1,okFlipper
	fli (ft0,0)
	fli (ft1,-0)
	fadd.s fs2,ft0,fs2
	fadd.s fs3,ft1,fs3
	ret
okFlipper:







#checa se precisa olhar as diagonais dos flippers
fcvt.w.s t0, fs3
blez t0,okFD




#checa se precisa checar o flipper direito
fadd.s ft0,fs2,fs0
fcvt.w.s t0, ft0
li t1,161
bge t0,t1,okFE

#diagonal flipper esquerda
#y = 17*x/57 -2720/57 + 200
fli (ft0,17)
fli (ft1,57)
fli (ft2,2720)
fli (ft3,200)

fdiv.s ft0,ft0,ft1#17/57
fdiv.s ft1,ft2,ft1#2720/57
fneg.s ft1,ft1	  #-2720/57
fadd.s ft1,ft1,ft3#-2720/57+200
fadd.s ft3,fs0,fs2#proxima posicao x
fmul.s ft0,ft0,ft3#17/57*x
fadd.s ft0,ft0,ft1#resuldado da equação(y na diagonal)
fadd.s ft3,fs1,fs3
fsub.s ft3,ft3,ft0#hip triangulo pequeno
fabs.s ft3,ft3
pitagoras(ft4,49,16)#ft4 = hip
sen(ft5,49,ft4)	#ft5 = sen
cos(ft6,16,ft4)	#ft6 = cos
fmul.s ft3,ft3,ft6 #ft3 = h
fcvt.w.s t0,ft3 #t0 = h
fcvt.w.s t1,fs4#t1 = raio

blt t1,t0,okFE #se raio < H não teve colisão(pula se teve colisao)
	j colidiuDiagonal
okFE:

#checa se precisa checar a diagonal do flipper direito(se o x futuro da bola estiver em cima do flipper
fadd.s ft0,fs2,fs0
fcvt.w.s t0, ft0
li t1,185
ble t0,t1,okFD
#diagonal flipper direita
#y = -16*x/49 + 3760/49 + 184
fli (ft0,16)
fli (ft1,49)
fli (ft2,3760)
fli (ft3,180)

fdiv.s ft4,ft4,ft1#16/49
fneg.s ft4,ft4	  #-16/49
fdiv.s ft1,ft2,ft1#3760/49
fadd.s ft1,ft1,ft3#3760/49+200
fadd.s ft3,fs0,fs2#proxima posicao
fmul.s ft0,ft4,ft3#-16/49*x
fadd.s ft0,ft0,ft1#resuldado da equação(y na diagonal)
fadd.s ft3,fs1,fs3
fsub.s ft3,ft3,ft0#hip triangulo pequeno
fabs.s ft3,ft3
pitagoras(ft4,49,16)#ft4 = hip
sen(ft5,49,ft4)	#ft5 = sen
cos(ft6,16,ft4)	#ft6 = cos
fmul.s ft3,ft3,ft6 #ft3 = h
fcvt.w.s t0,ft3 #t0 = h
fcvt.w.s t1,fs4#t1 = raio

blt t1,t0,okFD #se raio < H não teve colisão(pula se teve colisao)
j colisaoLateral

okFD:
#checa se precisa checar as diagonais superiores
fcvt.w.s t0, fs3
bgez t0,colisaoLateral
#diagonal superior direita
#y = x-231
fli (ft0,-231)
fadd.s ft1,fs0,fs2
fadd.s ft0,ft0,ft1
fcvt.w.s t0,ft0
fadd.s ft1,fs1,fs3#proximo y
fcvt.w.s t1,ft1

bne t0,t1,colisaoLateral
j colisaoLateral
#diagonal superior direita
#y = -x+172
fli (ft0,172)
fadd.s ft1,fs0,fs2#x futuro
fneg.s ft1,ft1	  #-x
fadd.s ft0,ft0,ft1#-x+172
fcvt.w.s t0,ft0
fadd.s ft1,fs1,fs3#proximo y
fcvt.w.s t1,ft1

bne t0,t1,colisaoLateral

j colisaoLateral

colidiuDiagonal:
	addi sp,sp,-8
	fsw fa3,(sp)
	fsw fa4,4(sp)
	#alpha = 180-theta
	#|-cos(alpha) -sen(alpha)| 		 	 |x|
	#|sen(alpha) -cos(alpha) |			 |y|
	fmul.s ft0,fs2,ft6	#x*cos
	fneg.s ft0,ft0		#-xcos
	fmul.s ft1,fs3,ft5	#y*sen
	fneg.s ft1,ft1		#-ysen
	fadd.s fa3,ft1,ft0 	#novo x(-xcos-ysen)
	
	fmul.s ft0,fs2,ft5	#xsen
	fmul.s ft1,ft6,fs3	#ycos
	fneg.s ft1,ft1		#-ycos
	fadd.s fa4,ft1,ft0	#novo y(xsen-ycos)
	
	fneg.s fa4,fa4
	
	#|-cos(alpha) sen(alpha)| 		 	 |x|
	#|-sen(alpha) -cos(alpha) |			 |y|
	
	fmul.s ft0,fa3,ft6	#x*-cos
	fneg.s ft0,ft0
	fmul.s ft1,fa4,ft5	#y*sen
	fadd.s fs2,ft1,ft0 	#novo x
	
	fmul.s ft0,fa3,ft5	#x*-sen
	fneg.s ft1,ft1
	fmul.s ft1,ft6,fa4	#y*-cos
	fneg.s ft1,ft1
	fadd.s fs3,ft1,ft0#novo y
	
	
	flw fa3,(sp)
	flw fa4,4(sp)
	addi sp,sp,8
	
	fmul.s fs2,fs2,fs5
	fmul.s fs3,fs3,fs5
	
	ret
colisaoLateral:
#colisões laterais
li t2,0 #flag de colisão das bordas
#proxima posição x

fadd.s ft0,fs2,fs0#posição futura x
fcvt.w.s t0,ft0	
fcvt.w.s t3,fs4
fcvt.w.s t4,fs1
#sub t0,t0,t3	#subtrai raio para checar a borda da esquerda
li t3,320
mul t3,t3,t4	#posição do y na matriz
add t0,t0,t3 	#posição x+320y(ponto no vetor)
add t0,t0,a4	#adiciona o endereço do vetor
lbu t0,(t0)
li t1,255
beq t0,t1,okEsquerda
	li t2,1
	
okEsquerda:

fadd.s ft0,fs2,fs0#posição futura x
fcvt.w.s t0,ft0	
fcvt.w.s t3,fs4
fcvt.w.s t4,fs1
add t0,t0,t3	#subtrai raio para checar a borda da direita
li t3,320
mul t3,t3,t4	#posição do y na matriz
add t0,t0,t3 	#posição x+320y(ponto no vetor)
add t0,t0,a4	#adiciona o endereço do vetor
lbu t0,(t0)
li t1,255
beq t0,t1,okDireita
	li t2,1
okDireita:

#proxima posição y

fadd.s ft0,fs3,fs1#posição futura y
fcvt.w.s t0,ft0	
fcvt.w.s t3,fs4
fcvt.w.s t4,fs0	#posicao x
#sub t0,t0,t3	#subtrai raio para checar a borda de cima
li t3,320
mul t0,t0,t3	#posição do y na matriz
add t0,t0,t4 	#posição x+320y(ponto no vetor)
add t0,t0,a4	#adiciona o endereço do vetor
lbu t0,(t0)
li t1,255
beq t0,t1,okCima
	addi t2,t2,2
	j perdeuEnergia
okCima:


#fadd.s ft0,fs3,fs1#posição futura y
#fcvt.w.s t0,ft0	
#fcvt.w.s t3,fs4
#fcvt.w.s t4,fs0	#posicao x
#add t0,t0,t3	#subtrai raio para checar a borda de cima
#li t3,320
#mul t0,t0,t3	#posição do y na matriz
#add t0,t0,t4 	#posição x+320y(ponto no vetor)
#add t0,t0,a4	#adiciona o endereço do vetor
#lbu t0,(t0)
#li t1,255
#beq t0,t1,okBaixo	
#	addi t2,t2,2

#okBaixo:
	beqz t2,naoSaiu
	perdeuEnergia:
		
		li t3,1
		beq t2,t3,x
		li t3,2
		beq t2,t3,y
		li t3,3
		beq t2,t3,xy
		
		x:	
			fneg.s fs2,fs2
			fmul.s fs2,fs2,fs5
			ret
		y:
			fneg.s fs3,fs3
			fmul.s fs3,fs3,fs5
			ret
		xy:	
			fneg.s fs3,fs3
			fneg.s fs2,fs2
			fmul.s fs2,fs2,fs5
			fmul.s fs3,fs3,fs5
			ret
naoSaiu: 
	
	addi sp,sp,-8
	fsw fs0,0(sp)
	fsw fs1,4(sp)
	
	fadd.s fs0,fs0,fs2
	fadd.s fs1,fs1,fs3
	
	fsub.s ft0,fa0,fs0	# cateto x
	fsub.s ft1,fa1,fs1	# cateto y
	
	fmul.s ft0,ft0,ft0	#cateto x ** 2
	fmul.s ft1,ft1,ft1 	#cateto y ** 2
	
	fadd.s ft0,ft1,ft0 	#soma dos catetos
	
	fsqrt.s ft2,ft0		#raiz da soma dos catetos(hipotenusa)
	
	fadd.s ft1,fs4,fa2	
	
	fle.s t0 , ft2,ft1 	#se a hipotenusa for menor que a soma dos catetos(se t0 == 1 teve colisão)
	
	bgtz t0, colidiu	#se for 1 teve colisão
		flw fs0,0(sp)
		flw fs1,4(sp)
		addi sp,sp,8
		ret
	
	colidiu:
		fsub.s ft0,fa1,fs1	# cateto y
		fdiv.s fa4,ft0,ft2	# cos(x)
		
		fsub.s ft0,fa0,fs0	# cateto x
		fdiv.s fa3,ft0,ft2	# sen(x)
		
		#|cos(theta) -sen(theta)| 	.	 |x|
		#|sen(theta) cos(theta)	|		 |y|
		
		fmul.s ft0,fs2,fa4 	#cos(x)*x
		fneg.s ft1,fa3		#-sen(theta)
		fmul.s ft1,fs3,ft1	#y*(-sen(theta))
		fadd.s ft0,ft0,ft1	#x = xcos(theta)+(-ysen(theta))
		
		fmv.s fs2,ft0
				
						
		fmul.s ft1,fs2,fa3	#sen(x)*x
		fmul.s ft2,fs3,fa4	#cos(x)*y
		fadd.s ft1,ft1,ft2	#y = xcos(theta)+ycos(theta)
		
		#fmv.s fs3,ft1
	
		######################
		#inverte o y
		fneg.s fs3,ft1
		######################
		#|cos(-theta) -sen(-theta)| 	.	 |x|
		#|sen(-theta) cos(-theta)	|		 |y|
		
		fmul.s ft2,fs2,fa4 	#cos(x)*x
		fmul.s ft3,fs3,fa3	#y*sen(x)
		fadd.s ft2,ft2,ft3	#x = xcos(x)+ysen(x)
		
		fmv.s fs2,ft2		#atualiza forca x
		
		fneg.s ft3,fa3
		fmul.s ft3,fs2,ft3	#sen(x)*x
		fmul.s ft4,fs3,fa4	#cos(x)*y
		
		fadd.s ft3,ft3,ft4	#y = xsen(theta)+ycos(theta)
		
		fmv.s fs3,ft3		#atualiza forca y
		
		flw fs0,0(sp)
		flw fs1,4(sp)
		addi sp,sp,8
		ret
		
		
	
	
