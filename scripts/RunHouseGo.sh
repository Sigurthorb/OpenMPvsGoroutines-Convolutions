#!/bin/bash

#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -t 03:00:00

echo "HOUSE.JPG - goBin-$1"
./shared.sh $1 "house" "jpg" "GOMAXPROCS"

