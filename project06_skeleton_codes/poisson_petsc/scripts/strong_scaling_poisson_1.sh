#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=48
#SBATCH --cpus-per-task=1
#SBATCH --tasks-per-node=64
#SBATCH --mem-per-cpu=2G
#SBATCH --output=../strong/poisson1-%j.out
#SBATCH --error=../strong/poisson1-%j.err
#SBATCH --time=6:00:00
#SBATCH --constraint=EPYC_7763

for np in 1 2 4 6 8 12 16 20 24 28 32 36 40 44 48; do
    for rep in {1..5}; do
        mpirun -np $np ./../poisson -m 6144
    done
done

#mpirun -np 16 ./../poisson -m 1024