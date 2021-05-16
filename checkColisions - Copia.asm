
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
	li a6,1 #flag de colisão em baixo
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
	
	li a5,0
		
	
		blez t2,okDireitaBaixo
		addi t5,t1,0	#checa borda de baixo
		addi t4,t0,0	#checa borda da direita
		add t5,t5,t3 		#y futuro
		add t4,t4,t2		#x futuro
		li t6,320
		mul t6,t6,t5		#y*320
		add t5,t6,t4		#ponto futuro( x atual + 320 *y futuro)
		add t5,t5,a1		#pos do futuro
		lbu t5,(t5)		#carrega a cor do ponto futuro
		#checa diagonal direita baixo
		li t4,255		#cor branca
		beq t4,t5,okDireitaBaixo
			li a6,0
			li a5,3
			# corrige gravidade
			fcvt.w.s t3,fs3		
			fcvt.s.w ft0,t3		#ft0 = fs3 arredondado
			fabs.s ft1,fs3		#ft1 = |fs3|
			fabs.s ft0,ft0		#ft0 = |ft0|
			fgt.s t4,fs3,ft0	# t0 = fs3>ft0
			#addi t1,t1,raioP	#seta para checar colisao em baixo
			bnez t4,subtrai
			
			fneg.s fs3,fs3
			
			
			subtrai:
				addi t3,t3,-1
				fcvt.s.w fs3,t3
				fneg.s fs3,fs3
				j energia
		okDireitaBaixo:
		
		bgtz t3,okDireitaCima
		addi t5,t1,0	#checa borda de cima
		addi t4,t0,0	#checa borda da direita
		add t5,t5,t3 		#y futuro
		add t4,t4,t2		#x futuro
		li t6,320
		mul t6,t6,t5		#y*320
		add t5,t6,t4		#ponto futuro( x atual + 320 *y futuro)
		add t5,t5,a1		#pos do futuro
		lbu t5,(t5)		#carrega a cor do ponto futuro
		#checa diagonal direita baixo
		li t4,255		#cor branca
		beq t4,t5,okDireitaCima
			li a5,3
			fneg.s fs3,fs3
		okDireitaCima:
		
		bgtz t2,okEsquerdaBaixo
		addi t5,t1,raioP	#checa borda de baixo
		addi t4,t0,0	#checa borda da esquerda
		add t5,t5,t3 		#y futuro
		add t4,t4,t2		#x futuro
		li t6,320
		mul t6,t6,t5		#y*320
		add t5,t6,t4		#ponto futuro( x atual + 320 *y futuro)
		add t5,t5,a1		#pos do futuro
		lbu t5,(t5)		#carrega a cor do ponto futuro
		#checa diagonal direita baixo
		li t4,255		#cor branca
		beq t4,t5,okEsquerdaBaixo
			li a5,3
			fneg.s fs3,fs3
			fneg.s fs2,fs2
			li a6,0
			j energia
			
		okEsquerdaBaixo:
		bgtz t3,okEsquerdaCima
		addi t5,t1,0	#checa borda de cima
		addi t4,t0,0	#checa borda da esquerda
		add t5,t5,t3 		#y futuro
		add t4,t4,t2		#x futuro
		li t6,320
		mul t6,t6,t5		#y*320
		add t5,t6,t4		#ponto futuro( x  + 320 *y futuro)
		add t5,t5,a1		#pos do futuro
		lbu t5,(t5)		#carrega a cor do ponto futuro
		#checa diagonal direita baixo
		li t4,255		#cor branca
		beq t4,t5,okEsquerdaCima
			li a5,3
			fneg.s fs3,fs3
	
		okEsquerdaCima:
	
	
		#energia:
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
			li a5,1
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
			li a5,1
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
			addi a5,a5,2
			fneg.s fs3,fs3
			j energia
		okCima:
		beq a6,zero,energia
		
		addi t5,t1,raioP	#checa borda de baixo
		li t4,255		#cor branca
		
		add t5,t5,t3 		#y futuro
		li t6,320
		mul t6,t6,t5		#y*320
		add t5,t6,t0		#ponto futuro( x atual + 320 *y futuro)
		add t5,t5,a1		#y atual
		lbu t5,(t5)		#carrega a cor do ponto futuro
		#checa colisão em baixo

		beq t4,t5,energia
			addi a5,a5,2
		
			# corrige gravidade
			fcvt.w.s t3,fs3		
			fcvt.s.w ft0,t3		#ft0 = fs3 arredondado
			fabs.s ft1,fs3		#ft1 = |fs3|
			fabs.s ft0,ft0		#ft0 = |ft0|
			fgt.s t4,fs3,ft0	# t0 = fs3>ft0
			#addi t1,t1,raioP	#seta para checar colisao em baixo
			bnez t4,subtrai1
			
			fneg.s fs3,fs3
			j energia
			subtrai1:
				addi t3,t3,-1
				fcvt.s.w fs3,t3
				fneg.s fs3,fs3
		
		energia:
		

		li t6,1
		beq a5,t6,x
		li t6,2
		beq a5,t6,y
		li t6,3
		beq a5,t6,xy
		j fimColision
		x:
			fmul.s fs2,fs2,fs9	#tira energia
			j fimColision
		y:
			fmul.s fs3,fs3,fs9	#tira energia
			j fimColision
		xy:
			fmul.s fs2,fs2,fs9	#tira energia
			fmul.s fs3,fs3,fs9	#tira energia
		fimColision:
		lw a0,0(sp)
		lw ra,4(sp)
		flw fa0,8(sp)
		addi sp,sp,12
		ret
