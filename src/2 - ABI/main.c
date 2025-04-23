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

  uint32_t result = 0;
  product_2_f(&result, 489, 465.01);
  // assert(result == 227388);

  double result2 = 0;
  product_9_f(&result2, 825, 998.41, 922, 468.25, 769, 773.30, 23, 635.85, 472,
              94.86, 755, 535.01, 40, 838.15, 125, 486.42, 396, 511.67);
  // assert(something);

  return 0;
}
