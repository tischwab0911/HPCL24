#!/bin/bash

#SBATCH --nodes=64
#SBATCH --ntasks=64
#SBATCH --cpus-per-task=1
#SBATCH --tasks-per-node=1
#SBATCH --output=./../strong/poisson64-%j.out
#SBATCH --error=./..strong/poisson64-%j.err
#SBATCH --time=18:00:00
#SBATCH --constraint=EPYC_7763

for np in 1 2 4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64; do
    for rep in {1..5}; do
        mpirun -np $np ./poisson -m 1024
    done
done
