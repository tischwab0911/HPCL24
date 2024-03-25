#include <stdio.h> /* printf */
#include <stdlib.h> /* atol */
#include "walltime.h"

int main(int argc, char *argv[]) {
  long int N = 1000000;
  double time_start, h, sum, pi;

  if ( argc > 1 ) N = atol(argv[1]);

  /* Parallelize with OpenMP using the critical directive */
  time_start = walltime();
  h = 1./N;
  sum = 0.;

  #pragma omp parallel 
  {
    double sumLoc = 0.;

    #pragma omp for
    for(int i = 0; i < N; ++i) {
      double x = (i + 0.5)*h;
      sumLoc += 4.0 / (1.0 + x*x);
    }

    #pragma omp critical
    {
      sum += sumLoc;
    }
  }
  pi = sum*h;
  double time = walltime() - time_start;

  printf("pi = \%.15f, N = %9d, time = %.8f secs\n", pi, N, time);
  printf("%.8f ", time);

  return 0;
}
