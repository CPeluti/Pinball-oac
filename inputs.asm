inputs: 
	addi sp,sp,-4
	sw ra,(sp)
	jal KEY2 
	lw ra,(sp)
	addi sp, sp, 4
	      		# le o teclado 	non-blocking
	
	ret

### Apenas verifica se h� tecla pressionada
KEY2:	li t1,0xFF200000		# carrega o endere�o de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,FIM   	   	# Se n�o h� tecla pressionada ent�o vai para FIM
  		lw a0,4(t1)  			# le o valor da tecla tecla
  		
	
FIM:	ret	
