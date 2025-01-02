
#include "riscv_vector.h"
#include <stdlib.h>

extern "C" {

void axpy32(uint32_t n, float a, const float *__restrict x,
          float *__restrict y) {
#pragma clang loop vectorize(disable)
  for (uint32_t i = 0; i < n; i++) {
    y[i] += a * x[i];
  }
}

void axpy32_compiler_vectorize(uint32_t n, float a, const float *__restrict x,
                             float *__restrict y) {
#pragma clang loop vectorize(enable)
  for (uint32_t i = 0; i < n; i++) {
    y[i] += a * x[i];
  }
}

void axpy32_rvv(uint32_t n, float a, const float *__restrict x,
              float *__restrict y) {
  for (uint32_t i = 0; i < n;) {
    uint32_t vl = vsetvl_e32m1(n - i);

    vfloat32m1_t x_data = vle32_v_f32m1(&x[i], vl);
    vfloat32m1_t y_data = vle32_v_f32m1(&y[i], vl);
    y_data = vfmacc(y_data, a, x_data, vl);

    vse32_v_f32m1(&y[i], y_data, vl);

    i += vl;
  }
}

void axpy32_rvv2(uint32_t n, float a, const float *__restrict x,
               float *__restrict y) {
  uint32_t vlmax = vsetvlmax_e32m1();
  uint32_t i;
  for (i = 0; i + vlmax < n;) {

    vfloat32m1_t x_data = vle32_v_f32m1(&x[i], vlmax);
    vfloat32m1_t y_data = vle32_v_f32m1(&y[i], vlmax);
    y_data = vfmacc(y_data, a, x_data, vlmax);

    vse32_v_f32m1(&y[i], y_data, vlmax);

    i += vlmax;
  }

  for (; i < n; i++) {
    y[i] += a * x[i];
  }
}
}
