
#fs0 = pos x
#fs1 = pos y
#fs2 = vel x
#fs3 = vel y

checkColision:
	addi sp,sp,-12
	sw a0,0(sp)
	sw ra,4(sp)
	fsw fa0,8(sp)
	addi a1,a1,8
	
	#forcas e posições
	fmv.s fa0,fs0 
	call floor
	mv t6,a0 
	
	fmv.s fa0,fs1 
	call floor
	mv t5,a0 
	
	fmv.s fa0,fs2 
	call floor
	mv t2,a0 #forca x
	
	fmv.s fa0,fs3 
	call floor
	mv t3,a0 #forca y
	
	mv t0,t6 #posição x
	mv t1,t5 #posição y
	

		#checa esquerda
		addi t5,t0,raioN	#checa borda esquerda
		li t4,255		#cor branca
		add t5,t5,t2		#x futuro
		li t6,320
		mul t6,t6,t1		#y*320
		add t5,t5,t6		#ponto futuro ( x futuro + 320* y atual ) 
		add t5,t5,a1		#x atual
		lbu t5,0(t5)		#carrega a cor do ponto futuro
		#checa colizao na esquerda
		#se ponto futuro for 255, não teve colizão
		beq t4,t5,okEsquerda
			fmul.s fs2,fs2,fs9
			fneg.s fs2,fs2
		okEsquerda:
		#checa direita
		addi t5,t0,raioP	#checa borda direita
		li t4,255		#cor branca
		add t5,t5,t2		#x futuro
		li t6,320
		mul t6,t6,t1		#y*320
		add t5,t5,t6		#ponto futuro ( x futuro + 320* y atual ) 
		add t5,t5,a1		#x atual
		lbu t5,(t5)		#carrega a cor do ponto futuro
		#checa colizao na direita
		#se ponto futuro for 255, não teve colizão
		beq t4,t5,okDireita
			fmul.s fs2,fs2,fs9
			fneg.s fs2,fs2
		okDireita:

		addi t5,t1,raioN	#checa borda de cima
		li t4,255		#cor branca
		add t5,t5,t3 		#y futuro
		li t6,320
		mul t6,t6,t5		#y*320
		add t5,t6,t0		#ponto futuro( x atual + 320 *y futuro)
		add t5,t5,a1		#y atual
		lbu t5,(t5)		#carrega a cor do ponto futuro
		#checa colisão em cima
		beq t4,t5,okCima
			fmul.s fs3,fs3,fs9
			fneg.s fs3,fs3
		okCima:
		
		addi t5,t1,raioP	#checa borda de baixo
		li t4,255		#cor branca
		
		add t5,t5,t3 		#y futuro
		li t6,320
		mul t6,t6,t5		#y*320
		add t5,t6,t0		#ponto futuro( x atual + 320 *y futuro)
		add t5,t5,a1		#y atual
		lbu t5,(t5)		#carrega a cor do ponto futuro
		#checa colisão em baixo
		beq t4,t5,okBaixo
			fmul.s fs3,fs3,fs9	#tira energia
		
			# arredondamento floor
			fcvt.w.s t3,fs3		
			fcvt.s.w ft0,t3		#ft0 = fs3 arredondado
			fabs.s ft1,fs3		#ft1 = |fs3|
			fabs.s ft0,ft0		#ft0 = |ft0|
			fgt.s t4,fs3,ft0	# t0 = fs3>ft0
			bnez t4,subtrai

			fneg.s fs3,fs3
			j okBaixo
			subtrai:
				addi t3,t3,-1
				fcvt.s.w fs3,t3
				fneg.s fs3,fs3
		
		okBaixo:
		fimY:
		lw a0,0(sp)
		lw ra,4(sp)
		flw fa0,8(sp)
		addi sp,sp,12
		ret
