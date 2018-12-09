#!/bin/bash

#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -t 00:30:00

echo "WATERFALL.JPG - goBin-$1"
./shared.sh $1 "waterfall" "jpg" "GOMAXPROCS" 