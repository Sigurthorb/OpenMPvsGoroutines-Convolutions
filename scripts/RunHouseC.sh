#!/bin/bash

#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -t 03:10:00

echo "HOUSE.JPG - cBin"
./shared.sh "cBin" "house" "jpg" "OMP_NUM_THREADS"

