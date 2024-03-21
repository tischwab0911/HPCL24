#!/bin/bash

#SBATCH --job-name=Weak_Scaling_quicksort           # Job name
#SBATCH --output=Weak/Squicksort-%j.out  # Output file
#SBATCH --error=Weak/Squicksort-%j.err   # Error file
#SBATCH --ntasks=1                            # Number of tasks
#SBATCH --constraint=EPYC_7763    # Select node with CPU
#SBATCH --cpus-per-task=36        # Number of CPUs per task
#SBATCH --mem-per-cpu=1024        # Memory per CPU
#SBATCH --time=06:00:00           # Wall clock time limit

module load gcc/11.4.0

make clean 
make 

# for i in 16 20 24 28 32 36 40 44 48; do
#   export OMP_NUM_THREADS=$i
#   echo "Running with $i threads"
#   for n in 10000000 40000000 80000000 160000000 320000000 640000000; do
#     echo "Running with n=$n"
#     ./quicksort_omp $n
#   done
# done

for i in 20 24 28 32 36; do
  export OMP_NUM_THREADS=$i
  echo "Running with $i Threads"
  for n in 5000000 10000000; do
    echo "Running with $n Size"
    for T in 50 100 150 250 500; do
      echo "Running with $T as threshold"
      for j in {1..5}; do
        ./quicksort_omp_mergeable $T $n $i
      done
    done
  done
done
    