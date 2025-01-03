#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "common.h"

const int N = 1000;
const int REPEAT = 100;

extern "C" {
void axpy32(uint32_t n, float a, const float *x, float *y);
void axpy32_compiler_vectorize(uint32_t n, float a, const float *x, float *y);
void axpy32_rvv(uint32_t n, float a, const float *x, float *y);
void axpy32_rvv2(uint32_t n, float a, const float *x, float *y);
}

int main() {
  float x[N];
  float y[N];
  float y1[N];
  float y2[N];
  float y3[N];

  // each row has M non zero elements
  for (int i = 0; i < N; i++) {
    x[i] = (float)rand() / RAND_MAX;
    float val = (float)rand() / RAND_MAX;
    y[i] = val;
    y1[i] = val;
    y2[i] = val;
    y3[i] = val;
  }
  float a = (float)rand() / RAND_MAX;

  axpy32(N, a, x, y);
  axpy32_compiler_vectorize(N, a, x, y1);
  axpy32_rvv(N, a, x, y2);
  axpy32_rvv2(N, a, x, y3);

  for (int i = 0; i < N; i++) {
    if (fabs(y[i] - y1[i]) > 1e-6) {
      printf("Mismatch at %d: %lf and %lf\n", i, y[i], y1[i]);
      return 1;
    }
  }

  for (int i = 0; i < N; i++) {
    if (fabs(y[i] - y2[i]) > 1e-6) {
      printf("Mismatch at %d: %lf and %lf\n", i, y[i], y1[i]);
      return 1;
    }
  }

  for (int i = 0; i < N; i++) {
    if (fabs(y[i] - y3[i]) > 1e-6) {
      printf("Mismatch at %d: %lf and %lf\n", i, y[i], y1[i]);
      return 1;
    }
  }

  printf("Test passed!\n");

  uint64_t begin = get_time_us();
  for (int i = 0; i < REPEAT; i++) {
    axpy32(N, a, x, y);
  }
  uint64_t elapsed = get_time_us() - begin;
  double gflops = 2e-3 * N * REPEAT / elapsed;
  printf("axpy32 disable vectorize: %.2f us %.2f gflops\n", (double)elapsed / REPEAT,
         gflops);

  begin = get_time_us();
  for (int i = 0; i < REPEAT; i++) {
    axpy32_compiler_vectorize(N, a, x, y);
  }
  elapsed = get_time_us() - begin;
  gflops = 2e-3 * N * REPEAT / elapsed;
  printf("axpy32 compiler vectorize: %.2f us %.2f gflops\n", (double)elapsed / REPEAT, gflops);

  begin = get_time_us();
  for (int i = 0; i < REPEAT; i++) {
    axpy32_rvv(N, a, x, y);
  }
  elapsed = get_time_us() - begin;
  gflops = 2e-3 * N * REPEAT / elapsed;
  printf("axpy32 rvv: %.2f us %.2f gflops\n", (double)elapsed / REPEAT, gflops);

  begin = get_time_us();
  for (int i = 0; i < REPEAT; i++) {
    axpy32_rvv2(N, a, x, y);
  }
  elapsed = get_time_us() - begin;
  gflops = 2e-3 * N * REPEAT / elapsed;
  printf("axpy32 rvv2: %.2f us %.2f gflops\n", (double)elapsed / REPEAT, gflops);

  return 0;
}
