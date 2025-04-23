extern sumar_c
extern restar_c
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_using_c
global alternate_sum_4_using_c_alternative
global alternate_sum_8
global product_2_f
global product_9_f

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4:
  sub EDI, ESI
  add EDI, EDX
  sub EDI, ECX

  mov EAX, EDI
  ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4_using_c:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  push R12
  push R13	; preservo no volatiles, al ser 2 la pila queda alineada

  mov R12D, EDX ; guardo los parámetros x3 y x4 ya que están en registros volátiles
  mov R13D, ECX ; y tienen que sobrevivir al llamado a función

  call restar_c 
  ;recibe los parámetros por EDI y ESI, de acuerdo a la convención, y resulta que ya tenemos los valores en esos registros
  
  mov EDI, EAX ;tomamos el resultado del llamado anterior y lo pasamos como primer parámetro
  mov ESI, R12D
  call sumar_c

  mov EDI, EAX
  mov ESI, R13D
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  pop R13 ;restauramos los registros no volátiles
  pop R12
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


alternate_sum_4_using_c_alternative:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  sub RSP, 16 ; muevo el tope de la pila 8 bytes para guardar x4, y 8 bytes para que quede alineada

  mov [RBP-8], RCX ; guardo x4 en la pila

  push RDX  ;preservo x3 en la pila, desalineandola
  sub RSP, 8 ;alineo
  call restar_c 
  add RSP, 8 ;restauro tope
  pop RDX ;recupero x3
  
  mov EDI, EAX
  mov ESI, EDX
  call sumar_c

  mov EDI, EAX
  mov ESI, [RBP - 8] ;leo x4 de la pila
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  add RSP, 16 ;restauro tope de pila
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; registros y pila: x1[RDI], x2[RSI], x3[RDX], x4[RCX], x5[R8], x6[R9], x7[RBP + 16], x8[RBP + 24]
alternate_sum_8:
	;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;stack frame armado

  push R12 ;Preservo valor viejo de R12 en stack; RSP = RBP - 8
  mov R12, RDX ;R12 = x3

  push R13 ;Preservo valor viejo de R13 en stack; RSP = RBP - 16
  mov R13, RCX ;R13 = x4

  push R14 ;Preservo valor viejo de R14 en stack; RSP = RBP - 24
  mov R14, R8 ;R14 = x5

  push R15 ;Preservo valor viejo de R15 en stack; RSP = RBP - 32
  mov R15, R9 ;R15 = x6

  ;EDI = x1
  ;ESI = x2
  call restar_c
  ;EAX = x1 - x2

  mov EDI, EAX ;EDI = x1 - x2
  mov ESI, R12D ;ESI = x3
  call sumar_c
  ;EAX = x1 - x2 + x3

  mov EDI, EAX ;EDI = x1 - x2 + x3
  mov ESI, R13D ;ESI = x4
  call restar_c
  ;EAX = x1 - x2 + x3 - x4

  mov EDI, EAX ;EDI = x1 - x2 + x3 - x4
  mov ESI, R14D ;ESI = x5
  call sumar_c
  ;EAX = x1 - x2 + x3 - x4 + x5

  mov EDI, EAX ;EDI =  x1 - x2 + x3 - x4 + x5
  mov ESI, R15D ;ESI = x6
  call restar_c
  ;EAX = x1 - x2 + x3 - x4 + x5 - x6

  mov EDI, EAX ;EDI = x1 - x2 + x3 - x4 + x5 - x6
  mov ESI, DWORD [RBP + 16] ;ESI = x7 ??? SII!!
  call sumar_c
  ;EAX = x1 - x2 + x3 - x4 + x5 - x6 + x7
  
  mov EDI, EAX ;EDI = x1 - x2 + x3 - x4 + x5 - x6 + x7
  mov ESI, DWORD [RBP + 24] ;ESI = x8
  call restar_c
  ;EAX = x1 - x2 + x3 - x4 + x5 - x6 + x7 - x8
  
  pop R15 ;Recupero registro no-volatil; RSP = RBP - 24
  pop R14 ;RSP = RBP - 16
  pop R13 ;RSP = RBP - 8
  pop R12 ;RSP = RBP

	;epilogo
  pop RBP ;Recuperar base pointer de funcion llamadora; desalinea
	ret ; Popea RIP y -8 a RSP



; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: destination[RDI], x1[RSI], f1[XMM0]
product_2_f:
  ; prologo
  push RBP ; pila alineada
  mov RBP, RSP ; Nuevo stackframe armado

  cvtsi2ss XMM1, ESI ; Convertir x1 de uint_32_t a float
  mulss XMM0, XMM1 ; Multiplicar xmm0 con xmm1. xmm0 = x1 * f1
  cvtss2si ESI, XMM0 ; Convertir xmm0 a uint32_t

  mov [RDI], ESI ; Store x1 * f1 en la dirección pasada por parámetro 'destination'

  ; epilogo
  pop RBP
	ret


;product_2_f:
;  ; prologo
;  push RBP ; pila alineada
;  mov RBP, RSP ; Nuevo stackframe armado
;
;  CVTSS2SI EDX, XMM0 ; Convert f1 to uint32_t
;  MOV EAX, ESI ; Prepare x1 in EAX
;  MUL EDX ; EAX = x1 * f1
;
;  MOV [RDI], EAX ; Store x1 * f1 in the address passed on 'destination'
;
;  ; epilogo
;  pop RBP
;	ret


;extern void product_9_f(double * destination
;, uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
;, uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
;, uint32_t x9, float f9);
;registros y pila: destination[rdi], x1[rsi], f1[xmm0], x2[rdx], f2[xmm1], x3[rcx], f3[xmm2], x4[r8], f4[xmm3]
;	, x5[r9], f5[xmm4], x6[rbp + 16], f6[xmm5], x7[rbp + 24], f7[xmm6], x8[rbp + 32], f8[xmm7],
;	, x9[rbp + 40], f9[rbp + 48]
product_9_f:
	;prologo
	push rbp
	mov rbp, rsp

	;convertimos los flotantes de cada registro xmm en doubles
	cvtss2sd xmm0, xmm0
	cvtss2sd xmm1, xmm1
	cvtss2sd xmm2, xmm2
	cvtss2sd xmm3, xmm3
	cvtss2sd xmm4, xmm4
	cvtss2sd xmm5, xmm5
	cvtss2sd xmm6, xmm6
	cvtss2sd xmm7, xmm7
  
  movq xmm8, QWORD [rbp + 48]
	cvtss2sd xmm8, xmm8

	;multiplicamos los doubles en xmm0 <- xmm0 * xmm1, xmmo * xmm2 , ...
  mulsd xmm0, xmm1
  mulsd xmm0, xmm2
  mulsd xmm0, xmm3
  mulsd xmm0, xmm4
  mulsd xmm0, xmm5
  mulsd xmm0, xmm6
  mulsd xmm0, xmm7
  mulsd xmm0, xmm8

	; convertimos los enteros en doubles y los multiplicamos por xmm0.
  cvtsi2sd xmm1, rsi
  mulsd xmm0, xmm1

  cvtsi2sd xmm1, rdx
  mulsd xmm0, xmm1

  cvtsi2sd xmm1, rcx
  mulsd xmm0, xmm1

  cvtsi2sd xmm1, r8
  mulsd xmm0, xmm1

  cvtsi2sd xmm1, r9
  mulsd xmm0, xmm1

  mov rsi, QWORD [rbp + 16]
  cvtsi2sd xmm1, rsi
  mulsd xmm0, xmm1

  mov rsi, QWORD [rbp + 24]
  cvtsi2sd xmm1, rsi
  mulsd xmm0, xmm1

  mov rsi, QWORD [rbp + 32]
  cvtsi2sd xmm1, rsi
  mulsd xmm0, xmm1

  mov rsi, QWORD [rbp + 40]
  cvtsi2sd xmm1, rsi
  mulsd xmm0, xmm1

  movq [rdi], QWORD xmm0
	; epilogo
	pop rbp
	ret

