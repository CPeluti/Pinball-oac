.data
.include "./data/default_lives.data"
CLEAR: .word 49,67,122,67,123,67,124,67,125,67,126,67,127,67,128,
66,122,66,123,66,124,66,125,66,126,66,127,66,128,
65,122,65,123,65,124,65,125,65,126,65,127,65,128,
64,122,64,123,64,124,64,125,64,126,64,127,64,128,
63,122,63,123,63,124,63,125,63,126,63,127,63,128,
62,122,62,123,62,124,62,125,62,126,62,127,62,128,
61,122,61,123,61,124,61,125,61,126,61,127,61,128,
.text
	## recebe s1 ##
lives:	addi sp, sp, -44
	sw s1, 40(sp)
	sw s2, 36(sp)
	sw s3, 32(sp)
	sw s4, 28(sp)
	sw t0, 24(sp)
	sw t1, 20(sp)
	sw t2, 16(sp)
	sw t3, 12(sp)
	sw t4, 8(sp)
	sw t5, 4(sp)
	sw t6, 0(sp)
	#li s1,3 # COMENTAR E COLOCAR VIDA PARA S1 #
	li s2, 3	# para comparar se é 3
	li s3, 2	# para comparar se é 2
	li s4, 1	# para comaparar se é 1
	beq s1,s2,TVIDA
	beq s1,s3,DVIDA
	beq s1,s4,UVIDA
	beqz s1, ZVIDA
# limpa a primeira vida #
LX1:	la t0, 	CLEAR		# carrega o endereço da Label CAMINHO em t0
	li s2, 0x252235		# cor
	li t3, 0		# contador
	li t4, 320		# num que deve ser multiplicado por Y
	lw t1, 0(t0)		# lê a quantidade de passos
	li t2, 0xFF000000 	# carrega o endereço do começo da mem. VGA (frame 1)
LXP2:	beq t3, t1, TER	# contador = número de passos termina o programa
	li t2, 0xFF000000 	# carrega o endereço do começo da mem. VGA (frame 1)
	lw t5, 4(t0)		# lê a coordenada X
	lw t6, 8(t0)		# lê a coordenada Y
	add t2, t2, t5		# soma endereço base + coord X
	mul t6, t6, t4		# multiplica Y*320
	add t2, t2, t6		# soma endereço base + coord X + coordY * 320
	sb s2, 0(t2)		# escreve 1 pixel de cor branca na frame 0 no end. da coordenada
	addi t3, t3, 1		# iteração
	addi t0, t0, 8		# soma 8 no endereço da Label CAMINHO
	j LXP2	
TER:	ret
## limpa a segunda vida ##
LX2:	la t0, 	CLEAR		# carrega o endereço da Label CAMINHO em t0
	li s2, 0x252235		# cor
	li t3, 0		# contador
	li t4, 320		# num que deve ser multiplicado por Y
	lw t1, 0(t0)		# lê a quantidade de passos
	li t2, 0xFF000000 	# carrega o endereço do começo da mem. VGA (frame 1)
LXP3:	beq t3, t1, TER	# contador = número de passos termina o programa
	li t2, 0xFF000000 	# carrega o endereço do começo da mem. VGA (frame 1)
	lw t5, 4(t0)		# lê a coordenada X
	addi t5,t5,-21		# modifica o X para apagar a segunda vida
	lw t6, 8(t0)		# lê a coordenada Y
	add t2, t2, t5		# soma endereço base + coord X
	mul t6, t6, t4		# multiplica Y*320
	add t2, t2, t6		# soma endereço base + coord X + coordY * 320
	sb s2, 0(t2)		# escreve 1 pixel de cor branca na frame 0 no end. da coordenada
	addi t3, t3, 1		# iteração
	addi t0, t0, 8		# soma 8 no endereço da Label CAMINHO
	j LXP3	
TER2:	ret	
## limpa a terceira vida ##
LX3:	la t0, 	CLEAR		# carrega o endereço da Label CAMINHO em t0
	li s2, 0x252235		# cor
	li t3, 0		# contador
	li t4, 320		# num que deve ser multiplicado por Y
	lw t1, 0(t0)		# lê a quantidade de passos
	li t2, 0xFF000000 	# carrega o endereço do começo da mem. VGA (frame 1)
LXP4:	beq t3, t1, TER3	# contador = número de passos termina o programa
	li t2, 0xFF000000 	# carrega o endereço do começo da mem. VGA (frame 1)
	lw t5, 4(t0)		# lê a coordenada X
	lw t6, 8(t0)		# lê a coordenada Y
	addi t5,t5,-42		# modifica o X para apagar a terceira vida
	add t2, t2, t5		# soma endereço base + coord X
	mul t6, t6, t4		# multiplica Y*320
	add t2, t2, t6		# soma endereço base + coord X + coordY * 320
	sb s2, 0(t2)		# escreve 1 pixel de cor branca na frame 0 no end. da coordenada
	addi t3, t3, 1		# iteração
	addi t0, t0, 8		# soma 8 no endereço da Label CAMINHO
	j LXP4	
TER3:	ret		
## 3 vidas ##
TVIDA:	li s0,0xFF000000	# Frame0
	la t0,default_lives	# endereço da imagem
	lw t1,0(t0)		# número de linhas
	lw t2,4(t0)		# número de colunas
	li t3,0			# contador
	mul t4,t1,t2		# numero total de pixels
	addi t0,t0,8		# primeiro pixel da imagem
LXP1: 	beq t3,t4,ACABOU	# Coloca a imagem no Frame0
	lw t5,0(t0)
	sw t5,0(s0)	
	addi t0,t0,4
	addi s0,s0,4
	addi t3,t3,1
	j LXP1
DVIDA:	jal LX1
	j ACABOU
UVIDA:	jal LX1
	jal LX2
	j ACABOU
ZVIDA: 	jal LX1
	jal LX2
	jal LX3
	j ACABOU
ACABOU: lw t6, 0(sp)
	lw t5, 4(sp)
	lw t4, 8(sp)
	lw t3, 12(sp)
	lw t2, 16(sp)
	lw t1, 20(sp)
	lw t0, 24(sp)
	lw s4, 28(sp)
	lw s3, 32(sp)
	lw s2, 36(sp)
	lw s1, 40(sp)
	addi sp, sp, 44
	li a7,10
	ecall
