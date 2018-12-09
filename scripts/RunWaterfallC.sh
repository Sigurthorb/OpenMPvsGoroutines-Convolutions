#!/bin/bash

#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -t 00:16:00

echo "WATERFALL.JPG - $1"
./shared.sh $1 "waterfall" "jpg" "OMP_NUM_THREADS"