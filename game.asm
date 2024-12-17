.ORIG x3000

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
ST R6, NAVE
JSR DRAW_NAVE         ; Dibujar nave en posicion incial (hacia arriba)
ST R6, posicion_disparo
MAIN_LOOP
    LD R1, CANT_ASTEROIDES
	ADD R4, R4, #-4   ; vuelvo al inicio del ARRAY de ASTEROIDES
	AND R6, R6, #0    ; inicializo R6 a cero para elegir el desplazamiento indicado para cada ASTEROIDE
    LD R0, RESPALDO_R0
    ASTEROIDE_LOOP
        ADD R4, R4, #1	        ; cambio de asteroide al que desplazo
        LDR R0, R4, #0          ; guarda en R0 el asteroide correspondiente
        BRz ASTEROIDE_LOOP      ; Si esta vacio, continuar al siguiente      
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
        JSR VERIFICA_COLISION
        JSR CHECK_DISPARO
        STR R0, R4, #0
        ADD R6, R6, #1
        ADD R1, R1, #-1
        BRp ASTEROIDE_LOOP
	LD R6, NAVE
    JSR READ_INPUT         ; Leer la entrada del teclado
    JSR MOVE_NAVE
	ST R6, NAVE
	JSR DRAW_NAVE
    JSR INICIA_DISPARO
    JSR MOVER_DISPARO
	BR MAIN_LOOP           ; Repetir el bucle principal

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
POSICION_INICIAL  .FILL xDF40
ASTEROIDE_1 .FILL xC900
ASTEROIDE_2 .FILL xE000 
ASTEROIDE_3 .FILL xC060
ASTEROIDE_4 .FILL xEE70
CERO            .FILL #0
UNO		.FILL #1
MENOS_UNO       .FILL #-1
BOOL_DISPARO    .FILL 1
INICIA_DISPARO
    ST R0, CD_R0
    ST R1, CD_R1
    ST R3, CD_R3
    ST R7, CD_R7
    ST R6, CD_R6
    LD R3, space_key       ; Cargar el valor de la barra espaciadora
    ADD R3, R3, R0
    BRz SHOOT
    LD R0, CD_R0
    LD R1, CD_R1
    LD R3, CD_R3
    LD R6, CD_R6
    LD R7, CD_R7
    RET
SHOOT
    ST R7, SH_R7
    JSR CHECK_ACTIVA
    LD R1, NAVE
    ADD R6, R1, #0
    LD R3, MOVIMIENTO_DISPARO
    ADD R6, R6, R3
    ST R6, posicion_disparo
    JSR DIBUJAR_DISPARO
    LD R7, SH_R7
    RET
MOVIMIENTOS_X   .BLKW 4
MOVIMIENTOS_Y   .BLKW 4
SH_R7   .FILL 1
CHECK_ACTIVA
    ST R6, CA_R6
    ST R7, CA_R7
    LD R6, posicion_disparo
    BRn NO_SHOOT            ; esto significa que si hay un disparo activo, no se realizara ninguna otra cosa
    LD R6, CA_R6
    LD R7, CA_R7
    RET
CA_R6   .FILL 1
CA_R7   .FILL 1
ASTEROIDE_UBI	.BLKW 1
MOVER_DISPARO
    ST R1, MD_R1
    ST R3, MD_R3
    ST R6, MD_R6
    ST R7, MD_R7
    LD R6, posicion_disparo
    BRzp NO_SHOOT

    LD R3, NAVE
    NOT R3, R3
    ADD R3, R3, #1
    ADD R3, R6, R3
    BRz NO_SHOOT

    ; Verificar si el disparo esta fuera de la pantalla
    LD R2, ANCHO_PANTALLA
    NOT R2, R2
    ADD R2, R2, #1
    ADD R2, R6, R2
    BRp NO_SHOOT   ; Disparo fuera de pantalla

    JSR BORRAR_DISPARO
    LD R1, MOVIMIENTO_DISPARO
    ADD R6, R6, R1
    ST R6, posicion_disparo
    JSR DIBUJAR_DISPARO
    LD R1, MD_R1
    LD R3, MD_R3
    LD R6, MD_R6
    LD R7, MD_R7
    RET
ASTEROIDES		.BLKW 4
NO_SHOOT
    ST R7, NDA_R7
    ADD R0, R0, #0
    ST R0, posicion_disparo
    LD R7, MD_R7
    RET
