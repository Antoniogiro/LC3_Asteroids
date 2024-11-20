.ORIG x3000    

LD R1, PANTALLA_INICIO 
LD R2, #0

CARGAR_ARRAY_AST   ; cargo en R4 las direcciones de todos los ASTEROIDES
	LD R4, ASTEROIDES; ARRAY coordenadas posicion ASTEROIDES
	LD R5, ASTEROIDE_1
	STR R5, R4, #0
    ;---------
	LD R5, ASTEROIDE_2
	ADD R4, R4, #1
	STR R5, R4, #0
    ;---------
	LD R5, ASTEROIDE_3
	ADD R4, R4, #1
	STR R5, R4, #0
    ;---------
	LD R5, ASTEROIDE_4
	ADD R4, R4, #1
	STR R5, R4, #0
	; suma para ir al inicio del ARRAY

CARGAR_MOV_AST_X
	LEA R2, MOVIMIENTOS_X
	LD R6, UNO 
	STR R6, R2, #0
	;---------
	ADD R2, R2, #1
	STR R6, R2, #0
	;---------
	LD R6, CERO
	ADD R2, R2, #1
	STR R6, R2, #0
	;---------
	LD R6, MENOS_UNO
	ADD R2, R2, #1
	STR R6, R2, #0

CARGAR_MOV_AST_Y
	LEA R2, MOVIMIENTOS_Y
	LD R6, ANCHO_PANTALLA 
	STR R6, R2, #0
	;---------
	LD R6, CERO
	ADD R2, R2, #1
	STR R6, R2, #0
	;---------
	LD R6, ANCHO_PANTALLA
	ADD R2, R2, #1
	STR R6, R2, #0
	;---------
	LD R6, ANCHO_PANTALLA_N
	ADD R2, R2, #1
	STR R6, R2, #0

LD R6, POSICION_INICIAL
JSR DRAW_NAVE               ; Dibujar nave en posicion incial (hacia arriba)

MAIN_LOOP
    JSR ASTEROIDE_CONTROLLER
    JSR READ_INPUT         ; Leer la entrada del teclado
    JSR MOVE_NAVE
    JSR DRAW_NAVE
    AND R0, R0, #0
	BR MAIN_LOOP           ; Repetir el bucle principal

ASTEROIDE_CONTROLLER
    LD R1, CANT_ASTEROIDES
	ADD R4, R4, #-4   ; vuelvo al inicio del ARRAY de ASTEROIDES
	AND R6, R6, #0    ; inicializo R6 a cero para elegir el desplazamiento indicado para cada ASTEROIDE
    LD R0, RESPALDO_R0
    ASTEROIDE_LOOP
        ADD R4, R4, #1	; cambio de asteroide al que desplazo
        LDR R0, R4, #0
        ST R0, ASTEROIDE_UBI
        LD R0, ASTEROIDE_UBI
        LD R3, UNO
        JSR BORRAR_ASTEROIDE
        LEA R2, MOVIMIENTOS_Y
        ADD R2, R2, R6
        LDR R2, R2, #0
        Y_LOOP
            ADD R0, R0, R2
            ADD R3, R3, #-1
            BRp Y_LOOP
        LD R3, UNO
        LEA R2, MOVIMIENTOS_X
        ADD R2, R2, R6
        LDR R2, R2, #0
        X_LOOP
            ADD R0, R0, R2
            ADD R3, R3, #-1
            BRp X_LOOP
        JSR DIBUJAR_ASTEROIDE
        JSR WAIT
        STR R0, R4, #0
        ADD R6, R6, #1
        ADD R1, R1, #-1
        BRp ASTEROIDE_LOOP
        RET

