.text
.syntax unified
.thumb

.thumb_func
	asm_GPS_unpack:
		// (int32_t *GPS_data, int16_t *GPS_Lat, int16_t *GPS_Long, uint16_t longitud)
		// Los parámetros van desde r0 a r3
		push {r4 - r5}           // Se resguardan los valores de los registros en el stack

		// Guarda de seguridad
		cbz r0, _exit1           // Salir si GPS_data es una dirección nula
		cbz r1, _exit1           // Salir si GPS_Lat es una dirección nula
		cbz r2, _exit1           // Salir si GPS_Long es una dirección nula
		cmp r3, #0
		ble _exit1	           // Salir si longitud es igual a cero o menor

		movw r5, #0xFFF // Mascara

	_loop:
		subs r3, #1
		bmi _exit1

		ldr r4, [r0, r3, LSL #2] // Cargo en Long
		and r4, r4, r5 // Hago AND a nivel bit. No es 100% necesario
		lsl r4, r4, #20 // Se desplazan los bits hacia arriba
		asr r4, r4, #20 // Se desplazan los bits hacia la derecha, conservando el signo
		strh r4, [r2, r3, LSL #1] // Guardo r4 en r2 usando r3 (longitud)

		ldr r4, [r0, r3, LSL #2] // Cargo en Lat
		lsr r4, r4, #12 // Muevo los bits hacia la derecha
		and r4, r4, r5 // Hago AND a nivel bit. No es 100% necesario
		lsl r4, r4, #20 // Se desplazan los bits hacia la ziquierda
		asr r4, r4, #20 // Se desplazan los bits hacia la derecha, conservando el signo
		strh r4, [r1, r3, LSL #1] // Guardo r4 en r1 usando r3 (longitud)

		b _loop

	_exit1:
		pop {r4 - r5}            // Se recuperan los valores de los registros
		bx lr


// uint32_t asm_max(int32_t *vectorIn, uint32_t longitud);
// r0 vectorIn
// r1 longitud

// Uso r3 para mantener la posicion actual
// Uso r2 para mantener el maximo actual
// Uso r4 para ir iterando
.thumb_func
	asm_max:
		push {r4}
		mov r3, #0 // Por las dudas, el valor máximo si no hay nada, es cero
		cbz r0, _exit2           // Salir si vectorIn es una dirección nula
		cmp r1, #0
		ble _exit2	           // Salir si longitud es igual a cero o menor

		sub r1, r1, #1 // Pongo el primer valor
		mov r3, r1 // Pongo la longitud en r3, posicion actual
		ldr r2, [r0, r1, LSL #2] // Valor actual = El ultimo del vector

	_loop2:
		subs r1, #1
		bmi _exit2
		ldr r4, [r0, r1, LSL #2] // Cargo en r4 el valor a comparar
		cmp r4, r2
		bgt _newMax

		b _loop2

	_newMax:
		mov r2, r4
		mov r3, r1
		b _loop2

	_exit2:
		mov r0, r3
		pop {r4}            // Se recuperan los valores de los registros
		bx lr

// void invertir(uint16_t *buffer, uint16_t longitud)
// r2, iterador creciente
// r3 limite = longitud / 2
// r4 = aux1
// r5 = aux2
.thumb_func
	asm_invertir:
		push {r4, r5}
		cbz r0, _exit3           // Salir si buffer es una dirección nula
		cmp r1, #0
		ble _exit3	           // Salir si longitud es igual a cero o menor

		mov r2, #0 // Pongo 0 para ir subiendo la posicion a reemplazar
		lsr r3, r1, #1 // Guardo condicion de fin en r3, divido por la mitad

	_loop3:
		sub r1, #1 // debo restar por 1 antes de arrancar
		cmp r1, r3 // si r1 es menor a longitud / 2, ya terminé
		bmi _exit3

		ldrh r4, [r0, r2, LSL #1] // cargo el primero en auxiliar
		ldrh r5, [r0, r1, LSL #1] // cargo en r5 el ultimo
		strh r4, [r0, r1, LSL #1]
		strh r5, [r0, r2, LSL #1]

		add r2, #1

		b _loop3


	_exit3:
		pop {r4, r5}
		bx lr



























