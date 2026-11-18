/*
 * functions.h
 *
 *  Created on: 12 nov 2026
 *      Author: erik
 */

#ifndef INC_FUNCTIONS_H_
#define INC_FUNCTIONS_H_

#include "inttypes.h"

/* Funciones en implementadas en C */
void productoEscalar12(uint16_t *vectorIn, uint16_t *vectorOut, uint16_t longitud, uint16_t escalar);
uint32_t bitfield_toggle(uint32_t dato, uint32_t ancho, uint32_t inicio);

/* Funciones implementadas en Assembly*/
void asm_productoEscalar12(uint16_t *vectorIn, uint16_t *vectorOut, uint16_t longitud, uint16_t escalar);
uint32_t asm_bitfield_toggle(uint32_t dato, uint32_t ancho, uint32_t inicio);

#endif /* INC_FUNCTIONS_H_ */
