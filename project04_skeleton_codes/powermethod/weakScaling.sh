#!/bin/bash

#SBATCH --nodes=64
#SBATCH --ntasks=64
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --output=strong/power-%j.out
#SBATCH --error=strong/power-%j.err
#SBATCH --time=12:00:00

base_size=1000

for p in 1 2 4 8 16 32 64; do
    for rep in {1..5}; do
      scaled_size=$((base_size * (p ^ (1/2))))
      mpirun -np $p ./powermethod_rows 3 $scaled_size 1000 -1e-6
    done
done
