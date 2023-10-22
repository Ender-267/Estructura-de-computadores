.data
	.align 2
# Constantes
error: .float 0.001
pi:	   .word 0x40490FDB
inf:   .word 0x7F800000
ninf:  .word 0xFF800000
# Pruebas
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
    fmv.s fs2 fs1           # -2
    fmv.s fa0 fs2
    jal ra sin
    fmv.s fa0 fs2
    jal ra cos
    fmv.s fa0 fs2
    jal ra tg
    fmul.s fs2 fs0 fs1      # -2pi
    fmv.s fa0 fs2
    jal ra sin
    fmv.s fa0 fs2
    jal ra cos
    fmv.s fa0 fs2
    jal ra tg

    la s1 prueba2
    flw fs1 0(s1)
    fmv.s fs2 fs1           # -1.5
    fmv.s fa0 fs2
    jal ra sin
    fmv.s fa0 fs2
    jal ra cos
    fmv.s fa0 fs2
    jal ra tg
    fmul.s fs2 fs0 fs1      # -1.5pi
    fmv.s fa0 fs2
    jal ra sin
    fmv.s fa0 fs2
    jal ra cos
    fmv.s fa0 fs2
    jal ra tg

    la s1 prueba3
    flw fs1 0(s1)
    fmv.s fs2 fs1           # -1
    fmv.s fa0 fs2
    jal ra sin
    fmv.s fa0 fs2
    jal ra cos
    fmv.s fa0 fs2
    jal ra tg
    fmul.s fs2 fs0 fs1      # -1pi
    fmv.s fa0 fs2
    jal ra sin
    fmv.s fa0 fs2
    jal ra cos
    fmv.s fa0 fs2
    jal ra tg

    la s1 prueba4
    flw fs1 0(s1)
    fmv.s fs2 fs1           # -0.5
    fmv.s fa0 fs2
    jal ra sin
    fmv.s fa0 fs2
    jal ra cos
    fmv.s fa0 fs2
    jal ra tg
    fmul.s fs2 fs0 fs1      # -0.5pi
    fmv.s fa0 fs2
    jal ra sin
    fmv.s fa0 fs2
    jal ra cos
    fmv.s fa0 fs2
    jal ra tg

    la s1 prueba5
    flw fs1 0(s1)
    fmv.s fs2 fs1           # -0
    fmv.s fa0 fs2
    fmv.s fa0 fs2
    jal ra sin
    fmv.s fa0 fs2
    jal ra cos
    fmv.s fa0 fs2
    jal ra tg

    la s1 prueba6
    flw fs1 0(s1)
    fmv.s fs2 fs1           # 0.5
    fmv.s fa0 fs2
    jal ra sin
    fmv.s fa0 fs2
    jal ra cos
    fmv.s fa0 fs2
    jal ra tg
    fmul.s fs2 fs0 fs1      # 0.5pi
    fmv.s fa0 fs2
    jal ra sin
    fmv.s fa0 fs2
    jal ra cos
    fmv.s fa0 fs2
    jal ra tg

    la s1 prueba7
    flw fs1 0(s1)
    fmv.s fs2 fs1           # 1
    fmv.s fa0 fs2
    jal ra sin
    fmv.s fa0 fs2
    jal ra cos
    fmv.s fa0 fs2
    jal ra tg
    fmul.s fs2 fs0 fs1      # 1pi
    fmv.s fa0 fs2
    jal ra sin
    fmv.s fa0 fs2
    jal ra cos
    fmv.s fa0 fs2
    jal ra tg

    la s1 prueba8
    flw fs1 0(s1)
    fmv.s fs2 fs1           # 1.5
    fmv.s fa0 fs2
    jal ra sin
    fmv.s fa0 fs2
    jal ra cos
    fmv.s fa0 fs2
    jal ra tg
    fmul.s fs2 fs0 fs1      # 1.5pi
    fmv.s fa0 fs2
    jal ra sin
    fmv.s fa0 fs2
    jal ra cos
    fmv.s fa0 fs2
    jal ra tg

    la s1 prueba9
    flw fs1 0(s1)
    fmv.s fs2 fs1           # 2
    fmv.s fa0 fs2
    jal ra sin
    fmv.s fa0 fs2
    jal ra cos
    fmv.s fa0 fs2
    jal ra tg
    fmul.s fs2 fs0 fs1      # 2pi
    fmv.s fa0 fs2
    jal ra sin
    fmv.s fa0 fs2
    jal ra cos
    fmv.s fa0 fs2
    jal ra tg



    # Finalizar programa
    li a7 10
    ecall
# Funciones solucion
sin: #sin(x); x = fa0
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