ANCHO_PANTALLA .FILL #128 
ANCHO_PANTALLA_N .FILL #-128
CANT_ASTEROIDES .FILL #4
NDA_R7  .FILL 1
MD_R0   .FILL 1
MD_R1   .FILL 1
MD_R2   .FILL 1
MD_R3   .FILL 1
MD_R4   .FILL 1
MD_R5   .FILL 1
MD_R6   .FILL 1
MD_R7   .FILL 1
DIBUJAR_DISPARO
    ST R6, DC_R6
    ST R1, DC_R1
    ST R2, DC_R2
    ST R3, DC_R3
    ;se dibujara en la posicion de R6
    LD R1, BLANCO
    LD R2, ANCHO_PANTALLA

    STR R1, R6, #0
    STR R1, R6, #1
    ADD R6, R6, R2      ;salto linea
    STR R1, R6, #0
    STR R1, R6, #1
    ADD R6, R6, R2      ;salto linea
    STR R1, R6, #0
    STR R1, R6, #1
    ADD R6, R6, R2      ;salto linea
    STR R1, R6, #0
    STR R1, R6, #1
    ADD R6, R6, R2      ;salto linea
    STR R1, R6, #0
    STR R1, R6, #1
    ADD R6, R6, R2      ;salto linea
    STR R1, R6, #0
    STR R1, R6, #1
    ADD R6, R6, R2      ;salto linea
    STR R1, R6, #0
    STR R1, R6, #1

    LD R6, DC_R6
    LD R1, DC_R1
    LD R2, DC_R2
    LD R3, DC_R3
	RET
BORRAR_DISPARO
    ST R6, DC_R6
    ST R1, DC_R1
    ST R2, DC_R2
    ST R3, DC_R3
    ;se dibujara en la posicion de R6
    LD R1, COLOR_NEGRO
    LD R2, ANCHO_PANTALLA

    STR R1, R6, #0
    STR R1, R6, #1
    ADD R6, R6, R2      ;salto linea
    STR R1, R6, #0
    STR R1, R6, #1
    ADD R6, R6, R2      ;salto linea
    STR R1, R6, #0
    STR R1, R6, #1
    ADD R6, R6, R2      ;salto linea
    STR R1, R6, #0
    STR R1, R6, #1
    ADD R6, R6, R2      ;salto linea
    STR R1, R6, #0
    STR R1, R6, #1
    ADD R6, R6, R2      ;salto linea
    STR R1, R6, #0
    STR R1, R6, #1
    ADD R6, R6, R2      ;salto linea
    STR R1, R6, #0
    STR R1, R6, #1
    ADD R6, R6, R2      ;salto linea
    LD R6, DC_R6
    LD R1, DC_R1
    LD R2, DC_R2
    LD R3, DC_R3
    RET
posicion_disparo    .BLKW 1
NAVE .BLKW 1
READ_INPUT
    ST R0, RESPALDO_R0

    LDI R0, KBD_IS_READ
    ADD R0, R0, #0
    BRz EXIT_INPUT
    LDI R0, KBD_BUF       ; Guardar la tecla en el buffer

EXIT_INPUT
    RET                    ; Retornar
RESPALDO_R0     .FILL 1
BLANCO      .FILL x7FFF
DC_R6   .FILL 1
DC_R1   .FILL 1
DC_R2   .FILL 1
DC_R3   .FILL 1
CD_R0   .FILL 1
CD_R1   .FILL 1
CD_R3   .FILL 1
CD_R6   .FILL 1
CD_R7   .FILL 1
AUX     .FILL #128
KBD_IS_READ .FILL xFE00
KBD_BUF .FILL xFE02           ; Buffer para almacenar la tecla presionada
MOVIMIENTO_DISPARO    .FILL #-1280
COLOR_NEGRO       .FILL x0000
PANTALLA_INICIO   .FILL xC000
up_key .FILL #-119            ; Tecla 'W' para subir
down_key .FILL #-115          ; Tecla 'S' para bajar
left_key .FILL #-97           ; Tecla 'A' para mover a la izquierda
right_key .FILL #-100         ; Tecla 'D' para mover a la derecha
space_key .FILL #-32           ; Tecla 'Barra Espaciadora' para disparar
extraer_columna .FILL xFF80
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
	ADD R5, R5, R5
    ADD R1, R6, R5
    ADD R6, R6, R5
    ST R6, DSH_R6
    JSR BORRAR_NAVE

    LD R7, RESPALDO_R7
    RET
MOVE_DOWN
    ST R7, RESPALDO_R7

    LD R5, VALUE
	ADD R5, R5, R5
    ADD R6, R6, R5
    ST R6, DSH_R6
    JSR BORRAR_NAVE

    LD R7, RESPALDO_R7
    RET
