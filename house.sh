#!/bin/bash

#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -t 1:00:00

. ~/.profile

rm -rf output/
mkdir -p output

export OMP_NUM_THREADS=1
srun ./bin/cBin input/house.png output/house_n1_m1.png mean 1
srun ./bin/cBin input/house.png output/house_n1_m5.png mean 5
srun ./bin/cBin input/house.png output/house_n1_m11.png mean 11
srun ./bin/cBin input/house.png output/house_n1_m17.png mean 17
srun ./bin/cBin input/house.png output/house_n1_m25.png mean 25

export OMP_NUM_THREADS=4
srun ./bin/cBin input/house.png output/house_n4_m1.png mean 1
srun ./bin/cBin input/house.png output/house_n4_m5.png mean 5
srun ./bin/cBin input/house.png output/house_n4_m11.png mean 11
srun ./bin/cBin input/house.png output/house_n4_m17.png mean 17
srun ./bin/cBin input/house.png output/house_n4_m25.png mean 25

export OMP_NUM_THREADS=8
srun ./bin/cBin input/house.png output/house_n8_m1.png mean 1
srun ./bin/cBin input/house.png output/house_n8_m5.png mean 5
srun ./bin/cBin input/house.png output/house_n8_m11.png mean 11
srun ./bin/cBin input/house.png output/house_n8_m17.png mean 17
srun ./bin/cBin input/house.png output/house_n8_m25.png mean 25

export OMP_NUM_THREADS=12
srun ./bin/cBin input/house.png output/house_n12_m1.png mean 1
srun ./bin/cBin input/house.png output/house_n12_m5.png mean 5
srun ./bin/cBin input/house.png output/house_n12_m11.png mean 11
srun ./bin/cBin input/house.png output/house_n12_m17.png mean 17
srun ./bin/cBin input/house.png output/house_n12_m25.png mean 25

export OMP_NUM_THREADS=16

srun ./bin/cBin input/house.png output/house_n16_m1.png mean 1
srun ./bin/cBin input/house.png output/house_n16_m5.png mean 5
srun ./bin/cBin input/house.png output/house_n16_m11.png mean 11
srun ./bin/cBin input/house.png output/house_n16_m17.png mean 17
srun ./bin/cBin input/house.png output/house_n16_m25.png mean 25

export OMP_NUM_THREADS=20
srun ./bin/cBin input/house.png output/house_n20_m1.png mean 1
srun ./bin/cBin input/house.png output/house_n20_m5.png mean 5
srun ./bin/cBin input/house.png output/house_n20_m11.png mean 11
srun ./bin/cBin input/house.png output/house_n20_m17.png mean 17
srun ./bin/cBin input/house.png output/house_n20_m25.png mean 25



