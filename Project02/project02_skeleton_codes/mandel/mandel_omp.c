#include <stdio.h>
#include <stdlib.h>

#include <sys/time.h>
#include <time.h>
#include <unistd.h>
#include <math.h>
#include <png.h>
#include <complex.h>
#include <omp.h>

#include "consts.h"
#include "pngwriter.h"
#include "walltime.h"

int main(int argc, char **argv) {
  png_data *pPng = png_create(IMAGE_WIDTH, IMAGE_HEIGHT);
  png_bytepp Data = pPng->pPixels;
  //double x, y, x2, y2, cx, cy;

  double fDeltaX = (MAX_X - MIN_X) / (double)IMAGE_WIDTH;
  double fDeltaY = (MAX_Y - MIN_Y) / (double)IMAGE_HEIGHT;

  long nTotalIterationsCount = 0;

//   long i, j;

  double time_start = walltime();
  // do the calculation
  #pragma omp parallel
  {
    long nLocalIterationsCount = 0;
    #pragma omp for \
            schedule(dynamic)
    for (long index = 0; index < IMAGE_HEIGHT * IMAGE_WIDTH; ++index) {
        long j = index / IMAGE_WIDTH;
        long i = index % IMAGE_WIDTH;
        double cy = MIN_Y + j * fDeltaY;
        double cx = MIN_X + i * fDeltaX;
        double complex cc = cx + I * cy;
        double complex z = 0. + I * 0.;
        // compute the orbit z, f(z), f^2(z), f^3(z), ...
        // count the iterations until the orbit leaves the circle |z|=2.
        // stop if the number of iterations exceeds the bound MAX_ITERS.
        int n = 0;

       //  while ((n < MAX_ITERS) && (cabs(z) < 2)) {
       //    // (zx+ izy) * (zx+ izy) + (cx + icy) = (zx^2 - zy^2 + cx + i(2*zx*zy+ cy))
       //    z = z * z + cc;
       //    ++n;
       //  }
        int nn = 0;
        for(n = 0; n < MAX_ITERS; ++n){
          z = z * z + cc;
          if(cabs(z) >= 2) break;
        }
        nLocalIterationsCount += n;
        //nLocalIterationsCount+=n;
        // <<<<<<<< CODE IS MISSING
        // n indicates if the point belongs to the mandelbrot set
        // plot the number of iterations at point (i, j)
        int c = ((long)n * 255) / MAX_ITERS;
        Data[IMAGE_HEIGHT - j - 1][3 * i - 3] = (char) c;
        Data[IMAGE_HEIGHT - j - 1][3 * i - 2] = (char) c;
        Data[IMAGE_HEIGHT - j - 1][3 * i - 1] = (char) c;
        //png_plot(pPng, i, j, c, c, c);
      }
    #pragma omp critical
    {
       nTotalIterationsCount += nLocalIterationsCount;
    }
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
