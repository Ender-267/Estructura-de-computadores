.data
	.align 2
error: .float 0.001
pi:	   .word 0x40490FDB
prueba1: .float -2
prueba2: .float -1.5
prueba3: .float -1
prueba4: .float -0.5
prueba5: .float 0
prueba6: .float 0.5
prueba7: .float 1
prueba8: .float 1.5
prueba9: .float 2

.text
main:
# Pruebas (usar breaks)
    la s0 pi
    flw fs0 0(s0)	# pi

    la s1 prueba1
    flw fs1 0(s1)
    fmv.s fa0 fs1           # -2
    jal ra sin
    fmul.s fa0 fs0 fs1      # -2pi
    jal ra sin

    la s1 prueba2
    flw fs1 0(s1)
    fmv.s fa0 fs1           # -1.5
    jal ra sin
    fmul.s fa0 fs0 fs1      # -1.5pi
    jal ra sin

    la s1 prueba3
    flw fs1 0(s1)
    fmv.s fa0 fs1           # -1
    jal ra sin
    fmul.s fa0 fs0 fs1      # -1pi
    jal ra sin

    la s1 prueba4
    flw fs1 0(s1)
    fmv.s fa0 fs1           # -0.5
    jal ra sin
    fmul.s fa0 fs0 fs1      # -0.5pi
    jal ra sin

    la s1 prueba5
    flw fs1 0(s1)
    fmv.s fa0 fs1           # 0
    jal ra sin
    fmul.s fa0 fs0 fs1      # 0pi
    jal ra sin

    la s1 prueba6
    flw fs1 0(s1)           # 0.5
    fmv.s fa0 fs1           
    jal ra sin
    fmul.s fa0 fs0 fs1      # 0.5pi
    jal ra sin

    la s1 prueba7
    flw fs1 0(s1)
    fmv.s fa0 fs1           # 1
    jal ra sin
    fmul.s fa0 fs0 fs1      # 1pi
    jal ra sin

    la s1 prueba8
    flw fs1 0(s1)
    fmv.s fa0 fs1           # 1.5
    jal ra sin
    fmul.s fa0 fs0 fs1      # 1.5pi
    jal ra sin

    la s1 prueba9
    flw fs1 0(s1)           # 2
    fmv.s fa0 fs1
    jal ra sin
    fmul.s fa0 fs0 fs1      # 2pi
    jal ra sin



    # Finalizar programa
    li a7 10
    ecall
# Funciones solucion
sin: #sin(x)
    # ft0 y ft1 son usados por elevar()
    # ft7 = x
    # ft8 = 0.001; Error
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
    la t0 error
    flw ft8 0(t0)						# ft8 = 0.001
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
        flt.s t6 ft4 ft8                # if error < 0.001:
        bne t6 zero sin_final           # break
        fmv.s ft3 ft6					# Resultado previo = resultado actual
        j sin_bucle                     # Bucle
    sin_final:
        fmv.s fa0 ft6                   # Return ft6
        # Resetear registros
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




# Funciones auxiliares
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
        li t0 0
        li t1 0
        fmv.w.x ft0 zero
        fmv.w.x ft1 zero
        jr ra
factorial: #x!; a0 = x Solo admite enteros; Usa registros t0 t1 t2 ft0
	mv t0 a0 						    # t0 = x
    # Retorna 1 si x = 0
    li a0 1
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
        li t0 0
        li t1 0
        li t2 0
        fmv.w.x ft0 zero
        jr ra			# Retorna fa0