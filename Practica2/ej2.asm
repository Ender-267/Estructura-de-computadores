.data
    a: .word 35, 15
    b: .word 10, 20
.text
no_ext:
        lw t0 0(a0)     # t0 = a real
        addi a0 a0 4      
        lw t1 0(a0)        # t1 = a imaginario

        lw t2 0(a1)     # t2 = b real
        addi a1 a1 4      
        lw t3 0(a1)        # t3 = b imaginario

        bne t0 t2 else_1  # if (a real = b real) y (a imaginario = b imaginario)
        bne t1 t3 else_1

        mul t5 t0 t2
        mul t6 t1 t3
        sub a0 t5 t6    # resultado real = t0 * t2 - t1 * t3
        
        mul t5 t0 t3    
        mul t6 t1 t2
        add a1 t5 t6    # resultado imaginario = t0 * t3 + t1 * t2

        j fin_1
    else_1:

        add a0 t0 t2    # resultado real = t0 + t2
        add a1 t1 t3    # resultado imaginario = t1 + t3

    fin_1: ret
with_ext:
        lw t0 0(a0)     # t0 = a real
        addi a0 a0 4      
        lw a0 0(a0)        # a0 = a imaginario

        lw t1 0(a1)     # t1 = b real
        addi a1 a1 4      
        lw a1 0(a1)        # a1 = b imaginario

        beqc t0 a0 t1 a1 8   # if a == b
        # Else
        addc t0 a0 t1 a1    # a + b
        j fin_2
        # Then
        mulc t0 a0 t1 a1    # a * b
    fin_2: 
        mv a0 t0
        mv a1 t1
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