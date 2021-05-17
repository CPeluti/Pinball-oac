floor:
# arredondamento floor 
			addi sp,sp,-20
			sw t0,0(sp)
			sw t1,4(sp)
			sw t2,8(sp)
			fsw ft0,12(sp)
			fsw ft1,16(sp)
			
			fcvt.w.s t0,fa0		#arredonda o valor	
			fcvt.s.w ft0,t0		#ft0 = fa0 arredondado
			fabs.s ft1,fa0		#ft1 = |fa0|
			fabs.s ft0,ft0		#ft0 = |ft0|
			addi sp,sp,-8
			fsd ft0,0(sp)
			fsd ft1,4(sp)
			lw t1,0(sp)
			lw t2,4(sp)
			addi sp,sp,8
			ble t1,t2,naoSubtrai
				addi t0,t0,-1
			naoSubtrai:
			mv a0,t0
			lw t0,0(sp)
			lw t1,4(sp)
			lw t2,8(sp)
			flw ft0,12(sp)
			flw ft1,16(sp)
			addi sp,sp,20
			ret
