#!/bin/bash

#SBATCH -N 1
#SBATCH --mem=5120000
#SBATCH --exclusive
#SBATCH -t 2:00:00

#. ~/.profile

cd /lustre/cmsc714-1nzb/final/repo

IMAGE="house"
EXT="png"
BIN="goBin"
ENV_VAR="GOMAXPROCS"

rm -rf output_$IMAGE/
mkdir -p output_$IMAGE

# Kernel, Size, Num_Threads, Sigma
function run() {
    kernel=$1
    size=$2
    threads=$3
    sigma=$4

    export $ENV_VAR=$threads

    echo "Size: $size - Threads: $threads - Bin: $BIN - Image: $IMAGE.$EXT - kernel: $kernel"

    for i in {1..3}
    do
        ./bin/$BIN input/$IMAGE.$EXT output_$IMAGE/${IMAGE}_${BIN}_n${threads}_$kernel-$size.$EXT $kernel $size $sigma 1> /dev/null
    done
    echo ""
}

echo "-- $IMAGE -- $BIN -- "

run gauss 5 1 1.0
run gauss 5 10 1.0
run gauss 5 20 1.0
run gauss 5 40 1.0


run gauss 13 1 3.0
run gauss 13 10 3.0
run gauss 13 20 3.0
run gauss 13 40 3.0


run gauss 25 1 6.0
run gauss 25 10 6.0
run gauss 25 20 6.0
run gauss 25 40 6.0

echo "-- $IMAGE -- $BIN -- "




