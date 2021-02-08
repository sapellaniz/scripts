#!/bin/bash
y=2		# Inicializar posicion del cursor
x=1
vel=3		# Inicializar velocidad de juego
v=0.5

SELEC_DIM(){ clear
             read -p 'Selecciona la dimension de la matriz (ej: 30x90): ' dim
             f=$(echo $dim | cut -d "x" -f1)
             c=$(echo $dim | cut -d "x" -f2)
             [[ $f -lt 15 ]] && read -n1 -p 'La dimension mínima es 15x15' pause && SELEC_DIM
             [[ $c -lt 15 ]] && read -n1 -p 'La dimension mínima es 15x15' pause && SELEC_DIM
             ymax=$(($f+1))		# Limites
             xmax=$(($c));}

INI(){ for (( n=1; n<=$f; n++ )); do	# Declarar muertas todas las celulas
           for i in $(seq $c); do
             index=$(($c*($n-1)+$i))
             celulas[$index]=·
           done
         done;}

TABLA(){ clear
         echo '___JUEGO DE LA VIDA___'
         echo -n '+'			# Margen superior
         for i in $(seq $c); do
           echo -n '-'
         done
         echo '+'
         for (( n=1; n<=$f; n++ )); do
           echo -n '|'			# Margen izquierdo
           for i in $(seq $c); do
             index=$(($c*($n-1)+$i))
             cell=celulas[$index]	# Células
             echo -n ${!cell}
           done
           echo '|'			# Margen derecho
         done
         echo -n '+'                    # Margen inferior
         for i in $(seq $c); do
           echo -n '-'
         done
         echo '+'
         echo 'CONTROLES:'		# Controles
         echo '  W = ARRIBA'
         echo '  S = ABAJO'
         echo '  A = IZQUIERDA'
         echo '  D = DERECHA'
         echo '  M = MARCAR'
         echo '  V = VELOCIDAD ('$vel')'
         echo '  E = EMPEZAR'
         echo '  P = PAUSE'
         echo '  Q = SALIR';}

INPUT(){ read -s -n1 key 2>/dev/null >&2        # Leer tecla pulsada
       [[ $key = w ]] && y=$(($y-1))            # Mover cursor
       [[ $key = s ]] && y=$(($y+1))
       [[ $key = d ]] && x=$(($x+1))
       [[ $key = a ]] && x=$(($x-1))
       [[ $key = m ]] && MARK $y $x             # Marcar casilla
       [[ $key = v ]] && VEL                    # Seleccionar velocidad
       [[ $key = e ]] && EMPEZAR                # Empezar
       [[ $key = q ]] && FIN                    # Salir
       [[ $y -lt 2 ]] && y=2                    # Limite vertical
       [[ $y -gt $ymax ]] && y=$ymax
       [[ $x -lt 1 ]] && x=1                    # Limite horizontal
       [[ $x -gt $xmax ]] && x=$xmax;}

POS_CUR(){ $(echo 'tput cup' $y $x);}		# Actualizar posicion del cursor

MARK(){ index=$((($1-2)*$c+$2))			# indice = (y-2)*c+x
        if [ $(eval echo '${celulas[$index]}') == · ]; then
          eval 'celulas[$index]="O"'
        else
          eval 'celulas[$index]="·"'
        fi
        TABLA;}

VEL(){ $(echo tput cup $(($ymax+12)) 4)
         echo 'SELECCIONA LA VELOCIDAD (1-5)'
         $(echo tput cup $(($ymax+12)) 33)
         read -s -n1 vel 2>/dev/null >&2
         if [[ $vel == 1 ]]; then v=0.1
         elif [[ $vel == 2 ]]; then v=0.25
         elif [[ $vel == 3 ]]; then v=0.5
         elif [[ $vel == 4 ]]; then v=1
         elif [[ $vel == 5 ]]; then v=2
         else echo ' ' && echo 'Caracter invalido' && VEL
         fi
         TABLA;}

FIN(){ $(echo tput cup $(($ymax+12)) 4)
         echo '¿SEGURO QUE QUIERES SALIR? (N/y)'
         $(echo tput cup $(($ymax+12)) 36)
         read -s -n1 key 2>/dev/null >&2
         [[ $key = y ]] && echo " " && exit
         TABLA;}

INI_VECINOS(){ for (( n=1; n<=$f; n++ )); do    # Eliminar informacion de rondas anteriores
                 for i in $(seq $c); do
                   index=$(($c*($n-1)+$i))
                   vecinos[$index]=0
                 done
               done;}

CALC_VECINOS(){ for (( n=1; n<=$f; n++ )); do    # Calcular vecinos de todas las celulas
                  for i in $(seq $c); do
                    index=$(($c*($n-1)+$i))
                    if [[ $index -gt $c ]]; then			# Fila superior (enmedio siempre)
                      if [[ $((($index-1)%$c)) -ne 0 ]]; then	# Superior izquierda
                        [[ $(eval echo '${celulas[$index-$(($c+1))]}') == O ]] && vecinos[$index]=$((${vecinos[$index]}+1))
                      fi
                      [[ $(eval echo '${celulas[$index-$c]}') == O ]] && vecinos[$index]=$((${vecinos[$index]}+1))
                      if [[ $((($index)%$c)) -ne 0 ]]; then		# Superior derecha
                        [[ $(eval echo '${celulas[$index-$(($c-1))]}') == O ]] && vecinos[$index]=$((${vecinos[$index]}+1))
                      fi
                    fi
                    if [[ $((($index-1)/$c)) -eq $((($index-2)/$c)) ]]; then	# Celula anterior
                      [[ $(eval echo '${celulas[$index-1]}') == O ]] && vecinos[$index]=$((${vecinos[$index]}+1))
                    fi
                    if [[ $((($index-1)/$c)) -eq $((($index)/$c)) ]]; then	# Celula siguiente
                      [[ $(eval echo '${celulas[$index+1]}') == O ]] && vecinos[$index]=$((${vecinos[$index]}+1))
                    fi
                    if [[ $((($index-1)/$c+1)) -lt $f ]]; then	# Fila inferior (enmedio siempre)
                      if [[ $((($index-1)%$c)) -ne 0 ]]; then	# Inferior izquierda
                        [[ $(eval echo '${celulas[$index+$(($c-1))]}') == O ]] && vecinos[$index]=$((${vecinos[$index]}+1))
                      fi
                      [[ $(eval echo '${celulas[$index+$c]}') == O ]] && vecinos[$index]=$((${vecinos[$index]}+1))
                      if [[ $((($index)%$c)) -ne 0 ]]; then		# Inferior derecha
                        [[ $(eval echo '${celulas[$index+$(($c+1))]}') == O ]] && vecinos[$index]=$((${vecinos[$index]}+1))
                      fi
                    fi
                  done
                done;}

