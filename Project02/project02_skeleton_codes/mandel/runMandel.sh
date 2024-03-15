#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem-per-cpu=1024
#SBATCH --time=0:20:00

#SBATCH --job-name="runMandel"
#SBATCH --output=out/Mandel-%j.out
#SBATCH --error=out/Mandel-%j.err
#SBATCH --constraint=EPYC_9654

module load gcc libpng

make clean
make

export OMP_NUM_THREADS=24
srun ./mandel_omp
#./mandel_seq