.data

ZERUNI1:.word 60,64,51,64,52,64,53,64,54,64,55,64,56,64,57,64,58,64,59,64,60,64,61,64,62,64,63,
63,51,63,52,63,53,63,54,63,55,63,56,63,57,63,58,63,59,63,60,63,61,63,62,63,63,
60,51,60,52,60,53,60,54,60,55,60,56,60,57,60,58,60,59,60,60,60,61,60,62,60,63,
59,51,59,52,59,53,59,54,59,55,59,56,59,57,59,58,59,59,59,60,59,61,59,62,59,63,
61,51,61,52,62,51,62,52,62,62,62,63,61,62,61,63

.text  
######## SCORE DEFAULT #######
score:
	addi sp,sp,-32
	sw t0,28(sp)
	sw t1,24(sp)
	sw t2,20(sp)
	sw t3,16(sp)
	sw t4,12(sp)
	sw t5,8(sp)
	sw t6,4(sp)
	sw s2,0(sp)
	la t0, ZERUNI1		# carrega o endereço da Label CAMINHO em t0
	li s2, 0x00000007	# cor braca
	li t3, 0		# contador
	li t4, 320		# num que deve ser multiplicado por Y
	lw t1, 0(t0)		# lê a quantidade de passos
	li t2, 0xFF000000 	# carrega o endereço do começo da mem. VGA (frame 1)
LOP:	beq t3, t1, ZDEZ	# contador = número de passos termina o programa
	li t2, 0xFF000000 	# carrega o endereço do começo da mem. VGA (frame 1)
	lw t5, 4(t0)		# lê a coordenada X
	lw t6, 8(t0)		# lê a coordenada Y
	add t2, t2, t5		# soma endereço base + coord X
	mul t6, t6, t4		# multiplica Y*320
	add t2, t2, t6		# soma endereço base + coord X + coordY * 320
	sb s2, 0(t2)		# escreve 1 pixel de cor braca na frame 0 no end. da coordenada
	addi t3, t3, 1		# iteração
	addi t0, t0, 8		# soma 8 no endereço da Label CAMINHO
	j LOP
ZDEZ:	la t0, ZERUNI1			# carrega o endereço da Label CAMINHO em t0
	li s2, 0x00000007	# cor braca
	li t3, 0		# contador
	li t4, 320		# num que deve ser multiplicado por Y
	lw t1, 0(t0)		# lê a quantidade de passos
	li t2, 0xFF000000 	# carrega o endereço do começo da mem. VGA (frame 1)
LOP1:	beq t3, t1, ZCEN	# contador = número de passos termina o programa
	li t2, 0xFF000000 	# carrega o endereço do começo da mem. VGA (frame 1)
	lw t5, 4(t0)		# lê a coordenada X
	addi t5,t5,-8		# subtrai 8 para deixar um espaço
	lw t6, 8(t0)		# lê a coordenada Y
	add t2, t2, t5		# soma endereço base + coord X
	mul t6, t6, t4		# multiplica Y*320
	add t2, t2, t6		# soma endereço base + coord X + coordY * 320
	sb s2, 0(t2)		# escreve 1 pixel de cor braca na frame 0 no end. da coordenada
	addi t3, t3, 1		# iteração
	addi t0, t0, 8		# soma 8 no endereço da Label CAMINHO
	j LOP1
ZCEN:	la t0, ZERUNI1		# carrega o endereço da Label CAMINHO em t0
	li s2, 0x00000007	# cor braca
	li t3, 0		# contador
	li t4, 320		# num que deve ser multiplicado por Y
	lw t1, 0(t0)		# lê a quantidade de passos
	li t2, 0xFF000000 	# carrega o endereço do começo da mem. VGA (frame 1)
LOP2:	beq t3, t1, ZMIL	# contador = número de passos termina o programa
	li t2, 0xFF000000 	# carrega o endereço do começo da mem. VGA (frame 1)
	lw t5, 4(t0)		# lê a coordenada X
	lw t6, 8(t0)		# lê a coordenada Y
	addi t5,t5,-16		# subtrai 16 para deixar espaço
	add t2, t2, t5		# soma endereço base + coord X
	mul t6, t6, t4		# multiplica Y*320
	add t2, t2, t6		# soma endereço base + coord X + coordY * 320
	sb s2, 0(t2)		# escreve 1 pixel de cor braca na frame 0 no end. da coordenada
	addi t3, t3, 1		# iteração
	addi t0, t0, 8		# soma 8 no endereço da Label CAMINHO
	j LOP2
ZMIL:	la t0, ZERUNI1		# carrega o endereço da Label CAMINHO em t0
	li s2, 0x00000007	# cor braca
	li t3, 0		# contador
	li t4, 320		# num que deve ser multiplicado por Y
	lw t1, 0(t0)		# lê a quantidade de passos
	li t2, 0xFF000000 	# carrega o endereço do começo da mem. VGA (frame 1)
LOP3:	beq t3, t1, FI	# contador = número de passos termina o programa
	li t2, 0xFF000000 	# carrega o endereço do começo da mem. VGA (frame 1)
	lw t5, 4(t0)		# lê a coordenada X
	lw t6, 8(t0)		# lê a coordenada Y
	addi t5,t5,-24
	add t2, t2, t5		# soma endereço base + coord X
	mul t6, t6, t4		# multiplica Y*320
	add t2, t2, t6		# soma endereço base + coord X + coordY * 320
	sb s2, 0(t2)		# escreve 1 pixel de cor braca na frame 0 no end. da coordenada
	addi t3, t3, 1		# iteração
	addi t0, t0, 8		# soma 8 no endereço da Label CAMINHO
	j LOP3
FI:	lw s2,0(sp)
	lw t6,4(sp)
	lw t5,8(sp)
	lw t4,12(sp)
	lw t3,16(sp)
	lw t2,20(sp)
	lw t1,24(sp)
	lw t0,28(sp)
	addi sp,sp,32
	ret