REGLAS(){ for (( n=1; n<=$f; n++ )); do    # Declarar muertas todas las celulas
            for i in $(seq $c); do
              index=$(($c*($n-1)+$i))
              if [ $(eval echo '${celulas[$index]}') == · ]; then	# Regla si esta muerta
                [[ ${vecinos[$index]} -eq 3 ]] && eval 'celulas[$index]="O"'
              else							# Regla si esta viva
                [[ ${vecinos[$index]} -lt 2 ]] && eval 'celulas[$index]="·"'
                [[ ${vecinos[$index]} -gt 3 ]] && eval 'celulas[$index]="·"'
              fi
            done
          done
          TABLA
          read -t $v -n1 key
          [[ $key = q ]] && FIN
          [[ $key = p ]] && read -n1 -p 'Pulse cualquier tecla para continuar' pause;}

EMPEZAR(){ while true; do
	     INI_VECINOS
	     CALC_VECINOS
	     REGLAS
	   done;}

JUEGO(){ SELEC_DIM
         INI
         TABLA
         while true; do
           POS_CUR
           INPUT
         done;}

MENU(){ tput clear
        tput cup 2 7
        tput rev
        tput bold
        echo '_-GAME OF LIFE-_'
        tput cup 3 9
        echo '--M E N U--'
        tput sgr0
        tput cup 5 10
        echo "1. Jugar"
        tput cup 6 10
        echo "2- Informacion"
        tput cup 7 10
        echo "3- Salir"
        tput bold
        tput cup 15 0
        echo "GAME OF LIFE - Copyleft("$'\u0254'") 2020 Badbot Corporation. All rigths freed."
        tput bold
        tput cup 9 10
        read -n1 -p 'Elige una opcion [1-3] ' opcion
        [[ $opcion == 1 ]] && JUEGO
        [[ $opcion == 2 ]] && INFO
        [[ $opcion == 3 ]] && exit;}

INFO(){ clear
echo 'Se trata de un juego de cero jugadores, lo que quiere decir que su evolución está determinada por el estado'
echo 'inicial y no necesita ninguna entrada de datos posterior. El "tablero de juego" es una malla plana formada'
echo 'por cuadrados (las "células") que se extiende por el infinito en todas las direcciones. Por tanto, cada célula'
echo 'tiene 8 células "vecinas", que son las que están próximas a ella, incluidas las diagonales. Las células tienen'
echo 'dos estados: están "vivas" o "muertas" (o "encendidas" y "apagadas"). El estado de las células evoluciona a lo'
echo 'largo de unidades de tiempo discretas (se podría decir que por turnos). El estado de todas las células se tiene'
echo 'en cuenta para calcular el estado de las mismas al turno siguiente. Todas las células se actualizan'
echo 'simultáneamente en cada turno, siguiendo estas reglas:'
echo ' '
echo '    Una célula muerta con exactamente 3 células vecinas vivas "nace" (es decir, al turno siguiente estará viva).'
echo '    Una célula viva con 2 o 3 células vecinas vivas sigue viva, en otro caso muere (por "soledad" o "superpoblación").'
echo ' '
echo 'El juego de la vida es un automata celular diseñado por el matematico britanico John Horton Conway en 1970.'
echo 'Desde su publicación, ha atraído mucho interés debido a la gran variabilidad de la evolución de los patrones.'
echo 'Es interesante observar cómo patrones complejos pueden provenir de la implementación de reglas muy sencillas.'
echo 'La vida tiene una variedad de patrones reconocidos que provienen de determinadas posiciones iniciales. Destacan:'
echo '  - Osciladores'
echo '  - Vidas estaticas'
echo '  - Matusalenes'
echo '  - Naves espaciales'
echo '  - Pistolas'
echo '  - Criaderos'
echo ' '
echo 'El emblema hacker fue propuesto primero en octubre de 2003 por Eric S. Raymond, proviene de una nave espacial'
echo 'del Juego de la vida llamada planeador:'
echo '     +---+'
echo '     |·O·|'
echo '     |··O|'
echo '     |OOO|'
echo '     +---+'
echo 'Eric S. Raymond ha propuesto al planeador como un emblema para representar a los hackers porque:'
echo '    El planeador (Glider) "nació casi al mismo tiempo que el Internet y Unix".'
echo '    El Juego de la vida hace un llamamiento a los hackers.'
echo ' '
echo 'https://es.wikipedia.org/wiki/Juego_de_la_vida'
echo 'https://es.wikipedia.org/wiki/Emblema_hacker'
echo ' '
read -n1 -p 'Pulse una tecla para continuar'
MENU;}

MENU
