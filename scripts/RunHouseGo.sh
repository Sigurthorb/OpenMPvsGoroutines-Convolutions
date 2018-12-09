#!/bin/bash

#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -t 01:20:00

echo "HOUSE.JPG - goBin"
./shared.sh "goBin" "house" "jpg" "GOMAXPROCS"