MOVE_NAVE
    ST	R0, DSH_R0	       ;Respaldo de registros
    ST	R1, DSH_R1
    ST	R2, DSH_R2
    ST	R3, DSH_R3
    ST	R4, DSH_R4
    ST	R5, DSH_R5
    ST	R6, DSH_R6
    ST	R7, DSH_R7

    LD R3, up_key          ; Cargar la tecla 'W'
    ADD R3, R3, R0
    BRz MOVE_UP

    LD R3, down_key        ; Cargar la tecla 'S'
    ADD R3, R3, R0
    BRz MOVE_DOWN

    LD R3, left_key        ; Cargar la tecla 'A'
    ADD R3, R3, R0
    BRz MOVE_LEFT

    LD R3, right_key       ; Cargar la tecla 'D'
    ADD R3, R3, R0
    BRz MOVE_RIGHT

    LD	R0, DSH_R0	;;Vuelta atras de los registros
    LD	R1, DSH_R1
    LD	R2, DSH_R2
    LD	R3, DSH_R3
    LD	R4, DSH_R4
    LD	R5, DSH_R5
    LD	R6, DSH_R6
    LD	R7, DSH_R7
    
    RET                    ; Si no es una tecla de movimiento, regresar
MOVIMIENTOS_X   .BLKW 4
MOVIMIENTOS_Y   .BLKW 4
ANCHO_PANTALLA .FILL #128 
ANCHO_PANTALLA_N .FILL #-128 
ASTEROIDES		.BLKW 4
ASTEROIDE_1 .FILL xC900
ASTEROIDE_2 .FILL xE000 
ASTEROIDE_3 .FILL xC060
ASTEROIDE_4 .FILL xEE70
CERO            .FILL #0
UNO		.FILL #1
MENOS_UNO       .FILL #-1
CANT_ASTEROIDES .FILL #4
COLOR_NEGRO       .FILL x0000
POSICION_INICIAL  .FILL xDF40
PANTALLA_INICIO   .FILL xC000
ASTEROIDE_UBI	.BLKW 1
up_key .FILL #-119            ; Tecla 'W' para subir
down_key .FILL #-115          ; Tecla 'S' para bajar
left_key .FILL #-97           ; Tecla 'A' para mover a la izquierda
right_key .FILL #-100         ; Tecla 'D' para mover a la derecha

;;Respaldo de registros		
DSH_R0		.FILL 1
DSH_R1		.FILL 1
DSH_R2		.FILL 1
DSH_R3		.FILL 1
DSH_R4		.FILL 1
DSH_R5		.FILL 1
DSH_R6		.FILL 1
DSH_R7		.FILL 1

MOVE_UP
    ST R7, RESPALDO_R7

    LD R5, VALUE2
    ADD R1, R6, R5
    ADD R6, R6, R5
    ST R6, DSH_R6
    JSR BORRAR_NAVE

    LD R7, RESPALDO_R7
    RET

VALUE2            .FILL #-128

MOVE_DOWN
    ST R7, RESPALDO_R7

    LD R5, VALUE
    ADD R6, R6, R5
    ST R6, DSH_R6
    JSR BORRAR_NAVE

    LD R7, RESPALDO_R7
    RET

MOVE_LEFT
   ST R7, RESPALDO_R7

    ADD R6, R6, #-1
    ST R6, DSH_R6
    JSR BORRAR_NAVE

    LD R7, RESPALDO_R7
    RET

MOVE_RIGHT
    ST R7, RESPALDO_R7

    ADD R6, R6, #1
    ST R6, DSH_R6
    JSR BORRAR_NAVE

    LD R7, RESPALDO_R7
    RET

RESPALDO_R7       .FILL 1

READ_INPUT
    ST R0, RESPALDO_R0

    LDI R0, KBD_IS_READ
    ADD R0, R0, #0
    BRz EXIT_INPUT
    LDI R0, KBD_BUF       ; Guardar la tecla en el buffer

EXIT_INPUT
    RET                    ; Retornar
