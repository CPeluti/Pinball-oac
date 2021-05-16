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

checkColision:
li t2,0 #flag de colisão das bordas
#proxima posição x

fadd.s ft0,fs2,fs0#posição futura x
fcvt.w.s t0,ft0	
fcvt.w.s t3,fs4
fcvt.w.s t4,fs1
sub t0,t0,t3	#subtrai raio para checar a borda da esquerda
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
sub t0,t0,t3	#subtrai raio para checar a borda de cima
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


fadd.s ft0,fs3,fs1#posição futura y
fcvt.w.s t0,ft0	
fcvt.w.s t3,fs4
fcvt.w.s t4,fs0	#posicao x
add t0,t0,t3	#subtrai raio para checar a borda de cima
li t3,320
mul t0,t0,t3	#posição do y na matriz
add t0,t0,t4 	#posição x+320y(ponto no vetor)
add t0,t0,a4	#adiciona o endereço do vetor
lbu t0,(t0)
li t1,255
beq t0,t1,okBaixo	
	addi t2,t2,2

okBaixo:
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
		
		fmv.s fs3,ft1
	
		######################
		#inverte o y
		fneg.s ft1,ft1
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
		
		
	
	
