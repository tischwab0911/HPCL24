#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --time=0:10:00
#SBATCH --job-name="runPI"
#SBATCH --output=out/PI-%j.out
#SBATCH --error=out/PI-%j.err
#SBATCH --mem-per-cpu=1024
#SBATCH --constraint=EPYC_7763

# Load modules
module load gcc

# Build Project
make clean
make


export OMP_NUM_THREADS=1

echo "=========== RUN SERIAL 5 times with 1 thread  ==========="
./pi_serial 1000000000
./pi_serial 1000000000
./pi_serial 1000000000
./pi_serial 1000000000
./pi_serial 1000000000
echo

echo "========== RUN CRITICAL 3 times with 1 thread =========="
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
echo

echo "=========== RUN REDUCE 3 times with 1 thread ==========="
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
echo

export OMP_NUM_THREADS=2

echo "========== RUN CRITICAL 5 times with 2 threads =========="
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
echo

echo "=========== RUN REDUCE 5 times with 2 threads ==========="
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
echo

export OMP_NUM_THREADS=4; 

echo "========== RUN CRITICAL 5 times with 4 threads =========="
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
echo

echo "=========== RUN REDUCE 5 times with 4 threads ==========="
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
echo

export OMP_NUM_THREADS=8

echo "========== RUN CRITICAL 5 times with 8 threads =========="
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
echo

echo "=========== RUN REDUCE 5 times with 8 threads ==========="
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
echo

export OMP_NUM_THREADS=16

echo "========== RUN CRITICAL 5 times with 16 threads =========="
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
echo

echo "=========== RUN REDUCE 5 times with 16 threads ==========="
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
echo

export OMP_NUM_THREADS=32

echo "========== RUN CRITICAL 5 times with 32 threads =========="
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
echo

echo "=========== RUN REDUCE 5 times with 32 threads ==========="
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
echo

make clean