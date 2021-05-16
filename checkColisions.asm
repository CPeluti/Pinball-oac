#fa0 = x obstaculo
#fa1 = y obstaculo
#fa2 = raio obstaculo
#fs0 = pos x
#fs1 = pos y
#fs2 = vel x
#fs3 = vel y
#fs4 = raio bola
#fa3 = sen da perpendicular
#fa4 = cos da perpendicular 

checkColision:
li t2,0 #flag de colisão das bordas
#proxima posição x

fadd.s ft0,fs2,fs0
fcvt.w.s t0,ft0
li t1,95
bge t0,t1,okEsquerda
	li t2,1
	fneg.s fs2,fs2
okEsquerda:
li t1,251
ble t0,t1,okDireita
	li t2,1
	fneg.s fs2,fs2
okDireita:

#proxima posição y

fadd.s ft0,fs3,fs1
li t1,17
bge t0,t1,okCima
	li t2,1
	fneg.s fs3,fs3
okCima:
li t1,220
ble t0,t1,okBaixo	
	li t2,1
	fneg.s fs3,fs3
okBaixo:
	beqz t2,naoSaiu
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
		
		
	
	
