#include "riscv_vector.h"
#include <stdlib.h>

extern "C" {
void spmv32(uint32_t n, const uint32_t *__restrict row,
          const uint32_t *__restrict col, const float *__restrict mat,
          const float *__restrict x, float *__restrict y) {
  for (uint32_t i = 0; i < n; i++) {
    float s = 0;
#pragma clang loop vectorize(disable)
    for (uint32_t p = row[i]; p < row[i + 1]; p++) {
      s += mat[p] * x[col[p]];
    }
    y[i] = s;
  }
}

void spmv32_compiler_vectorize(uint32_t n, const uint32_t *__restrict row,
          const uint32_t *__restrict col, const float *__restrict mat,
          const float *__restrict x, float *__restrict y) {
  for (uint32_t i = 0; i < n; i++) {
    float s = 0;
#pragma clang loop vectorize(enable)
    for (uint32_t p = row[i]; p < row[i + 1]; p++) {
      s += mat[p] * x[col[p]];
    }
    y[i] = s;
  }
}

void spmv32_rvv(uint32_t n, const uint32_t *__restrict row,
              const uint32_t *__restrict col, const float *__restrict mat,
              const float *__restrict x, float *__restrict y) {

  for (uint32_t i = 0; i < n; i++) {
    uint32_t vlmax = vsetvlmax_e32m1();
    vfloat32m1_t s = vfmv_v_f_f32m1(0.0, vlmax);

    uint32_t vl;
    for (uint32_t p = row[i]; p < row[i + 1]; p += vl) {
      vl = vsetvl_e32m1(row[i + 1] - p);
      // load mat[p]
      vfloat32m1_t mat_p = vle32_v_f32m1(&mat[p], vl);

      // compute byte offset
      vuint32m1_t col_p = vle32_v_u32m1(&col[p], vl);
      vuint32m1_t col_p_mul = vmul(col_p, 8, vl);

      // load x[col[p]]
      vfloat32m1_t x_col_p = vluxei32(x, col_p_mul, vl);

      // s += mat[p] * x[col[p]];
      s = vfmacc(s, mat_p, x_col_p, vl);
    }

    vfloat32m1_t sum = vfmv_v_f_f32m1(0.0, vlmax);
    sum = vfredusum(sum, s, sum, vlmax);
    y[i] = vfmv_f_s_f32m1_f32(sum);
  }
}

void spmv32_rvv2(uint32_t n, const uint32_t *__restrict row,
               const uint32_t *__restrict col, const float *__restrict mat,
               const float *__restrict x, float *__restrict y) {

  uint32_t vlmax = vsetvlmax_e32m1();
  for (uint32_t i = 0; i < n; i++) {
    vfloat32m1_t s = vfmv_v_f_f32m1(0.0, vlmax);

    uint32_t p;
    for (p = row[i]; p + vlmax < row[i + 1]; p += vlmax) {
      // load mat[p]
      vfloat32m1_t mat_p = vle32_v_f32m1(&mat[p], vlmax);

      // compute byte offset
      vuint32m1_t col_p = vle32_v_u32m1(&col[p], vlmax);
      vuint32m1_t col_p_mul = vmul(col_p, 8, vlmax);

      // load x[col[p]]
      vfloat32m1_t x_col_p = vluxei32(x, col_p_mul, vlmax);

      // s += mat[p] * x[col[p]];
      s = vfmacc(s, mat_p, x_col_p, vlmax);
    }

    vfloat32m1_t sum = vfmv_v_f_f32m1(0.0, vlmax);
    sum = vfredusum(sum, s, sum, vlmax);

    // the res part
    float res = vfmv_f_s_f32m1_f32(sum);
    for (; p < row[i + 1]; p++) {
      res += mat[p] * x[col[p]];
    }
    y[i] = res;
  }
}
}
