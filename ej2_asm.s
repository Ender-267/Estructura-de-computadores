SinMatrix: #a0 = A a1 = B a2 = N a3 = M
    li t4 0                             # t4; Contador i


    bucle_1: beq t4 a3 final_1
        li t5 0                         # t5; Contador j
        bucle_2: beq t5 a2 final_2 
            mul t6 t4 a2                # t6 = i * n
            add t6 t6 t5                # t6 = i * n + j
            li t0 4
            mul t6 t6 t0                # t6 = (i * n + j) * 4
            mv t0 t6                    # t0 = (i * n + j) * 4
            add t6 t6 a0                # t6 = A + (i*n + j) * 4
            flw fa0 0(t6)               # Pasamos parametro
            # Guardamos todos los valores que seran sobreescritos por sin() en la pila
            sw a0 0(sp)
            addi sp sp -4
            sw ra 0(sp)
            addi sp sp -4
            sw t4 0(sp)
            addi sp sp -4
            sw t5 0(sp)
            addi sp sp -4
            sw t0 0(sp)
            addi sp sp -4

            jal ra sin                  # Seno de la palabra en (i*n + j)*4
            # Restauramos valores
            addi sp sp 4
            lw t0 0(sp)
            addi sp sp 4
            lw t5 0(sp)
            addi sp sp 4
            lw t4 0(sp)
            addi sp sp 4
            lw ra 0(sp)
            addi sp sp 4
            lw a0 0(sp)

            add t6 t0 a1                # t6 = B + (i*n + j) * 4
            fsw fa0 0(t6)                # Guardamos el resultado en memoria
            addi t5 t5 1                # j = j + 1
            j bucle_2
        final_2:
        addi t4 t4 1
        j bucle_1
    final_1:
    # Resetear registros
    li a0 0
    li a1 0
    li a2 0
    li a3 0
    li t0 0
    li t4 0
    li t5 0
    li t1 0
    li t6 0
    jr ra
    

# Funciones auxiliares
sin: #sin(x); x = fa0
    # ft0 y ft1 son usados por elevar()
    # ft7 = x
    # ft8 = 0.0001; Error (Usamos error menor que el pedido para el calculo de la tangente)
    # ft9 = ra;
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
    li t0 0x38D1B717                    # t0 = float(0.0001)
    fmv.w.x ft8 t0						# ft8 = 0.0001
    li t3 0                             # t3 = 0; Variable contador n
    sin_bucle:
        li t6 2                         # t6 = 2
        mul t4 t3 t6                    # t4 = t6 * t3 = 2n
        addi t4 t4 1                    # t4 = t4 + 1 = 2n + 1
        fmv.w.x ft9 ra					# Guardo la ra para futuras llamadas
        mv a0 t4                        # a0 = 2n+1
        jal ra factorial                # factorial(t4) => fa0 = (2n+1)!
        fmv.s ft5 fa0                   # Parametro fa0 = ft5 = (2n+1)!
        fmv.s fa0 ft7                   # fa0 = ft7 = x
        mv a0 t4                        # Parametro a0 = t4 = 2n+1
        jal ra elevar                   # elevar(x, 2n+1) => fa0 = x^(2n+1)
        fmv.x.w ra ft9
        # Pierdo valores de ft0 y ft1 al llamar a elevar()
        fmv.s ft2 fa0                   # ft2 = fa0 = x^(2n+1)
        fdiv.s ft2 ft2 ft5              # ft2 = ft2/ft5 =(x^(2n+1))/(2n+1)!
        rem t4 t3 t6                    # t4 = t3 % t6 = n % 2
        bne t4 zero sin_restar          # if n % 2 == 0:
        beq t4 zero sin_sumar
        sin_sumar: fadd.s ft6 ft6 ft2   # ft6 += ft2
      	j sin_condicional_fin
        sin_restar: fsub.s ft6 ft6 ft2  # ft6 -= ft2
        sin_condicional_fin:
        fsub.s ft4 ft6 ft3              # ft4 = ft2 - ft3; Error = resultado actual - resultado previo 
        fabs.s ft4 ft4                  # ft4 = |ft4|; error = |error|
        addi t3 t3 1                    # Incremento contador
        flt.s t6 ft4 ft8                # if error < 0.0001:
        bne t6 zero sin_final           # break
        fmv.s ft3 ft6					# Resultado previo = resultado actual
        j sin_bucle                     # Bucle
    sin_final:
        fmv.s fa0 ft6                   # Return ft6
        # Resetear registros
        li a0 0
        li t0 0
        li t1 0
        li t2 0
        li t6 0
        fmv.w.x ft9 zero
        fmv.w.x ft1 zero
        fmv.w.x ft2 zero
        fmv.w.x ft3 zero
        fmv.w.x ft4 zero
        fmv.w.x ft5 zero
        fmv.w.x ft6 zero
        fmv.w.x ft7 zero
        fmv.w.x ft8 zero
        jr ra                           # Return
elevar: #x^n; x = fa0; n = a0; Solo admite positivos y n enteros; Usa registros t0 t1 ft0 ft1
	mv t0 a0							# t0 = n
    # Si n = 0 return 1
    li t1 1
    fcvt.s.w ft1 t1
    beq t0 zero elevar_final
    fmv.s ft0 fa0						# ft0 = x; constante
    fmv.s ft1 fa0						# ft1 = x; solucion
    # Bucle
    elevar_bucle: 					
    	beq t0 t1 elevar_final			# While t0 != 1:
        addi t0 t0 -1					# t0 -= 1
        fmul.s ft1 ft1 ft0				# ft1 *= ft0
        j elevar_bucle
    elevar_final:
        fmv.s fa0 ft1                       #return ft1
        # Resetear registros temporales
        li a0 0
        li t0 0
        li t1 0
        fmv.w.x ft0 zero
        fmv.w.x ft1 zero
        jr ra
factorial: #x!; a0 = x Solo admite enteros; Usa registros t0 t1 t2 ft0
	mv t0 a0 						    # t0 = x
    # Retorna 1 si x = 0
    li a0 1
    fcvt.s.w fa0 a0
    beq t0 zero factorial_final
    mv t1 t0						    # t1 variable contador n; t1 = x
    li t2 1							    # Numero de final de bucle
    mv a0 t0						    # Inicializar retorno a x
    fcvt.s.w fa0 a0                     # fa0 = a0 para evitar desbordamientos
    factorial_bucle:
    	beq t2 t1 factorial_final	    # While n != 1:
        addi t1 t1 -1				    # Restar contador n -= 1
        fcvt.s.w ft0 t1                 # ft0 = t1 = n para evitar desbordamientos
        fmul.s fa0 fa0 ft0				# fa0 = fa0 * ft0; retorno = retorno * n
        j factorial_bucle
    factorial_final: 
        # Resetear registros
        li a0 0
        li t0 0
        li t1 0
        li t2 0
        fmv.w.x ft0 zero
        jr ra			# Retorna fa0