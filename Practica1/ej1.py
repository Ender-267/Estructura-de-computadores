import math


class Main:
    def sin(self, x: float) -> float:
        ans_actual = 0
        ans_previa = 0
        error = 0
        error_permitido = 0.0001
        n = 0
        while True:
            operacion1 = 2 * n #2n
            operacion2 = operacion1 + 1 #2n+1
            operacion3 = self.factorial(operacion2) #(2n+1)!
            operacion4 = self.elevar(x, operacion2) # x^(2n+1)
            operacion5 = operacion4/operacion3 # Fraccion
            if n % 2 == 0: #(-1)^n
                ans_actual += operacion5
            else:
                ans_actual -= operacion5
            error = abs(ans_actual - ans_previa)
            if error < error_permitido: break
            ans_previa = ans_actual
            n += 1
        return ans_actual
    
    def cos(self, x: float) -> float:
        ans_actual = 0
        ans_previa = 0
        error = 0
        error_permitido = 0.0001
        n = 0
        while True:
            operacion1 = 2 * n #2n
            operacion2 = self.factorial(operacion1) #(2n)!
            operacion3 = self.elevar(x, operacion1)
            operacion4 = operacion3/operacion2
            if n % 2 == 0: #(-1)^n
                ans_actual += operacion4
            else:
                ans_actual -= operacion4
            n += 1
            error = abs(ans_actual - ans_previa)
            if error < error_permitido: break
            ans_previa = ans_actual
        return ans_actual
    
    def tg(self, x: float) -> float:
        if abs(self.cos(x)) < 0.0001: return float('inf')
        return self.sin(x)/self.cos(x)
    
    def e(self) -> float:
        ans_actual = 0
        ans_previa = 0
        error = 0
        error_permitido = 0.001
        n = 0
        while True:
            operacion1 = self.factorial(n) # n!
            operacion2 = 1/operacion1
            ans_actual += operacion2
            n += 1
            error = abs(ans_actual - ans_previa)
            if error < error_permitido: break
            ans_previa = ans_actual
        return ans_actual
            

    @staticmethod
    def elevar(x: int, n: int) -> int:
        if n == 0:
            return 1
        ans = x
        while n > 1:
            ans *= x
            n -= 1
        return ans

    @staticmethod
    def factorial(x: int) -> int:
        if x == 0:
            return 1
        n = x
        mult = x
        while n != 1:
            n -= 1
            mult *= n
        return mult


class Test(Main):

    @staticmethod
    def frange(start: float, stop: float, step : float = 1) -> tuple:
        i = start
        lista = []
        while i < stop:
            i = round(i, 4)
            lista.append(i)
            i += step

        return tuple(lista)

    def test_elevar(self):
        print("Test elevar: ")
        for i in self.frange(0, 10, 0.1):
            for j in range(0, 10):
                esp = round(i**j, 4)
                res = round(self.elevar(i, j), 4)
                print(f"{i}^{j} Esperado: {esp} Real: {res}, {esp == res}")
        return

    def test_factorial(self, inicial: int, final: int) -> None:
        print("Test de factorial: ")
        for i in range(inicial, final + 1):
            esp = math.factorial(i)
            res = self.factorial(i)
            print(f"{i}! Esperado: {esp} Resultado: {res}, {esp == res}")
        return

    def test_sin(self, inicial: int, final: int) -> None:
        print("Test de seno: ")
        for i in self.frange(inicial, final, 0.1):
            esp = round(math.sin(i), 4)
            res = round(self.sin(i), 4)
            print(f"Sen({i}) Esperado: {esp} Resultado: {res}, {esp + 0.001 >= res >= esp - 0.001}")
        return
    
    def test_cos(self, inicial: int, final: int) -> None:
        print("Test de coseno: ")
        for i in self.frange(inicial, final, 0.1):
            esp = round(math.cos(i), 4)
            res = round(self.cos(i), 4)
            print(f"Cos({i}) Esperado: {esp} Resultado: {res}, {esp + 0.001 >= res >= esp - 0.001}")
        return
    
    def test_tg(self, inicial: int, final: int) -> None:
        print("Test de tangente: ")
        for i in self.frange(inicial, final, 0.1):
            esp = round(math.tan(i), 4)
            res = round(self.tg(i), 4)
            print(f"Tg({i}) Esperado: {esp} Resultado: {res}, {esp + 0.001 >= res >= esp - 0.001}")
        return
    
    def test_e(self) -> None:
        print("Test de e: ")
        esp = 2.718
        res = round(self.e(), 3)
        print(f"Esperado: {esp} Resultado: {res}, {esp == res}")
        return


# Test.test_factorial(Test(), 1, 10)
# Test.test_elevar(Test())
# Test.test_sin(Test(), -10, 10)
# Test.test_cos(Test(), -10, 10)
# Test.test_tg(Test(), -10, 10)
# Test.test_e(Test())
print(Main.factorial(13))

