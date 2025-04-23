

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
NODO_OFFSET_NEXT EQU 0
NODO_OFFSET_CATEGORIA EQU 8
NODO_OFFSET_ARREGLO EQU 16
NODO_OFFSET_LONGITUD EQU 24
NODO_SIZE EQU 32
PACKED_NODO_OFFSET_NEXT EQU 0
PACKED_NODO_OFFSET_CATEGORIA EQU 8
PACKED_NODO_OFFSET_ARREGLO EQU 9
PACKED_NODO_OFFSET_LONGITUD EQU 17
PACKED_NODO_SIZE EQU 21
LISTA_OFFSET_HEAD EQU 0
LISTA_SIZE EQU 8
PACKED_LISTA_OFFSET_HEAD EQU 0
PACKED_LISTA_SIZE EQU 8

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global cantidad_total_de_elementos
global cantidad_total_de_elementos_packed

;########### DEFINICION DE FUNCIONES
;extern uint32_t cantidad_total_de_elementos(lista_t* lista);
;registros: lista[rdi]
cantidad_total_de_elementos:
  ; prologo
  push rbp ; pila alineada
  mov rbp, rsp ; stack frame armado

  mov eax, 0x0 ; inicializo contador en cero
  mov rsi, QWORD [rdi] ; rsi = lista.head (puntero a primer nodo)

  cmp rsi, 0x0 ; Si la lista está vacía, rsi == 0
  je fin

cuenta:
  add eax, DWORD [rsi + NODO_OFFSET_LONGITUD] ; acumular longitudes

  mov rsi, QWORD [rsi + NODO_OFFSET_NEXT] ; puntero a siguiente elemento
  cmp rsi, 0x0 ; nodo.next != NULL, seguir acumulando
  jne cuenta

fin:
  ; epilogo
  pop rbp
	ret

;extern uint32_t cantidad_total_de_elementos_packed(packed_lista_t* lista);
;registros: lista[?]
cantidad_total_de_elementos_packed:
	; prologo
	push rbp ; pila alineada
	mov rbp, rsp ; stack frame armado

	mov eax, 0x0 ; inicializo contador en cero
	mov rsi, QWORD [rdi] ; rsi = lista.head (puntero a primer nodo)

	cmp rsi, 0x0 ; si la lista está vacía, rsi == 0
	je packed_fin

packed_cuenta:
	add eax, DWORD [rsi + PACKED_NODO_OFFSET_LONGITUD]

	mov rsi, QWORD [rsi + PACKED_NODO_OFFSET_NEXT] ; puntero a siguiente elemento
	cmp rsi, 0x0 ; nodo.next != NULL, seguir acumulando
	jne packed_cuenta

packed_fin:
	; epilogo
	pop rbp
	ret

