#!/bin/bash

#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -t 03:00:00

./cShared.sh $1 "house" "jpg"