MOVE_LEFT
   ST R7, RESPALDO_R7

    ADD R6, R6, #-2
    ST R6, DSH_R6
    JSR BORRAR_NAVE

    LD R7, RESPALDO_R7
    RET
MOVE_RIGHT
    ST R7, RESPALDO_R7

    ADD R6, R6, #2
    ST R6, DSH_R6
    JSR BORRAR_NAVE

    LD R7, RESPALDO_R7
    RET
RESPALDO_R7       .FILL 1
GAMEOVER		LEA		R0, GAMEOVER_STR
				PUTS
				HALT
CHECK_DISPARO
    ST R0, CDI_R0        ;contador de eje x
    ST R1, CDI_R1        ;posicion asteroide
    ST R2, CDI_R2        ;posicion nave
    ST R3, CDI_R3        ;extraer_fila
    ST R4, CDI_R4        ;basura
    ST R5, CDI_R5        ;almacena resultado
    ST R7, CDI_R7        ;por las dudas
    LD R3, extraer_fila
    LD R1, POSICION_ASTEROIDE
    LD R0, contadorX
    LD R2, posicion_disparo             
    AND R1, R1, R3      ;R1 guarda posicion X del asteroide
    AND R2, R2, R3      ;R2 guarda posicion X de la posicion_disparo
    NOT R5, R1           
    ADD R5, R5, #1      ;en R5 tengo -(posX asteroide)   
    JSR VERIFICA_EJE
    LD R0, CDI_R0
    LD R1, CDI_R1
    LD R2, CDI_R2
    LD R3, CDI_R3
    LD R4, CDI_R4
    LD R5, CDI_R5
    LD R7, CDI_R7
    RET
VERIFICA_EJE
    ADD R4, R5, R2          
    BRzp VERIFICAR_EJEX_DER
    RET
VERIFICAR_EJEX_DER
    LD R1, POSICION_ASTEROIDE
    ADD R1, R1, #11     ;guardo nueva_posicion del asteroide
    AND R1, R1, R3      ;guardo nueva_posx del asteroide
    NOT R5, R1          
    ADD R5, R5, #1      ;en R5 tengo -(nueva_posX asteroide)
    ADD R4, R5, R2
    BRnz VERIFICAR_EJEY_ABAJO
    RET
VERIFICAR_EJEY_ABAJO
    LD R3, extraer_columna
    LD R0, contadorY
    LD R1, POSICION_ASTEROIDE
    LD R2, posicion_disparo
    AND R1, R1, R3      ;R1 guarda posicion Y del asteroide
    AND R2, R2, R3      ;R2 guarda posicion Y de la posicion_disparo
    NOT R5, R1          
    ADD R5, R5, #1      ;en R5 tengo -(posY asteroide)
    ADD R4, R5, R2      
    BRzp CHECK_COLISION
    RET
CDI_R0      .FILL 1
CDI_R1      .FILL 1
CDI_R2      .FILL 1
CDI_R3      .FILL 1
CDI_R4      .FILL 1
CDI_R5      .FILL 1
CDI_R6      .FILL 1
CDI_R7      .FILL 1
CHECK_COLISION
    LD R1, POSICION_ASTEROIDE
    LD R4, largo_asteroide
    ADD R1, R1, R4          ;nueva posicionNueva asteroide
    AND R1, R1, R3          ;R1 guarda posicionNueva Y del asteroide
    NOT R5, R1          
    ADD R5, R5, #1          ;en R5 tengo -(posY asteroide)
    ADD R4, R5, R2    
    BRnz TERMINAR
    RET
TERMINAR
    ST R0, TE_R0
    ST R1, TE_R1
    ST R2, TE_R2
    ST R3, TE_R3
    ST R6, TE_R6
    ST R7, TE_R7
    ; Eliminar la posicion del asteroide impactado en el array
    LEA R4, ASTEROIDES      ; R4 apunta al inicio del array
    LD R3, CANT_ASTEROIDES  ; R3 contiene la cantidad de asteroides restantes
    BRzp FIND_ASTEROIDE
    RET
FIND_ASTEROIDE
    LDR R1, R4, #0          ; R1 carga la posicion del asteroide actual
    LD R2, POSICION_ASTEROIDE
    ADD R1, R1, R2          ; Comparar posicion del asteroide impactado con posicion de los asteroides
    BRz FOUND               ; Si coincide, es el asteroide impactado
    ADD R4, R4, #1          ; Avanzar al siguiente asteroide
    ADD R3, R3, #-1         ; Decrementar la cantidad de asteroides por revisar
    BRp FIND_ASTEROIDE      ; Repetir mientras haya asteroides por verificar
    LD R1, TE_R1
    LD R2, TE_R2
    LD R3, TE_R3
    LD R7, TE_R7
    RET
