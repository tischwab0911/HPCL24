#!/bin/bash

#SBATCH --job-name=StrongScalingPDE   #Job name
#SBATCH --output=Weak/SPDE-%j.out
#SBATCH --error=Weak/SPDE-%j.err
#SBAtCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --constraint=EPYC_7763
#SBATCH --time=12:00:00

module load gcc

make clean
make

for i in 1 2 4 6 8 10 12 14 16; do
  export OMP_NUM_THREADS=$i
  for n in 64 128 256 512 1024; do
    for T in {1..5}; do
      ./main $n 100 0.005
    done
  done
done

export OMP_NUM_THREADS=1
./main 2048 10 0.005
./main 4096 10 0.005

for i in 2 4 6 8 10 12 14 16; do
  export OMP_NUM_THREADS=$i
  for n in 2048 4096; do
    for T in {1..3}; do
      ./main $n 10 0.005
    done
  done
done