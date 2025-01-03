#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "common.h"

const int N = 1000;
const int REPEAT = 100;

extern "C" {
void axpy32int(uint32_t n, int a, const int *x, int *y);
void axpy32int_compiler_vectorize(uint32_t n, int a, const int *x, int *y);
void axpy32int_rvv(uint32_t n, int a, const int *x, int *y);
void axpy32int_rvv2(uint32_t n, int a, const int *x, int *y);
}

int main() {
  int x[N];
  int y[N];
  int y1[N];
  int y2[N];
  int y3[N];

  // each row has M non zero elements
  for (int i = 0; i < N; i++) {
    x[i] = (int)rand() / RAND_MAX;
    int val = (int)rand() / RAND_MAX;
    y[i] = val;
    y1[i] = val;
    y2[i] = val;
    y3[i] = val;
  }
  int a = (int)rand() / RAND_MAX;

  axpy32int(N, a, x, y);
  axpy32int_compiler_vectorize(N, a, x, y1);
  axpy32int_rvv(N, a, x, y2);
  axpy32int_rvv2(N, a, x, y3);

  for (int i = 0; i < N; i++) {
    if (fabs(y[i] - y1[i]) > 1e-6) {
      printf("Mismatch at %d: %d and %d\n", i, y[i], y1[i]);
      return 1;
    }
  }

  for (int i = 0; i < N; i++) {
    if (fabs(y[i] - y2[i]) > 1e-6) {
      printf("Mismatch at %d: %d and %d\n", i, y[i], y2[i]);
      return 1;
    }
  }

  for (int i = 0; i < N; i++) {
    if (fabs(y[i] - y3[i]) > 1e-6) {
      printf("Mismatch at %d: %d and %d\n", i, y[i], y3[i]);
      return 1;
    }
  }

  printf("Test passed!\n");

  uint64_t begin = get_time_us();
  for (int i = 0; i < REPEAT; i++) {
    axpy32int(N, a, x, y);
  }
  uint64_t elapsed = get_time_us() - begin;
  double gflops = 2e-3 * N * REPEAT / elapsed;
  printf("axpy32 disable vectorize: %.2f us %.2f gflops\n", (double)elapsed / REPEAT,
         gflops);

  begin = get_time_us();
  for (int i = 0; i < REPEAT; i++) {
    axpy32int_compiler_vectorize(N, a, x, y);
  }
  elapsed = get_time_us() - begin;
  gflops = 2e-3 * N * REPEAT / elapsed;
  printf("axpy32 compiler vectorize: %.2f us %.2f gflops\n", (double)elapsed / REPEAT, gflops);

  begin = get_time_us();
  for (int i = 0; i < REPEAT; i++) {
    axpy32int_rvv(N, a, x, y);
  }
  elapsed = get_time_us() - begin;
  gflops = 2e-3 * N * REPEAT / elapsed;
  printf("axpy32 rvv: %.2f us %.2f gflops\n", (double)elapsed / REPEAT, gflops);

  begin = get_time_us();
  for (int i = 0; i < REPEAT; i++) {
    axpy32int_rvv2(N, a, x, y);
  }
  elapsed = get_time_us() - begin;
  gflops = 2e-3 * N * REPEAT / elapsed;
  printf("axpy32 rvv2: %.2f us %.2f gflops\n", (double)elapsed / REPEAT, gflops);

  return 0;
}
