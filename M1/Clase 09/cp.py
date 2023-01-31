#Crear un función que retorne el cuadrado del valor ingresado
def cuadrado(numero):
   #Tu código acá

   return numero ** 2


#print(cuadrado(3))
import pandas as pd
df = pd.read_csv('datasets/Emisiones_CO2.csv', encoding='ANSI', sep='|')
print(df)