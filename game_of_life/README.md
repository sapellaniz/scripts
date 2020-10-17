# GAME OF LIFE
Juego de la vida de John Horton Conway de 1970.

Se trata de un juego de cero jugadores, lo que quiere decir que su evolución está determinada por el estado inicial y no necesita ninguna entrada de datos posterior. El "tablero de juego" es una malla plana formada por cuadrados (las "células") que se extiende por el infinito en todas las direcciones. Por tanto, cada célula tiene 8 células "vecinas", que son las que están próximas a ella, incluidas las diagonales. Las células tienen dos estados: están "vivas" o "muertas" (o "encendidas" y "apagadas"). El estado de las células evoluciona a lo largo de unidades de tiempo discretas (se podría decir que por turnos). El estado de todas las células se tiene en cuenta para calcular el estado de las mismas al turno siguiente. Todas las células se actualizan simultáneamente en cada turno, siguiendo estas reglas:

  - Una célula muerta con exactamente 3 células vecinas vivas "nace" (es decir, al turno siguiente estará viva).
  - Una célula viva con 2 o 3 células vecinas vivas sigue viva, en otro caso muere (por "soledad" o "superpoblación").
  
Es interesante observar cómo patrones complejos pueden provenir de la implementación de reglas muy sencillas.
La vida tiene una variedad de patrones reconocidos que provienen de determinadas posiciones iniciales. Destacan:

  - Osciladores.
  - Vidas estáticas.
  - Matusalenes.
  - Naves espaciales.
  - Pistolas.
  - Criaderos.
  
El emblema hacker fue propuesto primero en octubre de 2003 por Eric S. Raymond, proviene de una nave espacial
del Juego de la vida llamada planeador:
     
 ![alt text](https://github.com/s4nt4t3cl4/game_of_life/blob/master/emblema%20hacker?raw=true)

Eric S. Raymond ha propuesto al planeador como un emblema para representar a los hackers porque:

  - El planeador (Glider) "nació casi al mismo tiempo que el Internet y Unix".
  - El Juego de la vida hace un llamamiento a los hackers.

https://es.wikipedia.org/wiki/Juego_de_la_vida

https://es.wikipedia.org/wiki/Emblema_hacker
