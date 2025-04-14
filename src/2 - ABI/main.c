#include <assert.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../test-utils.h"
#include "ABI.h"

int main() {
  /* Acá pueden realizar sus propias pruebas */
  // assert(alternate_sum_4_using_c(8, 2, 5, 1) == 6);
  assert(alternate_sum_4_using_c(8, 2, 5, 1) == 10);

  // assert(alternate_sum_4_using_c_alternative(8, 2, 5, 1) == 6);
  assert(alternate_sum_4_using_c_alternative(8, 2, 5, 1) == 10);

  assert(alternate_sum_8(8, 2, 5, 1, 8, 2, 5, 1) == 20);
  assert(alternate_sum_8(822, 230, 481, 566, 592, 70, 838, 216) == 1651);
  return 0;
}
