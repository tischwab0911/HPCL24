#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=0:05:00
#SBATCH --job-name="runPI"
#SBATCH --output=out/PI-%j.out
#SBATCH --error=out/PI-%j.err
#SBATCH --mem-per-cpu=1024
#SBATCH --constraint=EPYC_7763

# Load modules
module load gcc

# Set environment variables
export OMP_NUM_THREADS=4; 

# Build Project
make clean
make

echo "=========== RUN SERIAL ==========="
./pi_serial 
echo

echo "========== RUN CRITICAL =========="
./pi_omp_critical
echo

echo "=========== RUN REDUCE ==========="
./pi_omp_reduction
echo

make clean