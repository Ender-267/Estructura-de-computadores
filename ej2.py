import random
import math



elementos_validos = (-2, -2*math.pi, -1.5, -1.5 * math.pi, -1, -1 * math.pi, -0.5, -0.5 * math.pi
                    , 0.5, 0.5 * math.pi, 1, 1 * math.pi, 1.5, 1.5 * math.pi, 2, 2 * math.pi)

memoria = []
for i in range(0, 200): memoria.append(0)

direccion_a = 8
direccion_b = 116
n = 4
m = 3

i = 0
while i != m:
    j = 0
    while j != n:
        dire = direccion_a + (i * n + j) * 4
        # i: Columna j: Fila
        elementon = elementos_validos[random.randint(0, len(elementos_validos) - 1)]
        memoria[dire] = elementon
        memoria[dire + 1] = f"Asignado {memoria[dire]}"
        memoria[dire + 2] = f"Asignado {memoria[dire]}"
        memoria[dire + 3] = f"Asignado {memoria[dire]}"
        j += 1
    i += 1

def SinMatriz(direccion_a, direccion_b, n, m):
    i = 0
    while i != m:
        j = 0
        while j != n:
            # direccion_inicio + (i · n + j) × 4
            # i: Columna j: Fila
            inicial = i * n
            inicial += j
            inicial *= 4
            inicial += direccion_a
            calc = memoria[inicial]
            resultado = math.sin(calc)
            final = i * n
            final += j
            final *= 4
            final += direccion_b
            memoria[final] = resultado
            memoria[final + 1] = f"Asignado {memoria[inicial]}"
            memoria[final + 2] = f"Asignado {memoria[inicial]}"
            memoria[final + 3] = f"Asignado {memoria[inicial]}"
            j += 1
        i += 1

def t_print():
    for i in range(0, 200, 4):
        print(f"{hex(i)} : {memoria[i]}")



SinMatriz()
t_print()