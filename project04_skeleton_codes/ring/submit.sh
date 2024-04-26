#!/bin/bash

#SBATCH --job-name=ringsum
#SBATCH --output=out/ringsum-%j.out
#SBATCH --error=out/ringsum-%j.err
#SBATCH --ntasks=16
#SBATCH --constraint=EPYC_7763
#SBATCH --time=00:05:00

module load gcc openmpi

make clean
make

mpirun -np 2 ./ring_sum
mpirun -np 4 ./ring_sum
mpirun -np 8 ./ring_sum
mpirun -np 16 ./ring_sum