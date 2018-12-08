#!/bin/bash

#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -t 00:08:00

./cShared.sh $1 "waterfall" "jpg"

