.data
    a: .word 35, 15
    b: .word 10, 20
.text
no_ext:
        lw t0 0(a0)     # t0 = a real     
        lw t1 4(a0)     # t1 = a imaginario

        lw t2 0(a1)     # t2 = b real      
        lw t3 4(a1)     # t3 = b imaginario

        beq t0 t2 con_1  # if (a real = b real) y (a imaginario = b imaginario)
        j else_1
    con_1:
        beq t1 t3 then_1
    else_1:
        add a0 t0 t2    # resultado real = t0 + t2
        add a1 t1 t3    # resultado imaginario = t1 + t3
        j fin_1
    then_1:
        mul t5 t0 t2
        mul t6 t1 t3
        sub a0 t5 t6    # resultado real = t0 * t2 - t1 * t3
        
        mul t5 t0 t3    
        mul t6 t1 t2
        add a1 t5 t6    # resultado imaginario = t0 * t3 + t1 * t2

    fin_1: jr ra
with_ext:
        mv t0 a1
        lc a0 a1 a0         # a0 = a real; a1 = a imaginario
        lc t0 t1 t0         # t0 = b real; t1 = b imaginario

        beqc a0 a1 t0 t1 then_2   # if a == b
        # Else
        addc a0 a1 t0 t1    # a + b
        j fin_2
    then_2:
        mulc a0 a1 t0 t1    # a * b
    fin_2: 
        ret

main: 
        rdcycle s0
        la a0, a
        la a1, b
        call with_ext
        #break:
        rdcycle s1
        sub s1 s1 s0
        rdcycle s0
        la a0, a
        la a1, b
        call no_ext
        #break:
        rdcycle s2
        sub s2 s2 s0
        hcf