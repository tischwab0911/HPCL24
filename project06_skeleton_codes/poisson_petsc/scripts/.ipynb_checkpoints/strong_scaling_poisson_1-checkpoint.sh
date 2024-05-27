#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=48
#SBATCH --cpus-per-task=1
#SBATCH --tasks-per-node=48
#SBATCH --mem-per-cpu=2G
#SBATCH --output=../strong/poisson1-8192.out
#SBATCH --error=../strong/poisson1-8192.err
#SBATCH --time=4:00:00
#SBATCH --constraint=EPYC_9654

# Warmup runs
# mpirun -np 48 ./../poisson -m 1024
# mpirun -np 48 ./../poisson -m 1024
# mpirun -np 48 ./../poisson -m 1024

for np in 1 2 4 6 8 12 16 20 24 28 32 36 40 44 48; do
    for rep in {1..5}; do
        mpirun -np $np ./../poisson -m 8192
    done
done