FOUND
    AND R0, R0, #0          ; R0 = 0
    STR R0, R4, #0          ; Borrar posicion del asteroide impactado del array
    LD R0, POSICION_ASTEROIDE
    LD R6, posicion_disparo
    ; Llamadas para limpiar pantalla y desactivar disparo
    JSR BORRAR_ASTEROIDE
    JSR BORRAR_DISPARO
    AND R0, R0, #0          ; Desactivar disparo
    LD R0, posicion_disparo
    LD R0, TE_R0
    LD R1, TE_R1
    LD R2, TE_R2
    LD R3, TE_R3
    LD R6, TE_R6
    LD R7, TE_R7
    RET
VALUE       .FILL #128
VALUE2            .FILL #-128
TE_R0       .FILL 1
TE_R1       .FILL 1
TE_R2       .FILL 1
TE_R3       .FILL 1
TE_R6       .FILL 1
TE_R7       .FILL 1
VERIFICA_COLISION
    ST R0, VC_R0        ;contador de eje x
    ST R1, VC_R1        ;posicion asteroide
    ST R2, VC_R2        ;posicion nave
    ST R3, VC_R3        ;extraer_fila
    ST R4, VC_R4        ;basura
    ST R5, VC_R5        ;almacena resultado
    ST R7, VC_R7        ;por las dudas
    LD R3, extraer_fila
    LD R1, POSICION_ASTEROIDE
    LD R0, contadorX
    LD R2, NAVE             
    AND R1, R1, R3      ;R1 guarda posicion X del asteroide
    AND R2, R2, R3      ;R2 guarda posicion X de la nave
    NOT R5, R1           
    ADD R5, R5, #1      ;en R5 tengo -(posX asteroide)   
    JSR VERIFICA_EJES
    LD R0, VC_R0
    LD R1, VC_R1
    LD R2, VC_R2
    LD R3, VC_R3
    LD R4, VC_R4
    LD R5, VC_R5
    LD R7, VC_R7
    RET
GAMEOVER_STR	.STRINGZ "GAMEOVER"
VC_R0       .FILL 1
VC_R1       .FILL 1
VC_R2       .FILL 1
VC_R3       .FILL 1
VC_R4       .FILL 1
VC_R5       .FILL 1
VC_R7       .FILL 1
extraer_fila .FILL x007F
contadorX     .FILL #1
contadorY     .FILL #10
largo_asteroide          .FILL #1536
VERIFICA_EJES
    ADD R4, R5, R2          
    BRzp VERIFICAR_EJEX
    RET
VERIFICAR_EJEX
    LD R1, POSICION_ASTEROIDE
    ADD R1, R1, #11     ;guardo nueva_posicion del asteroide
    AND R1, R1, R3      ;guardo nueva_posx del asteroide
    NOT R5, R1          
    ADD R5, R5, #1      ;en R5 tengo -(nueva_posX asteroide)
    ADD R4, R5, R2
    BRnz VERIFICAR_EJEY
    RET
VERIFICAR_EJEY
    LD R3, extraer_columna
    LD R0, contadorY
    LD R1, POSICION_ASTEROIDE
    LD R2, NAVE
    AND R1, R1, R3      ;R1 guarda posicion Y del asteroide
    AND R2, R2, R3      ;R2 guarda posicion Y de la nave
    NOT R5, R1          
    ADD R5, R5, #1      ;en R5 tengo -(posY asteroide)
    ADD R4, R5, R2      
    BRzp CHECK_GAMEOVER
    RET
CHECK_GAMEOVER
    LD R1, POSICION_ASTEROIDE
    LD R4, largo_asteroide
    ADD R1, R1, R4          ;nueva posicionNueva asteroide
    AND R1, R1, R3          ;R1 guarda posicionNueva Y del asteroide
    NOT R5, R1          
    ADD R5, R5, #1          ;en R5 tengo -(posY asteroide)
    ADD R4, R5, R2    
    BRnz GAMEOVER
    RET
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
POSICION_ASTEROIDE      .FILL 1
NEGRO       .FILL x0000
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
    LD R2, NEGRO      ; (La posicion de la nave siempre está en R1)
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

DIBUJAR_ASTEROIDE ; Pinta el asteroide desde la posicion guardada en R0
	ST	R0, CSH_R0	;;Respaldo de registros
    ST  R0, POSICION_ASTEROIDE
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
DELAY .FILL #5500
.END
