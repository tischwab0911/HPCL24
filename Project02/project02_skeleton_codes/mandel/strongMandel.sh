#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --time=3:00:00
#SBATCH --job-name="strong scaling mandelbrot"
#SBATCH --output=out/strongMandel-%j.out
#SBATCH --error=out/strongMandel-%j.err
#SBATCH --mem-per-cpu=1024
#SBATCH --constraint=EPYC_7763

# Load modules
module load gcc

# Build Project
make clean
make


export OMP_NUM_THREADS=1

echo "========== RUN Tests 1, 2, 4, 8, 16, 24, 32, 40, 48 =========="
echo "Mandelbrot set Baseline"
./mandel_omp
echo

export OMP_NUM_THREADS=2
echo "Mandelbrot set with 2 Threads"
./mandel_omp
echo

export OMP_NUM_THREADS=4; 
echo "Mandelbrot set with 4 Threads"
./mandel_omp
echo

export OMP_NUM_THREADS=8
echo "Mandelbrot set with 8 Threads"
./mandel_omp
echo 


export OMP_NUM_THREADS=16
echo "Mandelbrot set with 16 Threads"
./mandel_omp
echo

export OMP_NUM_THREADS=24
echo "Mandelbrot set with 24 Threads"
./mandel_omp
echo

export OMP_NUM_THREADS=32
echo "Mandelbrot set with 32 Threads"
./mandel_omp
echo 


export OMP_NUM_THREADS=40
echo "Mandelbrot set with 40 Threads"
./mandel_omp
echo 

export OMP_NUM_THREADS=48
echo "Mandelbrot set with 48 Threads"
./mandel_omp
echo