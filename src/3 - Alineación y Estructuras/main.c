#include <assert.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../test-utils.h"
#include "Estructuras.h"

uint32_t c_elem(lista_t *lista);
lista_t crear_lista(uint32_t cant_elems);
packed_lista_t crear_lista_packed(uint32_t cant_elems);

int main() {

  lista_t lista = crear_lista(10);
	packed_lista_t lista_packed = crear_lista_packed(10);

  uint32_t res = c_elem(&lista);
  printf("Contando en C: %d\n", res);

  res = cantidad_total_de_elementos(&lista);
  printf("Contando en ASM: %d\n", res);

	res = cantidad_total_de_elementos_packed(&lista_packed);
	printf("Contando en ASM packed: %d\n", res);

  /* Acá pueden realizar sus propias pruebas */
  return 0;
}

uint32_t c_elem(lista_t *lista) {
  uint32_t total = 0;

  nodo_t *nodo = lista->head;

  while (nodo != NULL) {
    total += nodo->longitud;
    nodo = nodo->next;
  }

  return total;
}

lista_t crear_lista(uint32_t cant_elems) {
  nodo_t *array[cant_elems];

  for (uint32_t i = 0; i < cant_elems; i++) {
    array[i] = malloc(sizeof(nodo_t));
    array[i]->categoria = 'A';
    array[i]->longitud = cant_elems;
  }

  for (uint32_t i = 0; i < cant_elems - 1; i++) {
    array[i]->next = array[i + 1];
  }

  lista_t lista;
  lista.head = array[0];

  return lista;
}

packed_lista_t crear_lista_packed(uint32_t cant_elems) {
  packed_nodo_t *array[cant_elems];
	

  for (uint32_t i = 0; i < cant_elems; i++) {
    array[i] = malloc(sizeof(nodo_t));
    array[i]->categoria = 'A';
    array[i]->longitud = cant_elems;
  }

  for (uint32_t i = 0; i < cant_elems - 1; i++) {
    array[i]->next = array[i + 1];
  }

  packed_lista_t lista;
  lista.head = array[0];

  return lista;
}

