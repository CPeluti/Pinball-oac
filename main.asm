#fs0 = pos x
#fs1 = pos y
#fs2 = vel x
#fs3 = vel y
#fs4 = raio bola
.data
.include "hitMap.data"
.include "ball.data"
#(x,y,raio,tipo)	
obstaculos: .word 173,114,6,1

bordas: .word 30,247,200,56
.eqv gravity 1
.eqv BOFF -4
.eqv raio 4

.text
	



	
	li t0,170	#posicão x inicial
	li t1,30	#posição y inicial
	li t2,0		#força x inicial
	li t3,5	#força y inicial
	li t4,raio
	fcvt.s.w fs0,t0
	fcvt.s.w fs1,t1
	fcvt.s.w fs2,t2
	fcvt.s.w fs3,t3
	fcvt.s.w fs4,t4
	
	li a7,30
	ecall
	li s8,0
	mv s9,a0
	
	li a0,0
	li a1,0
	fcvt.s.w fa0,a0
	fcvt.s.w fa1,a1
	
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
	#call deleteBall	
	
	li a0,0
	li a1,0
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
	
	
	
	
updateBall:
		
		
	addi sp,sp,-16
	fsw fa0,0(sp)
	fsw fa1,4(sp)
	fsw fa2,8(sp)
	sw ra,12(sp)
		#fa0 = x obstaculo
		#fa1 = y obstaculo
		#fa2 = raio obstaculo
		
		la t0,obstaculos
		lw t1,0(t0)
		fcvt.s.w fa0,t1
		lw t1,4(t0)
		fcvt.s.w fa1,t1
		lw t1,8(t0)
		fcvt.s.w fa2,t1
		call checkColision
		
		flw fa0,0(sp)
		flw fa1,4(sp)
		flw fa2,8(sp)
		addi sp,sp,12
		
		fadd.s fs0,fs2,fs0
		fmv.s ft0,fa0
		fmv.s fa0,fs0
		call floor
		fcvt.s.w fs0,a0
		
		fadd.s fs1,fs3,fs1
		fmv.s fa0,fs1
		call floor
		fcvt.s.w fs1,a0
		
		fmv.s fa0,ft0
		
		fadd.s fs2,fs2,fa0#atualiza forca x
		fadd.s fs3,fs3,fa1
		#fadd.s fs3,fs3,fs8#atualiza forca y incluindo a gravidade
	
	
	lw ra,0(sp)
	addi sp,sp,16
	
	ret
		
	
	#printa a bola na tela onde posX=a0 posY=a1, imagemBall=a3
	#usando o centro da bola como referecia
####################################################################################################	
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
####################################################################################################	
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


.include "checkColisions.asm"
		
		
.include "round.asm"


