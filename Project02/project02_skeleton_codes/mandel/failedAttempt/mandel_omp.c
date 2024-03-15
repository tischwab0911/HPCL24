#include <stdio.h>
#include <stdlib.h>

#include <sys/time.h>
#include <time.h>
#include <unistd.h>
#include <math.h>
#include <png.h>
#include <omp.h>
#include <complex.h>

#include "consts.h"
#include "pngwriter.h"
#include "walltime.h"

double max(double a, double b) {

  return (a > b) ? a : b;

}

int main(int argc, char **argv) {
  png_data *pPng = png_create(IMAGE_WIDTH, IMAGE_HEIGHT);

  //double x, y, x2, y2, cx, cy;

  double fDeltaX = (MAX_X - MIN_X) / (double)IMAGE_WIDTH;
  double fDeltaY = (MAX_Y - MIN_Y) / (double)IMAGE_HEIGHT;
  // double *rgbvals = (double *)malloc(IMAGE_WIDTH*IMAGE_HEIGHT * sizeof(double));

  long nTotalIterationsCount = 0;

  long i, j;

  double time_start = walltime();
  // do the calculation
  #pragma omp parallel private(linear_index, cx, cy, i, j, c, z, n) \
            shared(pPng) \
            firstprivate(nTotalIterationsCount)
  {
    // int num_threads = omp_get_max_threads();
    // int thread_id = omp_get_thread_num();
    // int partition = IMAGE_HEIGHT/num_threads;
    // if(thread_id = num_threads-1){
    //   partition = IMAGE_HEIGHT - (num_threads-1) * partition;
    // }
    // int start = partition * thread_id;
    // png_data *pPngLoc = png_create(IMAGE_WIDTH, IMAGE_HEIGHT);
    long nLocalIterationsCount = 0;
    // double *rgbvals = (double *)malloc(IMAGE_WIDTH* partition * sizeof(double));

    int linear_index;
    #pragma omp parallel for
    for (linear_index = 0; linear_index < IMAGE_HEIGHT * IMAGE_WIDTH; ++linear_index) {
      int i = linear_index % IMAGE_WIDTH;
      int j = linear_index / IMAGE_WIDTH;
      double cx = MIN_X + i * fDeltaX;
      double cy = MIN_Y + j * fDeltaY;
      double complex c = cx + I * cy;
      double complex z = 0. + I * 0.;
      // compute the orbit z, f(z), f^2(z), f^3(z), ...
      // count the iterations until the orbit leaves the circle |z|=2.
      // stop if the number of iterations exceeds the bound MAX_ITERS.
      int n = 0;

      while ((n < MAX_ITERS) && (cabs(z) < 2)) {
        // (zx+ izy) * (zx+ izy) + (cx + icy) = (zx^2 - zy^2 + cx + i(2*zx*zy+ cy))
        z = z * z + c;
        ++n;
      }
      nLocalIterationsCount += n;
      int cn = ((long)n * 255) / MAX_ITERS;
      // rgbvals[j * n + i] = cn;
      #pragma omp simd
      png_plot(pPng, i, j, cn, cn, cn);
    }
    #pragma omp critical
    {
       nTotalIterationsCount += nLocalIterationsCount;
    }
    //for(int j = 0; j <)
  }
  double time_end = walltime();

  // print benchmark data
  printf("Total time:                 %g seconds\n",
         (time_end - time_start));
  printf("Image size:                 %ld x %ld = %ld Pixels\n",
         (long)IMAGE_WIDTH, (long)IMAGE_HEIGHT,
         (long)(IMAGE_WIDTH * IMAGE_HEIGHT));
  printf("Total number of iterations: %ld\n", nTotalIterationsCount);
  printf("Avg. time per pixel:        %g seconds\n",
         (time_end - time_start) / (double)(IMAGE_WIDTH * IMAGE_HEIGHT));
  printf("Avg. time per iteration:    %g seconds\n",
         (time_end - time_start) / (double)nTotalIterationsCount);
  printf("Iterations/second:          %g\n",
         nTotalIterationsCount / (time_end - time_start));
  // assume there are 8 floating point operations per iteration
  printf("MFlop/s:                    %g\n",
         nTotalIterationsCount * 8.0 / (time_end - time_start) * 1.e-6);

  png_write(pPng, "mandel.png");
  return 0;
}
