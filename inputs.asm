inputs: 
	addi sp,sp,-4
	sw ra,(sp)
	li a0,0
	jal KEY2       		# le o teclado 	non-blocking
	lw ra,(sp)
	ret

### Apenas verifica se há tecla pressionada
KEY2:	li t1,0xFF200000		# carrega o endereço de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,FIM   	   	# Se não há tecla pressionada então vai para FIM
  		lw a0,4(t1)  			# le o valor da tecla tecla
	
FIM:	ret	


checkInputs:
	li t0, 122 #z
	beq a0,t0,flipperE
	li t0, 120 #x
	beq a0,t0,flipperD	
	
	
	ret
	flipperE:
		addi sp,sp,-4
		sw ra,(sp)
		la a1,hitboxFlipperE
		li a2,129
		li a3,177
		call drawHitboxOnScreen
		la a1,hitboxFlipperE
		li a2,129
		li a3,177
		call drawHitbox
		li s8,1
		lw ra,(sp)
		addi sp,sp,4
		ret
	flipperD:
		addi sp,sp,-4
		sw ra,(sp)
		la a1,hitboxFlipperD
		li a2,185
		li a3,175
		call drawHitboxOnScreen
		la a1,hitboxFlipperD
		li a2,185
		li a3,175
		call drawHitbox
		li s8,2
		lw ra,(sp)
		addi sp,sp,4
		ret	
	
	
	
cleanFlippers:
	beqz s8,semFlipper
	li t0,1
	beq t0,s8,flipperEsquerdo
	li t0,2
	beq t0,s8,flipperDireito
	flipperEsquerdo:
	addi sp,sp,-4
	sw ra,(sp)
	li a0,0xFF000000
	la a1,hitboxFlipperE
	li a2,129
	li a3,177
	la a4,hitMap2
	call deleteHitbox
	
	la a0,hitMap
	addi a0,a0,8
	la a1,hitboxFlipperE
	li a2,129
	li a3,177
	la a4,hitMap2
	call deleteHitbox
	lw ra,(sp)
	addi sp,sp,4
	li s8,0
	ret
	flipperDireito:
	addi sp,sp,-4
	sw ra,(sp)
	li a0,0xFF000000
	la a1,hitboxFlipperD
	li a2,185
	li a3,175
	la a4,hitMap2
	call deleteHitbox
	
	la a0,hitMap
	addi a0,a0,8
	la a1,hitboxFlipperD
	li a2,185
	li a3,175
	la a4,hitMap2
	call deleteHitbox
	lw ra,(sp)
	addi sp,sp,4
	li s8,0
	ret
	ret
	semFlipper:
	ret
	
#a0=endereço onde tem q ser apagado a1=imagem a ser apagada a2 = x a3 = y a4 = bg
deleteHitbox:
	mv t1,a0
	addi a4,a4,8

	
	li t6,320
	mul t3,t6,a3
	add t3,t3,a2							#pos atual
	add t1,t3,t1
	
	add a4,a4,t3
	
	lw t2,0(a1)							#ncolunas
	lw t3,4(a1)							#nlinhas
	addi a1,a1,8
	forLinhasDelete:
		beqz t3,fimForDelete						#se nlinhas==0
		mv t6,t2 						#i=nColunas
		forColunasDelete:
			beqz t6,fimForColunasDelete 			#se i ==0 
			lb t4,0(a4)					#carrega a word
			sb t4,0(t1)					#escreve a word na tela
			addi a4,a4,1					#vai para a proxima pixel da imagem 
			addi t1,t1,1					#vai para o proximo pixel da tela
			addi t6,t6,-1					#i--
			j forColunasDelete
		fimForColunasDelete:	
		addi t3,t3,-1						#nlinhas--
		
		addi t1,t1,320						#vai pra proxima linha
		addi a4,a4,320
		sub t1,t1,t2						#normaliza o ponto
		sub a4,a4,t2						#normaliza o ponto
		j forLinhasDelete
	fimForDelete:
	ret

#a1=hitbox 
#a2=x
#a3=y

drawHitboxOnScreen:
	li t0,0xFF000000
	li t6,320
	mul a3,t6,a3
	add t1,a2,a3							#pos atual
	add t0,t0,t1
	
	
	lw t2,0(a1)							#ncolunas
	lw t3,4(a1)							#nlinhas
	
	addi a1,a1,8
	
	forDrawLinha1:
		beqz t3,fimDrawHitbox1						#se nlinhas==0
		mv t6,t2 						#i=nColunas
		forColunasDraw1:
			beqz t6,fimForDrawColuna1 				#se i ==0 
			lb t4,0(a1)					#carrega a word
			sb t4,0(t0)					#escreve a word na tela
			addi a1,a1,1					#vai para a proxima word da imagem 
			addi t0,t0,1					#vai para o proximo pixel do hitmap
			addi t6,t6,-1					#i--
			j forColunasDraw1
		fimForDrawColuna1:	
		addi t3,t3,-1						#nlinhas--
		
		addi t0,t0,320						#vai pra proxima linha
		sub t0,t0,t2						#normaliza o ponto
		j forDrawLinha1	
	fimDrawHitbox1:
		ret
		
		#a1 = hitbox a2=x a3 = y
drawHitbox:
	la t0, hitMap
	addi t0,t0,8
	li t6,320
	mul a3,t6,a3
	add t1,a2,a3							#pos atual
	add t0,t0,t1
	
	
	lw t2,0(a1)							#ncolunas
	lw t3,4(a1)							#nlinhas
	
	addi a1,a1,8
	
	forDrawLinha:
		beqz t3,fimDrawHitbox						#se nlinhas==0
		mv t6,t2 						#i=nColunas
		forColunasDraw:
			beqz t6,fimForDrawColuna 				#se i ==0 
			lb t4,0(a1)					#carrega a word
			sb t4,0(t0)					#escreve a word na tela
			addi a1,a1,1					#vai para a proxima word da imagem 
			addi t0,t0,1					#vai para o proximo pixel do hitmap
			addi t6,t6,-1					#i--
			j forColunasDraw
		fimForDrawColuna:	
		addi t3,t3,-1						#nlinhas--
		
		addi t0,t0,320						#vai pra proxima linha
		sub t0,t0,t2						#normaliza o ponto
		j forDrawLinha	
	fimDrawHitbox:
		ret
