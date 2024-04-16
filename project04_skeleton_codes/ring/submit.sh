#!/bin/bash

#SBATCH --job-name=ringsum
#SBATCH --output=out/ringsum-%j.out
#SBATCH --error=out/ringsum-%j.err
#SBAtCH --ntasks=6
#SBATCH --cpus-per-task=1
#SBATCH --constraint=EPYC_7763
#SBATCH --time=00:01:00

mpirun ring_sum