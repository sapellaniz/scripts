# Algoritmo de Floyd

Este pequeño programa permite aplicar el algoritmo de floyd a un grafo de hasta 9 vértices.
Si se quiere aplicar a un grafo mayor, se debe cambiar "matrix[9][9]" por "matrix[n][n]" donde "n" es el número de vértices.
En linux puede hacerse facilmente con el siguiente comando:
```
sed -i 's/\[9\]\[9\]/[n][n]/g' floyd.c
```

Para vértices no adyacentes se debe introducir un valor negativo, por ejemplo:

  dist(1,2) = -1
  
Para compilarlo simplemente:
```
gcc -o floyd floyd.c
```

Se puede usar en modo interactivo(pasar los datos al programa en tiempo de ejecución):
```
./floyd
```

O también se pueden pasar los datos al llamar al programa:
```
./floyd (vertices) (11 12 13 1n 21 22 23 2n n1 n2 n3 nn)
```
