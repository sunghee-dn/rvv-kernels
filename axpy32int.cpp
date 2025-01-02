
#include "riscv_vector.h"
#include <stdlib.h>

extern "C" {

void axpy32int(uint32_t n, int a, const int *__restrict x,
          int *__restrict y) {
#pragma clang loop vectorize(disable)
  for (uint32_t i = 0; i < n; i++) {
    y[i] += a * x[i];
  }
}

void axpy32int_compiler_vectorize(uint32_t n, int a, const int *__restrict x,
                             int *__restrict y) {
#pragma clang loop vectorize(enable)
  for (uint32_t i = 0; i < n; i++) {
    y[i] += a * x[i];
  }
}

void axpy32int_rvv(uint32_t n, int a, const int *__restrict x,
              int *__restrict y) {
  for (uint32_t i = 0; i < n;) {
    uint32_t vl = vsetvl_e32m1(n - i);

    vint32m1_t x_data = vle32_v_i32m1(&x[i], vl);
    vint32m1_t y_data = vle32_v_i32m1(&y[i], vl);
    y_data = vmacc(y_data, a, x_data, vl);

    vse32_v_i32m1(&y[i], y_data, vl);

    i += vl;
  }
}

void axpy32int_rvv2(uint32_t n, int a, const int *__restrict x,
               int *__restrict y) {
  uint32_t vlmax = vsetvlmax_e32m1();
  uint32_t i;
  for (i = 0; i + vlmax < n;) {

    vint32m1_t x_data = vle32_v_i32m1(&x[i], vlmax);
    vint32m1_t y_data = vle32_v_i32m1(&y[i], vlmax);
    y_data = vmacc(y_data, a, x_data, vlmax);

    vse32_v_i32m1(&y[i], y_data, vlmax);

    i += vlmax;
  }

  for (; i < n; i++) {
    y[i] += a * x[i];
  }
}
}
