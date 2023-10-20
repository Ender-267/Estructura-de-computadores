.data
.text
main:
	li a0 0
    jal ra factorial
    # Finalizar programa
    li a7 10
    ecall
# Funciones solucion
# Funciones auxiliares
elevar: #x^n; x = a0; n = a1; Solo admite enteros positivos
	mv t0 a0 						# t0 = x
    mv t1 a1 						# t1 = n
    # retorna 1 si n = 0
    li a0 1 
    beq t1 zero elevar_final
    li t2 1 						# Numero de final de bucle
    # t1 es variable contador n
    mv a0 t0 						# Inicializar retorno a x
	elevar_bucle:
    	beq t2 t1 elevar_final 		# While n != 1:
        mul a0 a0 t0 				# a0 = a0 * t0; retorno = retorno * x
        addi t1 t1 -1 				# Restar contador n -= 1
        j elevar_bucle 
    elevar_final: jr ra 			# Retorna a0
factorial: #x!; a0 = x
	mv t0 a0 						# t0 = x
    # Retorna 1 si x = 0
    li a0 1
    beq t0 zero factorial_final
    mv t1 t0						# t1 variable contador n; t1 = x
    li t2 1							# Numero de final de bucle
    mv a0 t0						# Inicializar retorno a x
    factorial_bucle:
    	beq t2 t1 factorial_final	# While n != 1:
        addi t1 t1 -1				# Restar contador n -= 1
        mul a0 a0 t1				# a0 = a0 * t1; retorno = retorno * n
        j factorial_bucle
    factorial_final: jr ra			# Retorna a0
    
