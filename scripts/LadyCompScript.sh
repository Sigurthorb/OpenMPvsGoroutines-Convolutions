#!/bin/bash

#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -t 00:00:05

./cShared.sh $1 "lady" "png"

