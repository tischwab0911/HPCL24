#!/bin/bash
#SBATCH --job-name=scaling_hist_seq      # Job name
#SBATCH --output=out/scaling_hist_seq-%j.out # Output file
#SBATCH --error=out/scaling_hist_seq-%j.err  # Error file
#SBATCH --ntasks=1               # Number of tasks
#SBATCH --constraint=EPYC_7763   # Select node with CPU
#SBATCH --cpus-per-task=48        # Number of CPUs per task
#SBATCH --mem-per-cpu=1024       # Memory per CPU
#SBATCH --time=00:30:00          # Wall clock time limit

# Load some modules & list loaded modules
module load gcc
module list

# Compile
make clean
make

# Run
./hist_seq
echo 

export OMP_NUM_THREADS=1
./hist_omp
echo

export OMP_NUM_THREADS=2
./hist_omp
echo

export OMP_NUM_THREADS=4
./hist_omp
echo

export OMP_NUM_THREADS=8
./hist_omp
echo

export OMP_NUM_THREADS=16
./hist_omp
echo

export OMP_NUM_THREADS=24
./hist_omp
echo

export OMP_NUM_THREADS=32
./hist_omp
echo

export OMP_NUM_THREADS=40
./hist_omp
echo

export OMP_NUM_THREADS=48
./hist_omp