RESPALDO_R0     .FILL 1
DRAW_NAVE
    ST	R0, ASH_R0	;;Respaldo de registros
    ST	R1, ASH_R1
    ST	R2, ASH_R2
    ST	R3, ASH_R3
    ST	R4, ASH_R4
    ST	R6, ASH_R6
    ST	R7, ASH_R7

    ADD R1, R6, #0          ; Esto es para no modificar la posicion real de la nave al dibujarla
    LD R2, COLOR_BLANCO     ; (La posicion de la nave siempre está en R1)
    LD R3, COLOR_AZUL
    LD R4, COLOR_ROJO
    LD R5, VALUE2
    STR R4, R1, #0
    STR R3, R1, #1
    STR R3, R1, #-1
    STR R2, R1, #2
    STR R2, R1, #3
    STR R2, R1, #-2
    STR R2, R1, #-3
    ADD R1, R1, R5
    STR R3, R1, #0
    STR R3, R1, #1
    STR R3, R1, #2
    STR R3, R1, #-1
    STR R3, R1, #-2
    ADD R1, R1, R5
    STR R2, R1, #0
    STR R3, R1, #1
    STR R3, R1, #-1
    ADD R1, R1, R5
    STR R2, R1, #0
    LD R5, VALUE
    ADD R1, R1, R5
    ADD R1, R1, R5
    ADD R1, R1, R5
    ADD R1, R1, R5
    STR R3, R1, #0
    STR R3, R1, #1
    STR R3, R1, #2
    STR R3, R1, #-1
    STR R3, R1, #-2
    ADD R1, R1, R5
    STR R2, R1, #0
    STR R3, R1, #1
    STR R3, R1, #-1
    ADD R1, R1, R5
    STR R2, R1, #0

    LD	R0, ASH_R0	;;Vuelta atras de los registros
    LD	R1, ASH_R1
    LD	R2, ASH_R2
    LD	R3, ASH_R3
    LD	R4, ASH_R4
    LD	R6, ASH_R6
    LD	R7, ASH_R7
    RET

;;Respaldo de registros		
ASH_R0		.FILL 1
ASH_R1		.FILL 1
ASH_R2		.FILL 1
ASH_R3		.FILL 1
ASH_R4		.FILL 1
ASH_R6		.FILL 1
ASH_R7		.FILL 1

