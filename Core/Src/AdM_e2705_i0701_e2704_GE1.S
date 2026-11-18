/* ########################################################################## */
/*       Carrera de Especialización en Sistemas Embebidos (CESE) - FIUBA      */
/*       Materia: Arquitectura de Microcontroladores                          */
/*       Guía de Ejercicios 1 - Introducción a la programación en Assembly    */
/*       Alumnos: Carlos Andrés Restrepo, Nahuel Severini, Erik Hromek        */
/* ########################################################################## */

.text
.syntax unified
.thumb

/* ========================================================================== */
/* Exportación de funciones globales (visibles desde C)                       */
/* ========================================================================== */
.global asm_productoEscalar32
.global asm_productoEscalar12
.global asm_bitfield_clear
.global asm_bitfield_toggle


/* ========================================================================== */
/* Ejercicio 1                                                                */
/* ========================================================================== */
// Prototipo en C:
// void asm_productoEscalar32(uint32_t *vectorIn, uint32_t *vectorOut, uint16_t longitud, uint16_t escalar);
//
// Parámetros recibidos (estándar AAPCS):
//   r0: vectorIn  (puntero base al vector de entrada)
//   r1: vectorOut (puntero base al vector de salida)
//   r2: longitud  (cantidad de elementos)
//   r3: escalar   (valor multiplicador)
//
// Valor de retorno: void

.thumb_func
asm_productoEscalar32:
    // Se preservan r4 y r5 en la pila para cumplir con AAPCS (alineación a 8 bytes)
    push {r4, r5}

    // Guardas de seguridad para evitar punteros nulos o longitud cero
    cbz r0, _exit1              // Salir si vectorIn es NULL
    cbz r1, _exit1              // Salir si vectorOut es NULL
    cbz r2, _exit1              // Salir si la longitud es 0

_loop1:
    sub r2, #1                  // Decrementar índice (recorrido descendente)
    // LSL #2 multiplica el índice por 4 (tamaño de uint32_t en bytes)
    ldr r4, [r0, r2, LSL #2]    // r4 = vectorIn[r2]
    mul r4, r4, r3              // r4 = vectorIn[r2] * escalar
    str r4, [r1, r2, LSL #2]    // vectorOut[r2] = r4

    cbz r2, _exit1              // Si r2 llegó a 0, finalizó el recorrido
    b _loop1                    // Caso contrario, continuar iterando

_exit1:
    pop {r4, r5}                // Restaurar registros preservados
    bx lr                       // Retorno a la función llamadora


/* ========================================================================== */
/* Ejercicio 2                                                                */
/* ========================================================================== */
// Prototipo en C:
// void asm_productoEscalar12(uint16_t *vectorIn, uint16_t *vectorOut, uint16_t longitud, uint16_t escalar);
//
// Parámetros recibidos:
//   r0: vectorIn  (puntero base a elementos uint16_t)
//   r1: vectorOut (puntero base a elementos uint16_t)
//   r2: longitud  (cantidad de elementos)
//   r3: escalar   (valor multiplicador)
//
// Valor de retorno: void

.thumb_func
asm_productoEscalar12:
    push {r4, r5}               // Preservar registros en la pila

    // Guardas de seguridad
    cbz r0, _exit2              // Salir si vectorIn es NULL
    cbz r1, _exit2              // Salir si vectorOut es NULL
    cbz r2, _exit2              // Salir si la longitud es 0

_loop2:
    sub r2, #1                  // Decrementar índice
    // LSL #1 multiplica el índice por 2 (tamaño de uint16_t en bytes)
    ldrh r4, [r0, r2, LSL #1]   // Carga elemento de 16 bits sin signo
    mul r4, r4, r3              // Multiplica en 32 bits (r4 = elemento * escalar)
    usat r4, #12, r4            // Satura el resultado a 12 bits sin signo (rango 0 a 4095)
    strh r4, [r1, r2, LSL #1]   // Guarda media palabra (16 bits) saturada en vectorOut

    cbz r2, _exit2              // Finaliza si se procesó el último elemento (índice 0)
    b _loop2

_exit2:
    pop {r4, r5}                // Restaurar registros
    bx lr                       // Retorno


/* ========================================================================== */
/* Ejercicio 3                                                                */
/* ========================================================================== */
// Prototipo en C:
// uint32_t asm_bitfield_clear(uint32_t dato, uint32_t ancho, uint32_t inicio);
//
// Parámetros recibidos:
//   r0: dato original de 32 bits
//   r1: ancho del campo de bits
//   r2: posición inicial (LSB del campo)
//
// Valor de retorno:
//   r0: dato resultante con el campo de bits puesto a cero

.thumb_func
asm_bitfield_clear:
    // Guardas de seguridad (no requiere push/pop, solo se usan registros volátiles r0-r3)
    cbz r0, _exit3              // Si el dato es 0, el resultado ya es 0
    cbz r1, _exit3              // Si el ancho es 0, no se modifica el dato
    cmp r2, #31                 // Verifica que la posición de inicio no supere 31
    bhi _exit3                  // Si inicio > 31, salir sin modificar

    mov r3, #1                  // r3 = 1
    lsl r3, r1                  // r3 = 1 << ancho
    sub r3, #1                  // r3 = (1 << ancho) - 1 (máscara de 'ancho' unos)
    lsl r3, r2                  // r3 = máscara alineada con la posición 'inicio'
    mvn r3, r3                  // r3 = ~máscara (invierte: ceros en el campo, unos alrededor)
    and r0, r3                  // r0 = dato & ~máscara (pone a cero el campo)

_exit3:
    bx lr                       // Retorno con resultado en r0


/* ========================================================================== */
/* Ejercicio 4                                                                */
/* ========================================================================== */
// Prototipo en C:
// uint32_t asm_bitfield_toggle(uint32_t dato, uint32_t ancho, uint32_t inicio);
//
// Parámetros recibidos:
//   r0: dato original de 32 bits
//   r1: ancho del campo de bits
//   r2: posición inicial (LSB del campo)
//
// Valor de retorno:
//   r0: dato resultante con los bits del campo invertidos (toggle)

.thumb_func
asm_bitfield_toggle:
    // Guardas de seguridad
    cbz r1, _exit4              // Si el ancho es 0, no hay bits para invertir
    cmp r2, #31                 // Verifica que la posición de inicio no supere 31
    bhi _exit4                  // Si inicio > 31, salir sin modificar

    mov r3, #1                  // r3 = 1
    lsl r3, r1                  // r3 = 1 << ancho
    sub r3, #1                  // r3 = (1 << ancho) - 1 (máscara de 'ancho' unos)
    lsl r3, r2                  // r3 = máscara alineada con la posición 'inicio'
    eor r0, r0, r3              // r0 = dato ^ máscara (invierte los bits mediante XOR)

_exit4:
    bx lr                       // Retorno con resultado en r0
