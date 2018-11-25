#!/bin/bash

#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -t 0:30

. ~/.profile

rm -rf outputLady/
mkdir -p outputLady

export GOMAXPROCS=1
srun ./bin/goBin input/lady.png outputLady/lady_n1_m1.png mean 1
srun ./bin/goBin input/lady.png outputLady/lady_n1_m5.png mean 5
srun ./bin/goBin input/lady.png outputLady/lady_n1_m11.png mean 11
srun ./bin/goBin input/lady.png outputLady/lady_n1_m17.png mean 17
srun ./bin/goBin input/lady.png outputLady/lady_n1_m25.png mean 25

export GOMAXPROCS=4
srun ./bin/goBin input/lady.png outputLady/lady_n4_m1.png mean 1
srun ./bin/goBin input/lady.png outputLady/lady_n4_m5.png mean 5
srun ./bin/goBin input/lady.png outputLady/lady_n4_m11.png mean 11
srun ./bin/goBin input/lady.png outputLady/lady_n4_m17.png mean 17
srun ./bin/goBin input/lady.png outputLady/lady_n4_m25.png mean 25

export GOMAXPROCS=8
srun ./bin/goBin input/lady.png outputLady/lady_n8_m1.png mean 1
srun ./bin/goBin input/lady.png outputLady/lady_n8_m5.png mean 5
srun ./bin/goBin input/lady.png outputLady/lady_n8_m11.png mean 11
srun ./bin/goBin input/lady.png outputLady/lady_n8_m17.png mean 17
srun ./bin/goBin input/lady.png outputLady/lady_n8_m25.png mean 25

export GOMAXPROCS=12
srun ./bin/goBin input/lady.png outputLady/lady_n12_m1.png mean 1
srun ./bin/goBin input/lady.png outputLady/lady_n12_m5.png mean 5
srun ./bin/goBin input/lady.png outputLady/lady_n12_m11.png mean 11
srun ./bin/goBin input/lady.png outputLady/lady_n12_m17.png mean 17
srun ./bin/goBin input/lady.png outputLady/lady_n12_m25.png mean 25

export GOMAXPROCS=16
srun ./bin/goBin input/lady.png outputLady/lady_n16_m1.png mean 1
srun ./bin/goBin input/lady.png outputLady/lady_n16_m5.png mean 5
srun ./bin/goBin input/lady.png outputLady/lady_n16_m11.png mean 11
srun ./bin/goBin input/lady.png outputLady/lady_n16_m17.png mean 17
srun ./bin/goBin input/lady.png outputLady/lady_n16_m25.png mean 25

export GOMAXPROCS=20
srun ./bin/goBin input/lady.png outputLady/lady_n20_m1.png mean 1
srun ./bin/goBin input/lady.png outputLady/lady_n20_m5.png mean 5
srun ./bin/goBin input/lady.png outputLady/lady_n20_m11.png mean 11
srun ./bin/goBin input/lady.png outputLady/lady_n20_m17.png mean 17
srun ./bin/goBin input/lady.png outputLady/lady_n20_m25.png mean 25




