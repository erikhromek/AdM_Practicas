/*
 * c_functions.c
 *
 *  Created on: 12 nov 2026
 *      Author: erik
 */

#include "functions.h"

void productoEscalar12(uint16_t *vectorIn, uint16_t *vectorOut, uint16_t longitud, uint16_t escalar) {
	uint16_t MAX_VALUE = 4095;
	for (uint16_t i = longitud; i > 0; i--)
	{
		 vectorOut[i-1] = vectorIn[i-1] * escalar;
		 if (vectorOut[i-1] > MAX_VALUE)
			 vectorOut[i-1] = MAX_VALUE;
	}
}

uint32_t bitfield_toggle(uint32_t dato, uint32_t ancho, uint32_t inicio){
    uint32_t auxiliar = 1<<ancho;   // 1<<5  = 0000 0010 0000 (32 en decimal)
    auxiliar -= 1;                  // 32-1  = 0000 0001 1111
    auxiliar = auxiliar<<inicio;    // 31<<3 = 0000 1111 1000 (248 en decimal)
    auxiliar = dato^auxiliar;       // Se aplica operación "and" bit a bit

    // 11100010100 , inicio 2, ancho 3
    // 00000011100 mascara
    // 11100001000 resultado

    return auxiliar;                // Se devuelve resultado
}
