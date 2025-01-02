#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "common.h"

const int N = 1000;
const int M = 10;
const int REPEAT = 100;

extern "C" {
void spmv32(uint32_t n, const uint32_t *row, const uint32_t *col,
          const float *mat, const float *x, float *y);
void spmv32_compiler_vectorize(uint32_t n, const uint32_t *row,
                             const uint32_t *col, const float *mat,
                             const float *x, float *y);
void spmv32_rvv(uint32_t n, const uint32_t *row, const uint32_t *col,
              const float *mat, const float *x, float *y);
void spmv32_rvv2(uint32_t n, const uint32_t *row, const uint32_t *col,
               const float *mat, const float *x, float *y);
}

int main() {
  uint32_t row[N + 1];
  uint32_t col[N * M];
  float mat[N * M];
  float x[N];

  float y[N];
  float y1[N];

  // each row has M non zero elements
  for (int i = 0; i < N; i++) {
    row[i] = i * M;
    for (int j = 0; j < M; j++) {
      mat[i * M + j] = (float)rand() / RAND_MAX;
      col[i * M + j] = rand() % N;
    }
    x[i] = (float)rand() / RAND_MAX;
    y[i] = 0.0;
    y1[i] = 0.0;
  }
  row[N] = M * N;

  spmv32(N, row, col, mat, x, y);

  spmv32_compiler_vectorize(N, row, col, mat, x, y1);

  for (int i = 0; i < N; i++) {
    if (fabs(y[i] - y1[i]) > 1e-6) {
      printf("Mismatch at %d: %lf and %lf\n", i, y[i], y1[i]);
      return 1;
    }
  }

  // check answer
  spmv32_rvv(N, row, col, mat, x, y1);

  for (int i = 0; i < N; i++) {
    if (fabs(y[i] - y1[i]) > 1e-6) {
      printf("Mismatch at %d: %lf and %lf\n", i, y[i], y1[i]);
      return 1;
    }
  }

  spmv32_rvv2(N, row, col, mat, x, y1);
  for (int i = 0; i < N; i++) {
    if (fabs(y[i] - y1[i]) > 1e-6) {
      printf("Mismatch at %d: %lf and %lf\n", i, y[i], y1[i]);
      return 1;
    }
  }

  printf("Test passed!\n");

  uint32_t begin = get_time_us();
  for (int i = 0; i < REPEAT; i++) {
    spmv32(N, row, col, mat, x, y1);
  }
  uint32_t elapsed = get_time_us() - begin;
  float gflops = 2e-3 * N * M * REPEAT / elapsed;
  printf("spmv32 disable vectorize: %.2f us %.2f gflops\n", (float)elapsed / REPEAT,
         gflops);

  begin = get_time_us();
  for (int i = 0; i < REPEAT; i++) {
    spmv32_compiler_vectorize(N, row, col, mat, x, y1);
  }
  elapsed = get_time_us() - begin;
  gflops = 2e-3 * N * M * REPEAT / elapsed;
  printf("spmv32 compiler vectorize: %.2f us %.2f gflops\n", (float)elapsed / REPEAT, gflops);

  begin = get_time_us();
  for (int i = 0; i < REPEAT; i++) {
    spmv32_rvv(N, row, col, mat, x, y1);
  }
  elapsed = get_time_us() - begin;
  gflops = 2e-3 * N * M * REPEAT / elapsed;
  printf("spmv32 rvv: %.2f us %.2f gflops\n", (float)elapsed / REPEAT, gflops);

  begin = get_time_us();
  for (int i = 0; i < REPEAT; i++) {
    spmv32_rvv2(N, row, col, mat, x, y1);
  }
  elapsed = get_time_us() - begin;
  gflops = 2e-3 * N * M * REPEAT / elapsed;
  printf("spmv32 rvv2: %.2f us %.2f gflops\n", (float)elapsed / REPEAT, gflops);

  return 0;
}
