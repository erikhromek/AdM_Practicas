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
		ble _exit1	           // Salir si longitud es igual a cero

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
