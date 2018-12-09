#!/bin/bash

#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -t 00:30:00

echo "LIONESS.JPG - goBin"
./shared.sh "goBin" "lioness" "jpg" "GOMAXPROCS"