BORRAR_NAVE
    ST	R0, BSH_R0	;;Respaldo de registros
    ST	R1, BSH_R1
    ST	R2, BSH_R2
    ST	R3, BSH_R3
    ST	R4, BSH_R4
    ST	R5, BSH_R5
    ST	R6, BSH_R6
    ST	R7, BSH_R7

    ADD R1, R6, #0          ; Esto es para no modificar la posicion real de la nave al dibujarla
    LD R2, COLOR_NEGRO      ; (La posicion de la nave siempre está en R1)
    LD R5, VALUE2

    ADD R1, R1, R5
    ADD R1, R1, R5
    ADD R1, R1, R5
    ADD R1, R1, R5
    ADD R1, R1, R5

    STR R2, R1, #0
    STR R2, R1, #1
    STR R2, R1, #2
    STR R2, R1, #3
    STR R2, R1, #4
    STR R2, R1, #5
    STR R2, R1, #-1
    STR R2, R1, #-2
    STR R2, R1, #-3
    STR R2, R1, #-4
    STR R2, R1, #-5

    LD R5, VALUE
    ADD R1, R1, R5

    STR R2, R1, #0
    STR R2, R1, #1
    STR R2, R1, #2
    STR R2, R1, #3
    STR R2, R1, #4
    STR R2, R1, #5
    STR R2, R1, #-1
    STR R2, R1, #-2
    STR R2, R1, #-3
    STR R2, R1, #-4
    STR R2, R1, #-5

    ADD R1, R1, R5

    STR R2, R1, #0
    STR R2, R1, #1
    STR R2, R1, #2
    STR R2, R1, #3
    STR R2, R1, #4
    STR R2, R1, #5
    STR R2, R1, #-1
    STR R2, R1, #-2
    STR R2, R1, #-3
    STR R2, R1, #-4
    STR R2, R1, #-5

    ADD R1, R1, R5

    STR R2, R1, #0
    STR R2, R1, #1
    STR R2, R1, #2
    STR R2, R1, #3
    STR R2, R1, #4
    STR R2, R1, #5
    STR R2, R1, #-1
    STR R2, R1, #-2
    STR R2, R1, #-3
    STR R2, R1, #-4
    STR R2, R1, #-5

    ADD R1, R1, R5

    STR R2, R1, #0
    STR R2, R1, #1
    STR R2, R1, #2
    STR R2, R1, #3
    STR R2, R1, #4
    STR R2, R1, #5
    STR R2, R1, #-1
    STR R2, R1, #-2
    STR R2, R1, #-3
    STR R2, R1, #-4
    STR R2, R1, #-5

    ADD R1, R1, R5

    STR R2, R1, #0
    STR R2, R1, #1
    STR R2, R1, #2
    STR R2, R1, #3
    STR R2, R1, #4
    STR R2, R1, #5
    STR R2, R1, #-1
    STR R2, R1, #-2
    STR R2, R1, #-3
    STR R2, R1, #-4
    STR R2, R1, #-5

    ADD R1, R1, R5

    STR R2, R1, #0
    STR R2, R1, #1
    STR R2, R1, #2
    STR R2, R1, #3
    STR R2, R1, #4
    STR R2, R1, #5
    STR R2, R1, #-1
    STR R2, R1, #-2
    STR R2, R1, #-3
    STR R2, R1, #-4
    STR R2, R1, #-5

    ADD R1, R1, R5

    STR R2, R1, #0
    STR R2, R1, #1
    STR R2, R1, #2
    STR R2, R1, #3
    STR R2, R1, #4
    STR R2, R1, #5
    STR R2, R1, #-1
    STR R2, R1, #-2
    STR R2, R1, #-3
    STR R2, R1, #-4
    STR R2, R1, #-5

    ADD R1, R1, R5

    STR R2, R1, #0
    STR R2, R1, #1
    STR R2, R1, #2
    STR R2, R1, #3
    STR R2, R1, #4
    STR R2, R1, #5
    STR R2, R1, #-1
    STR R2, R1, #-2
    STR R2, R1, #-3
    STR R2, R1, #-4
    STR R2, R1, #-5

    ADD R1, R1, R5

    STR R2, R1, #0
    STR R2, R1, #1
    STR R2, R1, #2
    STR R2, R1, #3
    STR R2, R1, #4
    STR R2, R1, #5
    STR R2, R1, #-1
    STR R2, R1, #-2
    STR R2, R1, #-3
    STR R2, R1, #-4
    STR R2, R1, #-5

    ADD R1, R1, R5

    STR R2, R1, #0
    STR R2, R1, #1
    STR R2, R1, #2
    STR R2, R1, #3
    STR R2, R1, #4
    STR R2, R1, #5
    STR R2, R1, #-1
    STR R2, R1, #-2
    STR R2, R1, #-3
    STR R2, R1, #-4
    STR R2, R1, #-5

    LD	R0, BSH_R0	;;Vuelta atras de los registros
    LD	R1, BSH_R1
    LD	R2, BSH_R2
    LD	R3, BSH_R3
    LD	R4, BSH_R4
    LD	R5, BSH_R5
    LD	R6, BSH_R6
    LD	R7, BSH_R7

    RET

;;Respaldo de registros		
BSH_R0		.FILL 1
BSH_R1		.FILL 1
BSH_R2		.FILL 1
BSH_R3		.FILL 1
BSH_R4		.FILL 1
BSH_R5		.FILL 1
BSH_R6		.FILL 1
BSH_R7		.FILL 1

; Constantes
COLOR_BLANCO      .FILL x7FFF
COLOR_AZUL        .FILL x001F
COLOR_ROJO        .FILL x7C00
VALUE             .FILL #128
KBD_BUF .FILL xFE02           ; Buffer para almacenar la tecla presionada
KBD_IS_READ .FILL xFE00

