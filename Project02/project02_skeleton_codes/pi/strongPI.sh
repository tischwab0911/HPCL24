#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --time=0:20:00
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
echo

echo "========== RUN CRITICAL 1, 2, 4, 8, 16, 24, 32, 40, 48 =========="
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
echo ";"

export OMP_NUM_THREADS=2

./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
echo ";"

export OMP_NUM_THREADS=4; 

./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
echo ";"

export OMP_NUM_THREADS=8

./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
echo ";"


export OMP_NUM_THREADS=16

./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
echo ";"

export OMP_NUM_THREADS=24

./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
echo ";"

export OMP_NUM_THREADS=32

./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
echo ";"


export OMP_NUM_THREADS=40

./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
echo ";"

export OMP_NUM_THREADS=48

./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
./pi_omp_critical 1000000000
echo
echo

export OMP_NUM_THREADS=1

echo "=========== RUN REDUCE with 1, 2, 4, 8, 16, 24, 32, 40, 48 threads ==========="
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
echo ";"

export OMP_NUM_THREADS=2

./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
echo ";"

export OMP_NUM_THREADS=4; 

./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
echo ";" 

export OMP_NUM_THREADS=8

./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
echo ";"

export OMP_NUM_THREADS=16

./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
echo ";"

export OMP_NUM_THREADS=24

./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
echo ";"

export OMP_NUM_THREADS=32

./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
echo ";"

export OMP_NUM_THREADS=40

./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
echo ";"

export OMP_NUM_THREADS=48

./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
./pi_omp_reduction 1000000000
echo 
echo

make clean