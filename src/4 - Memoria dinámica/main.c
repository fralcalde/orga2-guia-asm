#include <assert.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../test-utils.h"
#include "Memoria.h"

int main() {

  char *str = "abc";

  uint32_t len = strLen(str);
  printf("strLen: %d\n", len);

  char *stra = "Astrognomo";
  char *strb = "Astronomo";

  uint32_t cmp = strCmp(stra, strb);
  printf("strCmp: %d\n", cmp);

  // strDelete(str); // No funciona porque str está en el stack. No en el heap.
  // Debe ser un puntero creado por malloc
  return 0;
}
