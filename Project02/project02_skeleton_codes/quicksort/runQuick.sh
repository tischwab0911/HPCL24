#!/bin/bash

#SBATCH --job-name=quicksort           # Job name
#SBATCH --output=out/quicksort-%j.out  # Output file
#SBATCH --error=out/quicksort-%j.err   # Error file
#SBATCH --ntasks=1                            # Number of tasks
#SBATCH --constraint=EPYC_7763    # Select node with CPU
#SBATCH --cpus-per-task=48        # Number of CPUs per task
#SBATCH --mem-per-cpu=1024        # Memory per CPU
#SBATCH --time=06:00:00           # Wall clock time limit

module load gcc/11.4.0

make clean
make 

# for i in 2 4 6 8 10 12 16; do
#   export OMP_NUM_THREADS=$i
#   echo "Running with $i threads"
#   for n in 5000000 10000000 20000000 40000000; do
#     echo "Running with n=$n"
#     for fin in 2 5 10 15 20 25 32 40; do
#       echo "Running with Termination=$fin"
#       for rep in {1..5}; do
#         ./quicksort_omp $fin $n
#       done
#     done
#   done
# done

for n in 5000000 10000000 20000000 40000000; do
  for rep in {1..5}; do
    ./quicksort_omp 1 $n
  done
done