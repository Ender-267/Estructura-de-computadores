.data
	.align 2
error: .float 0.001
a:	   .float 2
b:	   .float 2

.text
main:
	la s0 a
    flw fa0 0(s0)
    jal ra sin
    # Finalizar programa
    li a7 10
    ecall
# Funciones solucion
sin: #sin(x)
    # ft0 y ft1 son usados por elevar()
    # ft7 = x
    # ft8 = 0.001; Error
    # t0, t1, t2 son usados por elevar y factorial
    # t3 = n; variable contador
    # t4; Operaciones de sin con enteros
    # t5 = (2n+1)!
    # t6 = 2 y resultado de error
    # ft2; Resultado de formula para una determinada n
    # ft3; Resultado previo
    # ft4; Error
    # ft5; (2n+1)! en float
    # ft6; Resultado acumulativo (Final)
    # Inicializacion
	fmv.s ft7 fa0						# ft7 = fa0 = x
    la t0 error
    flw ft8 0(t0)						# ft8 = 0.001
    li t3 0                             # t3 = 0; Variable contador n
    sin_bucle:
        li t6 2                         # t6 = 2
        mul t4 t3 t6                    # t4 = t3 * t6 = 2n
        addi t4 t4 1                    # t4 = t4 + 1 = 2n + 1
        mv a0 t4                        # Parametro t4
        jal ra factorial                # factorial(t4) => a0 = (2n+1)!
        mv t5 a0                        # t5 = (2n+1)!
        fmv.s fa0 ft7                   # Parametro fa0 = ft7 = x
        mv a0 t4                        # Parametro a0 = t4 = 2n+1
        jal ra elevar                   # elevar(x, 2n+1) => fa0 = x^(2n+1)
        # Pierdo valores de ft0 y ft1 al llamar a elevar()
        fmv.s ft2 fa0                   # ft2 = fa0 = x^(2n+1)
        fcvt.s.w ft5 t5                  # ft5 = ft2 = (2n+1)!
        fdiv.s ft2 ft2 ft5              # ft2 = ft2/ft5 =(x^(2n+1))/(2n+1)!
        rem t4 t3 t6                    # t4 = t3 % t6 = n % 2
        bne t4 zero sin_else            # if n % 2 == 0:
            fadd.s ft6 ft6 ft2          # ft6 += ft2
        sin_else:                       # else:
            fsub.s ft6 ft6 ft2          # ft6 -= ft2
        fsub.s ft4 ft2 ft3              # ft4 = ft2 - ft3; Error = resultado actual - resultado previo 
        fabs.s ft4 ft4                  # ft4 = |ft4|; error = |error|
        addi t0 t0 1                    # Incremento contador
        flt.s t6 ft4 ft8                # if error < 0.001:
        bne t6 zero sin_final           # break
        j sin_bucle                     # Bucle
    sin_final:
        fmv.s fa0 ft6                   # Return ft6
        # Resetear registros
        li t0 0
        li t1 0
        li t2 0
        li t6 0
        fmv.w.x ft0 zero
        fmv.w.x ft1 zero
        fmv.w.x ft2 zero
        fmv.w.x ft3 zero
        fmv.w.x ft4 zero
        fmv.w.x ft5 zero
        fmv.w.x ft6 zero
        fmv.w.x ft7 zero
        fmv.w.x ft8 zero
        jr ra                           # Return


# Funciones auxiliares
elevar: #x^n; x = fa0; n = a0; Solo admite positivos y n enteros; Usa registros t0 t1 ft0 ft1
	mv t0 a0							# t0 = n
    fmv.s ft0 fa0						# ft0 = x; constante
    fmv.s ft1 fa0						# ft1 = x; solucion
    # Si n = 0 return 1
    li a0 1
    beq t0 zero elevar_final			
    # Bucle
    li t1 1								# Final contador
    elevar_bucle: 					
    	beq t0 t1 elevar_final			# While t0 != 1:
        addi t0 t0 -1					# t0 -= 1
        fmul.s ft1 ft1 ft0				# ft1 *= ft0
        j elevar_bucle
    elevar_final:
        fmv.s fa0 ft1                       #return ft1
        # Resetear registros temporales
        li t0 0
        li t1 0
        fmv.w.x ft0 zero
        fmv.w.x ft1 zero
        jr ra
factorial: #x!; a0 = x Solo admite enteros; Usa registros t0 t1 t2
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
    factorial_final: 
        # Resetear registros
        li t0 0
        li t1 0
        li t2 0
        jr ra			# Retorna a0

    
