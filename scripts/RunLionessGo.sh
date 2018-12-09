#!/bin/bash

#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -t 00:30:00

echo "LIONESS.JPG - goBin-$1"
./shared.sh $1 "lioness" "jpg" "GOMAXPROCS"