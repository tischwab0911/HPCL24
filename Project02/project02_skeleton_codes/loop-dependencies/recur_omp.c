#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "walltime.h"
#include <omp.h>

int main(int argc, char *argv[]) {
  int N = 2000000000;
  double up = 1.00000001;
  double Sn = 1.00000001;
  //int n;

  /* allocate memory for the recursion */
  double *opt = (double *)malloc((N + 1) * sizeof(double));
  if (opt == NULL) {
    perror("failed to allocate problem size");
    exit(EXIT_FAILURE);
  }

  double time_start = walltime();
  // TODO: YOU NEED TO PARALLELIZE THIS LOOP
  double lastSn = 0.;
  #pragma omp parallel 
  {
    int tid = omp_get_thread_num();
    int nthreads = omp_get_num_threads();
    int partition = N / nthreads;

    int start = tid * partition;
    int end;
    if(tid == nthreads-1){
      end = N;
    } else {
      end = (N+1)/nthreads;
    }
    // The only expensive operation required
    double base = Sn * pow(up, start);
    //#pragma omp for
    for (int n = start; n <= end; ++n) {
      opt[n] = base;
      base *= up;
    }
    if(tid == nthreads-1){
      lastSn = base;
    }
  }

  printf("Parallel RunTime  :  %f seconds\n", walltime() - time_start);
  printf("Final Result Sn   :  %.17g \n", lastSn);

  double temp = 0.0;
  for (int n = 0; n <= N; ++n) {
    temp += opt[n] * opt[n];
  }
  printf("Result ||opt||^2_2 :  %f\n", temp / (double)N);
  printf("\n");

  return 0;
}