cos: #cos(x); x = fa0
    # ft0 y ft1 son usados por elevar()
    # ft7 = x
    # ft8 = 0.001; Error
    # ft9 = ra;
    # t0, t1, t2 son usados por elevar y factorial
    # t3 = n; variable contador
    # t4; Operaciones de sin con enteros
    # t5 = (2n)!
    # t6 = 2 y resultado de error
    # ft2; Resultado de formula para una determinada n
    # ft3; Resultado previo
    # ft4; Error
    # ft5; (2n)! en float
    # ft6; Resultado acumulativo (Final)
    # Inicializacion
	fmv.s ft7 fa0						# ft7 = fa0 = x
    la t0 error
    flw ft8 0(t0)						# ft8 = 0.001
    li t3 0                             # t3 = 0; Variable contador n
    cos_bucle:
        li t6 2                         # t6 = 2
        mul t4 t3 t6                    # t4 = t6 * t3 = 2n
        fmv.w.x ft9 ra					# Guardo la ra para futuras llamadas
        mv a0 t4                        # a0 = 2n
        jal ra factorial                # factorial(t4) => fa0 = (2n)!
        fmv.s ft5 fa0                   # Parametro fa0 = ft5 = (2n)!
        fmv.s fa0 ft7                   # fa0 = ft7 = x
        mv a0 t4                        # Parametro a0 = t4 = 2n
        jal ra elevar                   # elevar(x, 2n) => fa0 = x^(2n)
        fmv.x.w ra ft9
        # Pierdo valores de ft0 y ft1 al llamar a elevar()
        fmv.s ft2 fa0                   # ft2 = fa0 = x^(2n)
        fdiv.s ft2 ft2 ft5              # ft2 = ft2/ft5 =(x^(2n))/(2n)!
        rem t4 t3 t6                    # t4 = t3 % t6 = n % 2
        bne t4 zero cos_restar          # if n % 2 == 0:
        beq t4 zero cos_sumar
        cos_sumar: fadd.s ft6 ft6 ft2   # ft6 += ft2
      	j cos_condicional_fin
        cos_restar: fsub.s ft6 ft6 ft2  # ft6 -= ft2
        cos_condicional_fin:
        fsub.s ft4 ft6 ft3              # ft4 = ft2 - ft3; Error = resultado actual - resultado previo 
        fabs.s ft4 ft4                  # ft4 = |ft4|; error = |error|
        addi t3 t3 1                    # Incremento contador
        flt.s t6 ft4 ft8                # if error < 0.001:
        bne t6 zero cos_final           # break
        fmv.s ft3 ft6					# Resultado previo = resultado actual
        j cos_bucle                     # Bucle
    cos_final:
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


tg: #tg(x); fa0 = x    
    fmv.w.x ft11 ra                     # Guardar ra para otras llamadas
    fmv.s ft10 fa0                      # ft10 = x
    jal ra sin
    # Como no quedan registros ft libres, moveremos los resultados a la pila
    addi sp sp -4                      # Actualizar puntero de pila
    fsw fa0 0(sp)                       # Guardar sin(x)
    fmv.s fa0 ft10                      # fa0 = ft10 = x
    jal ra cos
    addi sp sp -4                      # Actualizar puntero de pila
    fsw fa0 0(sp)                      # Guardar cos(x)
    fmv.x.w ra ft11                    # Restaurar ra
    # Ahora que hay registros libres, sacamos todo de la pila
    flw ft0 0(sp)                       # ft0 = cos(x)
    addi sp sp 4
    flw ft1 0(sp)                       # ft1 = sen(x)
    addi sp sp 4
    la t1 error
    flw ft3 0(t1)                       # ft3 = 0.001
    fabs.s ft4 ft0                      # ft4 = |cos(x)|
    li t1 1                             # t1 = 1
    la t3 inf
    flw fa0 0(t3)                       # fa0 = +inf
    fmv.w.x ft2 zero                    # ft2 = 0
    # If |cos(x)| < 0.001 and sen(x) > 0: return inf
        flt.s t5 ft4 ft3                    # cos (x) < 0.001  
        flt.s t6 ft2 ft1                    # 0 < sen(x)
        beq t5 t1 tg_then_1                 # t1 == 1     
        j tg_if_2  
    # If cos(x) == 0 and sen(x) < 0: return -inf
    tg_if_2:
        la t3 ninf
        flw fa0 0(t3)                       # fa0 =-inf
        flt.s t5 ft4 ft3                    # cos (x) < 0.001   
        flt.s t6 ft1 ft2                    # sen(x) < 0
        beq t5 t1 tg_then_2                 # t1 == 1
        j tg_div

    tg_then_1:
        beq t5 t6 tg_final                      # t0 == t1 == 1
        j tg_if_2

    tg_then_2:
        beq t5 t6 tg_final                      # t0 == t1 == 1
        j tg_div

    tg_div:
        fdiv.s fa0 ft1 ft0                     # tg(x) = sin(x) / cos (x)
    tg_final:
        # reiniciar registros
        li t0 0
        li t1 0
        li t2 0
        li t3 0
        li t4 0
        li t5 0
        li t6 0
        fmv.w.x ft1 zero
        fmv.w.x ft2 zero
        fmv.w.x ft3 zero
        fmv.w.x ft4 zero
        fmv.w.x ft10 zero
        fmv.w.x ft11 zero
        jr ra                                   # return fa0



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