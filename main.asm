.data
.include "hitMap.data"
.include "ball.data"

bordas: .word 30,247,200,56
.eqv gravity 1
.eqv BOFF -6
.eqv ELOSSN -5
.eqv ELOSSP 5
.eqv raioP 7
.eqv raioN -7
.text
	#usar uma matriz com cores pra representar as areas de colisão onde as areas serão os objetos + raio da bola.
	li t0,gravity
	fcvt.s.w fs8,t0
	li t0,1
	li t1,2	#energia
	
	fcvt.s.w ft1,t1
	fcvt.s.w ft0,t0
	fdiv.s fs9,ft0,ft1	#fs9 = 50% energy loss

	
	
	li t0,160	#posicão x inicial
	li t1,120	#posição y inicial
	li t2,-10	#força x inicial
	li t3,0		#força y inicial
	fcvt.s.w fs0,t0
	fcvt.s.w fs1,t1
	fcvt.s.w fs2,t2
	fcvt.s.w fs3,t3
	
	li a7,30
	ecall
	li s8,0
	mv s9,a0
	
	li a0,0
	li a1,0
	la a3,hitMap
	call show
	
	fcvt.w.s a0,fs0
	fcvt.w.s a1,fs1
	la a3,ball
	call showBall
	
	

loop:
	
	
	
	fcvt.w.s a0,fs0
	fcvt.w.s a1,fs1
	la a3,ball
	la a4,hitMap
	call deleteBall	
	
	li a0,0
	li a1,0
	fcvt.s.w fa0,a0
	fcvt.s.w fa1,a1
	call updateBall
	
	
	
	fcvt.w.s a0,fs0
	fcvt.w.s a1,fs1
	la a3,ball
	call showBall
	li a7,32
	li a0,70
	ecall
	
	
	j loop
	
	li a7,10
	ecall
	
	
	
	#fa0 = forca aplicada no x ; fa1 = forca aplicada no y
updateBall:
	addi sp,sp,-4
	sw ra,(sp)
	la a1,hitMap
	call checkColision
	lw ra,(sp)
	addi sp,sp,4

		fadd.s fs0,fs0,fs2#atualiza x
		fadd.s fs1,fs1,fs3#atualiza y
		
		fadd.s fs2,fs2,fa0#atualiza forca x
		fadd.s fs3,fs3,fa1
		fadd.s fs3,fs3,fs8#atualiza forca y incluindo a gravidade
	
	
	ret
		
	
	#printa a bola na tela onde posX=a0 posY=a1, imagemBall=a3
	#usando o centro da bola como referecia
	
showBall:

	#printa a bola na tel
	li t1,0xFF000000

	addi t0,a0,BOFF
	addi t2,a1,BOFF

	li t6,320
	mul t2,t6,t2
	add t0,t0,t2							#pos atual
	add t1,t1,t0
	
	
	lw t2,0(a3)							#ncolunas
	lw t3,4(a3)							#nlinhas
	
	addi a3,a3,8
	
	forLinhas2:
		beqz t3,fimShow2						#se nlinhas==0
		mv t6,t2 						#i=nColunas
		forColunas2:
			beqz t6,fimForColunas2 				#se i ==0 
			lb t4,0(a3)					#carrega a word
			sb t4,0(t1)					#escreve a word na tela
			addi a3,a3,1					#vai para a proxima word da imagem 
			addi t1,t1,1					#vai para o proximo pixel da tela
			addi t6,t6,-1					#i--
			j forColunas2
		fimForColunas2:	
		addi t3,t3,-1						#nlinhas--
		
		addi t1,t1,320						#vai pra proxima linha
		sub t1,t1,t2						#normaliza o ponto
		j forLinhas2
	
fimShow2:
	ret
	#atualiza a posicao da bola na tela onde posX=a0 posY=a1, imagemBall=a3 e imagemBg=a4
deleteBall: 

	################################################################limpa a bola da tela
	li t1,0xFF000000
	
	addi t0,a0,BOFF
	addi t2,a1,BOFF

	li t6,320
	mul t2,t6,t2
	add t0,t0,t2							#pos atual
	add t1,t1,t0
	
	addi a4,a4,8
	add a4,a4,t0
	
	lw t2,0(a3)							#ncolunas
	lw t3,4(a3)							#nlinhas
	
	forLinhasBall:
		beqz t3,fimForBall						#se nlinhas==0
		mv t6,t2 						#i=nColunas
		forColunasBall:
			beqz t6,fimForColunasBall 			#se i ==0 
			lb t4,0(a4)					#carrega a word
			sb t4,0(t1)					#escreve a word na tela
			addi a4,a4,1					#vai para a proxima word da imagem 
			addi t1,t1,1					#vai para o proximo pixel da tela
			addi t6,t6,-1					#i--
			j forColunasBall
		fimForColunasBall:	
		addi t3,t3,-1						#nlinhas--
		
		addi t1,t1,320						#vai pra proxima linha
		addi a4,a4,320
		sub t1,t1,t2						#normaliza o ponto
		sub a4,a4,t2						#normaliza o ponto
		j forLinhasBall
		
fimForBall:

	ret
	######################################################################################
	
	
	#Printa imagem na posicao com o canto superior direito em x=a0, y = a1 e endereco_imagem=a3 
show:	
	li t1,0xFF000000						# endereco inicial da Memoria VGA - Frame 0
	
	mul t0,a0,a1							#calcula o endere?o inicial
	add t1,t1,t0							#setta endereco inicial
	
	
	lw t2,0(a3)							#ncolunas
	lw t3,4(a3)							#nlinhas
	
	addi a3,a3,8
	
	forLinhas:
		beqz t3,fimShow						#se nlinhas==0
		mv t6,t2 						#i=nColunas
		forColunas:
			beqz t6,fimForColunas 				#se i ==0 
			lb t4,0(a3)					#carrega a word
			sb t4,0(t1)					#escreve a word na tela
			addi a3,a3,1					#vai para a proxima word da imagem 
			addi t1,t1,1					#vai para o proximo pixel da tela
			addi t6,t6,-1					#i--
			j forColunas
		fimForColunas:	
		addi t3,t3,-1						#nlinhas--
		
		addi t1,t1,320						#vai pra proxima linha
		sub t1,t1,t2						#normaliza o ponto
		j forLinhas
	
fimShow:
	ret
	#a1 = hitMap
checkColision:

	addi a1,a1,8
	
	#forcas e posições
	fcvt.w.s t0,fs0 #posicao x
	fcvt.w.s t1,fs1	#posicao y
	fcvt.w.s t2,fs2	#forca x
	fcvt.w.s t3,fs3	#forca y
	

	bgtz t2,xPositivo		# checa se forca x é positiva
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
		j fimX
	xPositivo:
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

	fimX:
	bgtz t3,yPositivo
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
			j fimY
	
	yPositivo:
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
		ret

