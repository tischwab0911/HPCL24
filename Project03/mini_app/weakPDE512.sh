#!/bin/bash

#SBATCH --job-name=StrongScalingPDE   #Job name
#SBATCH --output=Weak/SPDE-%j.out
#SBATCH --error=Weak/SPDE-%j.err
#SBAtCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --constraint=EPYC_7763
#SBATCH --time=12:00:00

module load gcc

make clean
make

export OMP_NUM_THREADS=1
./main 512 100 0.005
./main 512 100 0.005
./main 512 100 0.005
./main 512 100 0.005
./main 512 100 0.005

export OMP_NUM_THREADS=4
./main 1024 100 0.005
./main 1024 100 0.005
./main 1024 100 0.005
./main 1024 100 0.005
./main 1024 100 0.005

export OMP_NUM_THREADS=16
./main 2048 100 0.005
./main 2048 100 0.005
./main 2048 100 0.005
./main 2048 100 0.005
./main 2048 100 0.005

export OMP_NUM_THREADS=64
./main 4096 100 0.005
./main 4096 100 0.005
./main 4096 100 0.005
./main 4096 100 0.005
./main 4096 100 0.005