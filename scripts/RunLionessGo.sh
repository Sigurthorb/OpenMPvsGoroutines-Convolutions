#!/bin/bash

#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -t 00:06:00

echo "LIONESS.JPG - goBin"
./shared.sh "goBin" "lioness" "jpg" "GOMAXPROCS"