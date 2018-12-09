#!/bin/bash

#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -t 01:30:00

echo "HOUSE.JPG - $1"
./shared.sh $1 "house" "jpg" "OMP_NUM_THREADS"

