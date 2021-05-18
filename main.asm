#fs0 = pos x
#fs1 = pos y
#fs2 = vel x
#fs3 = vel y
#fs4 = raio bola
#s8 = flipper ativo
.data
.include "./data/map.data"
.include "./data/hitMap.data"
.include "./data/hitMap2.data"
.include "./data/ball.data"
.include "./data/hitboxFlipperE.data" 
.include "./data/hitboxFlipperD.data"
.include "./data/flipperE.data"
.include "./data/flipperD.data"
#n, (x,y,raio,tipo),(x,y,raio,tipo),(x,y,raio,tipo)	
obstaculos: .word 8,173,113,6,2,138,136,6,2,207,137,6,2,207,89,6,2,138,88,6,2,145,62,4,1,172,62,4,1,201,62,4,1

bordas: .word 30,247,200,56
.eqv gravity 1
.eqv BOFF -4
.eqv raio 4

.text
	



	li s6,0		#flag de gameover
	li t0,140	#posicão x inicial
	li t1,60	#posição y inicial
	li t2,0		#força x inicial
	li t3,-15	#força y inicial
	li t4,raio
	li t5,gravity
	fcvt.s.w fs0,t0
	fcvt.s.w fs1,t1
	fcvt.s.w fs2,t2
	fcvt.s.w fs3,t3
	fcvt.s.w fs4,t4
	fcvt.s.w fs8,t5
	li t0,1
	li t1,2
	fcvt.s.w ft0,t0
	fcvt.s.w ft1,t1
	fdiv.s fs5,ft0,ft1
	
	li a7,30
	ecall
	li s8,0
	mv s9,a0
	
	li a0,0
	li a1,0
	fcvt.s.w fa0,a0
	fcvt.s.w fa1,a1
	
	la a3,map
	call show
	
	fcvt.w.s a0,fs0
	fcvt.w.s a1,fs1
	la a3,ball
	call showBall
	
	
	
	

loop:
	
	call inputs
	call checkInputs
	
	fcvt.w.s a0,fs0
	fcvt.w.s a1,fs1
	la a3,ball
	la a4,map
	call deleteBall
	
	li a0,0
	li a1,0
	la a4,hitMap
	call updateBall

	
	fcvt.w.s a0,fs0
	fcvt.w.s a1,fs1
	la a3,ball
	call showBall
	li a7,32
	li a0,70
	ecall
	
	call cleanFlippers
	
	j loop
	
	
	


updateBall:
		
		
	addi sp,sp,-24
	fsw fa0,0(sp)
	fsw fa1,4(sp)
	fsw fa2,8(sp)
	fsw fa3,12(sp)
	sw a0,16(sp)
	sw ra,20(sp)
	
		#fa0 = x obstaculo
		#fa1 = y obstaculo
		#fa2 = raio obstaculo
		
		inicioCheck:la t0,obstaculos
		lw t6,0(t0)
		addi t0,t0,4
		check: blez t6,fimobstaculos
		lw t2,0(t0)
		fcvt.s.w fa0,t2
		lw t2,4(t0)
		fcvt.s.w fa1,t2
		lw t2,8(t0)
		fcvt.s.w fa2,t2
		lw t2,12(t0)
		fcvt.s.w fa3,t2
		addi t0,t0,16
		addi t6,t6,-1
		call obstaculoCheck
		beqz a0,check
		j inicioCheck		
		fimobstaculos:
		call checkColision
		
		flw fa0,0(sp)
		flw fa1,4(sp)
		flw fa2,8(sp)
		flw fa3,12(sp)
		lw a0,16(sp)
		addi sp,sp,20
		
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
		fadd.s fs3,fs3,fs8#atualiza forca y incluindo a gravidade
	
	
	lw ra,0(sp)
	addi sp,sp,4
	
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
	#x=20
	#y=100 32020
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

.include "inputs.asm"

gameOver:
li a7,1
li a0,10
ecall
li a7,10
ecall
