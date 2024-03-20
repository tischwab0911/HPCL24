#!/bin/bash
#SBATCH --job-name=Loop      # Job name
#SBATCH --output=out/Loop-%j.out # Output file
#SBATCH --error=out/Loop-%j.err  # Error file
#SBATCH --ntasks=1               # Number of tasks
#SBATCH --constraint=EPYC_7763   # Select node with CPU
#SBATCH --cpus-per-task=96        # Number of CPUs per task
#SBATCH --mem-per-cpu=1024       # Memory per CPU
#SBATCH --time=03:00:00          # Wall clock time limit

module load cmake gcc

make clean
make 

echo "Run Sequential Version"
for i in {1..5}; do
  ./recur_seq
done
echo 

for n in 1 2 4 6 8 10 12 14 16 20 24 28 32 36 40 44 48 56 64 72 80 88 96; do
  export OMP_NUM_THREADS=$n
  echo "Run with $n Threads"
  for i in {1..5}; do
    ./recur_omp
  done
done