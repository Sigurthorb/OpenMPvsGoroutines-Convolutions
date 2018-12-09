#!/bin/bash

#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -t 00:14:00

echo "LIONESS.JPG - $1"
./shared.sh $1 "lioness" "jpg" "OMP_NUM_THREADS"