DIBUJAR_ASTEROIDE ; Pinta el asteroide desde la posicion guardada en R0
	ST	R0, CSH_R0	;;Respaldo de registros
    ST	R1, CSH_R1
    ST	R2, CSH_R2

	LD R1, ROJO
	LD R2, ANCHO_PANTALLA_AUX
	STR R1, R0, #3
	STR R1, R0, #4
	STR R1, R0, #5
	STR R1, R0, #6
	STR R1, R0, #7
	STR R1, R0, #8
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #2
	STR R1, R0, #8
	STR R1, R0, #9
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #2
	STR R1, R0, #9
	STR R1, R0, #10
	STR R1, R0, #11
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #0
	STR R1, R0, #1
	STR R1, R0, #2
	STR R1, R0, #11
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #0
	STR R1, R0, #11
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #0
	STR R1, R0, #11
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #0
	STR R1, R0, #9
	STR R1, R0, #10
	STR R1, R0, #11
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #0
	STR R1, R0, #9
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #0
	STR R1, R0, #9
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #0
	STR R1, R0, #9
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #1
	STR R1, R0, #2
	STR R1, R0, #8
	STR R1, R0, #9
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #3
	STR R1, R0, #4
	STR R1, R0, #5
	STR R1, R0, #6
	STR R1, R0, #7
	ADD R0, R0, R2 ; salto de linea
	
    LD	R0, CSH_R0	;;Vuelta atras de los registros
    LD	R1, CSH_R1
    LD	R2, CSH_R2

	RET

;;Respaldo de registros		
CSH_R0		.FILL 1
CSH_R1		.FILL 1
CSH_R2		.FILL 1

WAIT
    ST	R6, ESH_R6
    LD R6, DELAY
	WAIT_LOOP
		ADD R6, R6, #-1
		BRp WAIT_LOOP
    LD	R6, ESH_R6
	RET

;;Respaldo de registros		
ESH_R6		.FILL 1

BORRAR_ASTEROIDE
	ST	R0, FSH_R0	;;Respaldo de registros
    ST	R1, FSH_R1
    ST	R2, FSH_R2

	LD R1, BLACK
	LD R2, ANCHO_PANTALLA_AUX
	STR R1, R0, #3
	STR R1, R0, #4
	STR R1, R0, #5
	STR R1, R0, #6
	STR R1, R0, #7
	STR R1, R0, #8
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #2
	STR R1, R0, #8
	STR R1, R0, #9
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #2
	STR R1, R0, #9
	STR R1, R0, #10
	STR R1, R0, #11
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #0
	STR R1, R0, #1
	STR R1, R0, #2
	STR R1, R0, #11
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #0
	STR R1, R0, #11
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #0
	STR R1, R0, #11
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #0
	STR R1, R0, #9
	STR R1, R0, #10
	STR R1, R0, #11
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #0
	STR R1, R0, #9
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #0
	STR R1, R0, #9
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #0
	STR R1, R0, #9
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #1
	STR R1, R0, #2
	STR R1, R0, #8
	STR R1, R0, #9
	ADD R0, R0, R2 ; salto de linea
	STR R1, R0, #3
	STR R1, R0, #4
	STR R1, R0, #5
	STR R1, R0, #6
	STR R1, R0, #7
	ADD R0, R0, R2 ; salto de linea

	LD	R0, FSH_R0	;;Vuelta atras de los registros
    LD	R1, FSH_R1
    LD	R2, FSH_R2
	RET

;;Respaldo de registros		
FSH_R0		.FILL 1
FSH_R1		.FILL 1
FSH_R2		.FILL 1
ANCHO_PANTALLA_AUX .FILL #128 
ROJO .FILL x7C00
BLACK .FILL x0000
DELAY .FILL #10000
.END