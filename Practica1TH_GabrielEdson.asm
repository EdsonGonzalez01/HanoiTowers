# Practica Torres de Hanoi
#Gabriel Olvera, Edson Gonzalez 

.text
	addi t0, zero, 1 # Variable para comparar n !== 1
	addi s0, zero, 11 # Número total de discos "n"
	addi t1, zero, 0 # Variable temporal para almacenar apuntador durante el intercambio
	
	#create memory for arrays
	lui a3, 0x10010
	slli t6, s0, 2
	add a4, a3, t6
	add a5, a4, t6
	add t5, zero, s0
	
	
for:	beqz t5, hanoiTower
	sw t5, 0(a3)
	addi a3, a3, 4
	addi t5, t5, -1
	jal for
	lui a3, 0x10010

hanoiTower: bne s0, t0, loop # Caso base para la recursión
	# Ejecutar movimiento de disco de INICIO a DESTINO
	addi a3, a3, -4 # Avanzar a la posición anterior del disco en la torre A
	lw t5, 0(a3) # Cargar el disco actual de la torre A en una variable temporal
	sw zero, 0(a3) # Colocar un cero en la posición del disco en la torre A
	sw t5, 0(a5) # Guardar el disco en la torre C
	addi a5, a5, 4 # Mover a la siguiente posición en la torre C
	jalr ra # Retornar
loop:	addi sp, sp, -8 # Reservar espacio en la pila para almacenar la dirección de retorno
	sw ra, 4(sp) # Guardar el registro de dirección de retorno en la pila
	sw s0, 0(sp) # Guardar el número de discos en la pila
	
	# Intercambio de variables
	addi t1, a4, 0 # Almacenar el apuntador de la torre auxiliar (B) en una variable temporal
	addi a4, a5, 0 # Cambiar el apuntador AUXILIAR -> DESTINO
	addi a5, t1, 0 # Cambiar el apuntador DESTINO -> AUXILIAR
	addi s0, s0, -1 # Decrementar el número de discos para la siguiente llamada
	
	jal hanoiTower # Llamada recursiva
	
	# Cambiar manualmente los apuntadores para regresar a la llamada anterior
	addi t1, a4, 0 # Almacenar en una variable temporal el apuntador de la torre C
	addi a4, a5, 0 # Restaurar el valor de C a su apuntador original
	addi a5, t1, 0 # Restaurar el valor de B a su apuntador original
	
	# Movimiento de disco
	addi a3, a3, -4 # Avanzar a la posición anterior del disco en la torre A
	lw t5, 0(a3) # Cargar el disco actual de la torre A en una variable temporal
	sw zero, 0(a3) # Colocar un cero en la posición del disco en la torre A
	sw t5, 0(a5) # Guardar el disco en la torre C
	addi a5, a5, 4 # Mover a la siguiente posición en la torre C
	
	# Intercambio para la segunda llamada del árbol recursivo
	addi t1, a3, 0 # Almacenar en una variable temporal el apuntador de la torre A
	addi a3, a4, 0 # Cambiar los apuntadores de INICIO -> AUXILIAR
	addi a4, t1, 0 # Cambiar los apuntadores de AUXILIAR -> INICIO
	
	jal hanoiTower # Llamada recursiva
	
	# Cambiar manualmente los apuntadores para regresar a la llamada anterior
	addi t1, a3, 0
	addi a3, a4, 0
	addi a4, t1, 0
	
	lw s0, 0(sp) # Recuperar el valor original de n (número de discos) de la pila
	lw ra, 4(sp) # Recuperar la dirección de retorno para las llamadas restantes de la pila
	addi sp, sp, 8 # Mover el apuntador del stack
	
	jalr ra # Retornar
	
exit:
	nop # terminar 
