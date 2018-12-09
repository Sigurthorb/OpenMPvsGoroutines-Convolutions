#!/bin/bash

#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -t 00:05:00

echo "LIONESS.JPG - cBin"
./shared.sh "cBin" "lioness" "jpg" "OMP_NUM_THREADS"