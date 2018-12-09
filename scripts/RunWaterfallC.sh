#!/bin/bash

#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -t 00:16:00

echo "WATERFALL.JPG - cBin"
./shared.sh "cBin" "waterfall" "jpg" "OMP_NUM_THREADS"