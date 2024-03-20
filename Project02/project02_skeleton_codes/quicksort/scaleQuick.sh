#!/bin/bash

#SBATCH --job-name=Squicksort           # Job name
#SBATCH --output=out/Squicksort-%j.out  # Output file
#SBATCH --error=out/Squicksort-%j.err   # Error file
#SBATCH --ntasks=1                            # Number of tasks
#SBATCH --constraint=EPYC_7763    # Select node with CPU
#SBATCH --cpus-per-task=48        # Number of CPUs per task
#SBATCH --mem-per-cpu=2048        # Memory per CPU
#SBATCH --time=00:10:00           # Wall clock time limit

module load gcc/11.4.0

make clean 
make 

for i in 16 20 24 28 32 36 40 44 48; do
  export OMP_NUM_THREADS=$i
  echo "Running with $i threads"
  for n in 10000000 40000000 80000000 160000000 320000000 640000000; do
    echo "Running with n=$n"
    ./quicksort_omp $n
  done
done
    