#!/bin/bash

#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -t 04:00:00

#. ~/.profile

cd /lustre/cmsc714-1nzb/final/repo

IMAGE="space"
EXT="png"
BIN1="cBlockBin"
BIN2="cCyckeBin"
ENV_VAR="OMP_NUM_THREADS"

rm -rf output_$IMAGE/
mkdir -p output_$IMAGE

# Kernel, Size, Num_Threads, Sigma
function run() {
    kernel=$1
    size=$2
    threads=$3
    sigma=$4

    export $ENV_VAR=$threads

    echo "Size: $size - Threads: $threads - Bin: $BIN1 - Image: $IMAGE.$EXT - kernel: $kernel"

    for i in {1..3}
    do
        ./bin/$BIN1 input/$IMAGE.$EXT output_$IMAGE/${IMAGE}.$EXT $kernel $size $sigma 1> /dev/null
    done
    echo ""
    echo ""
    echo "Size: $size - Threads: $threads - Bin: $BIN2 - Image: $IMAGE.$EXT - kernel: $kernel"

    for i in {1..3}
    do
        ./bin/$BIN2 input/$IMAGE.$EXT output_$IMAGE/${IMAGE}.$EXT $kernel $size $sigma 1> /dev/null
    done
    echo ""
    echo ""
}

function all() {
    run gauss 5 20 6.0
    echo ""
    run gauss 13 20 6.0
    echo ""
    run gauss 25 20 6.0
    echo ""
}

echo "-- $IMAGE -- $BIN -- "
echo "NUM_CPU:"
echo ""
time all
echo "-- $IMAGE -- $BIN -- "



