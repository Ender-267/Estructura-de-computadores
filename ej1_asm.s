.data
	.align 2
error: .float 0,001
a:	   .float 2.2
b:	   .float 5

.text
main:
	la s0 a
	flw fa0 0(s0)
    la s0 b
    li a0 4
    jal ra elevar
    # Finalizar programa
    li a7 10
    ecall
# Funciones solucion
sin: #sin(x)
	fmv.s ft0 fa0						# ft0 = fa0
    la t0 error
    flw ft1 0(t0)						# ft1 = 0.001
    li t0 0								# t0 variable contador n
    li t1 2								# t2 = 2
  	sin_bucle:
    	mul t3 t0 t2					# t3 = t0 * t2 = 2n
        addi t3 t3 1					# t3 = t3 + 1 = 2n + 1
        mv a0 t3
        jal ra factorial				# factorial(t3); a0 = (2n+1)!
        mv t3 a0						# t3 = a0 = (2n+1)!
    	jal ra elevar					# elevar(fa0, a0); fa0 = x^(2n+1)
        fmv.w.x ft3 t3					# ft3 = t3 = (2n+1)! 
        fdiv.s ft4 fa0 ft3				# ft4 = ft0 / ft3 = (x^(2n+1))/(2n+1)!
        rem t3 t0 t1					# t3 = t0 % t1 = n % 2
    	beq t3 zero sin_else			# if t3 != 0:
        fsub.s ft5 ft5 ft4				# ft5 -= ft4; ft5: respuesta actual
        sin_else: fadd.s ft5 ft5 ft4	# else: ft5 += ft4; ft5: respuesta actual
        addi t0 t0 1					# t0 += 1; n += 1; actualizar contador
        fsub.s ft7 ft5 ft6				# ft7 = ft5 - ft6; ft7: error, ft6: respuesta previa
        fabs.s ft7 ft7					# ft7 = |ft5 -ft6| = |respuesta actual - respuesta previa| = error
        flt.s t3 ft7 ft1				# if ft7 < ft1; if error < 0.001
        bne t3 zero sin_final			# break
        fmv.s ft6 ft5					# ft6 = ft5; respuesta previa = respuesta actual
    sin_final:
    	fmv.s fa0 ft5					# return ft5; return respuesta actual
        jr ra
	
# Funciones auxiliares
elevar: #x^n; x = fa0; n = a0; Solo admite positivos y n enteros
	mv t0 a0							# t0 = n
    fmv.s ft0 fa0						# ft0 = x
    # Si n = 0 return 1
    li a0 1
    beq t0 zero elevar_final			
    # Bucle
    li t1 1								# Final contador
    elevar_bucle: 					
    	beq t0 t1 elevar_final			# While t0 != 1:
        addi t0 t0 -1					# t0 -= 1
        fmul.s fa0 fa0 ft0				# fa0 *= ft0
        j elevar_bucle
    elevar_final: jr ra
factorial: #x!; a0 = x Solo admite enteros
	mv t0 a0 						    # t0 = x
    # Retorna 1 si x = 0
    li a0 1
    beq t0 zero factorial_final
    mv t1 t0						    # t1 variable contador n; t1 = x
    li t2 1							    # Numero de final de bucle
    mv a0 t0						    # Inicializar retorno a x
    factorial_bucle:
    	beq t2 t1 factorial_final	    # While n != 1:
        addi t1 t1 -1				    # Restar contador n -= 1
        mul a0 a0 t1				    # a0 = a0 * t1; retorno = retorno * n
        j factorial_bucle
    factorial_final: jr ra			# Retorna a0
    
