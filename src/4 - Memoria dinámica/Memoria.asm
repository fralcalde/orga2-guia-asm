extern malloc
extern free
extern fprintf

CHAR_SIZE EQU 1
END_CHAR EQU 0
null_string: db 'NULL', 0

section .data

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a[rdi], char* b[rsi])
strCmp:
  ; prologo
  push rbp
  mov rbp, rsp

  push r12
  mov r12, rdi

  push r13
  mov r13, rsi

strCmp_loop:
  mov sil, BYTE [r12]
  mov dil, BYTE [r13]

  add r12, CHAR_SIZE
  add r13, CHAR_SIZE

  cmp sil, dil
  jl strCmp_a_less_than_b
  jg strCmp_a_greater_than_b
  je strCmp_a_equals_b


strCmp_a_equals_b:
  mov rax, 0
  cmp sil, END_CHAR ; Como se que ambos strings tienen el mismo largo
  jne strCmp_loop ; Si el caracter no es '\000', sigo comparando
  jmp strCmp_fin

strCmp_a_less_than_b:
  mov rax, 1
  jmp strCmp_fin

strCmp_a_greater_than_b:
  mov rax, -1
  jmp strCmp_fin


strCmp_fin:
  pop r13
  pop r12

  ; epilogo
  pop rbp
	ret

; char* strClone(char* a[rdi])
strClone:
  ; prologo
  push rbp
  mov rbp, rsp

  push r12 ; Preservo valor de r12
  mov r12, rdi ; Me guardo puntero al string original

  push r13 ; Preservo valor de r13

  call strLen ; eax = largo del string
  add rax, 1 ; Agrego 1 al string size para el caracter '\000'
  mov rdi, rax ; arg1 = largo del string + 1
  call malloc ; rax = puntero al nuevo string

  mov r13, rax ; Preservo valor de rax

strClone_loop:
  mov sil, BYTE [r12]
  mov BYTE [r13], sil

  add r12, CHAR_SIZE
  add r13, CHAR_SIZE

  cmp sil, END_CHAR
  jne strClone_loop
  

  pop r13 ; Recupero valor original de r13
  pop r12 ; Recupero valor original de r12

  ; epilogo
  pop rbp
	ret

; void strDelete(char* a[rdi])
strDelete:
  ; prologo
  push rbp
  mov rbp, rsp

  call free

  ; epilogo
  pop rbp
	ret

; void strPrint(char* a [rdi], FILE* pFile [rsi])
strPrint:
	; prologo
	push rbp
	mov rbp, rsp

	mov cl, BYTE [rdi]
	cmp cl, END_CHAR
	jne strPrint_not_null_string

	mov rdi, null_string

strPrint_not_null_string:
	mov rdx, rsi
	mov rsi, rdi
	mov rdi, rdx

	call fprintf

	; epilogo
	pop rbp
	ret

; uint32_t strLen(char* a[rdi])
strLen:
  ; prologo
  push rbp
  mov rbp, rsp

  mov eax, 0x0 ; Inicializo contador en cero

strLen_loop:
  mov sil, BYTE [rdi] ; Leo primer valor en string
  cmp sil, END_CHAR ; Si el valor es '\000' se termina el string
  je strLen_fin
  add eax, 0x1
  add rdi, CHAR_SIZE
  jmp strLen_loop

strLen_fin:
  ; epilogo
  pop rbp
	ret


