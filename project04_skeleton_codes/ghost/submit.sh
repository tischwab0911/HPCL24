#!/bin/bash

#SBATCH --job-name=ghost
#SBATCH --output=out/ghost-%j.out
#SBATCH --error=out/ghost-%j.err
#SBATCH --ntasks=16
#SBATCH --constraint=EPYC_7763
#SBATCH --time=00:05:00

module load gcc openmpi

make clean
make

mpirun ./ghost