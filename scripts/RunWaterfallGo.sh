#!/bin/bash

#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -t 00:30:00

echo "WATERFALL.JPG - goBin"
./shared.sh "goBin" "waterfall" "jpg" "GOMAXPROCS" 