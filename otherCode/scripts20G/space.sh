#!/bin/bash

#SBATCH -N 1
#SBATCH --exclusive
#SBATCH -t 02:00:00

#. ~/.profile

cd /lustre/cmsc714-1nzb/final/repo

IMAGE="space"
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

    for i in {1..2}
    do
        ./bin/$BIN input/$IMAGE.$EXT output_$IMAGE/${IMAGE}.$EXT $kernel $size $sigma 1> /dev/null
    done
    echo ""
}

function all() {
    run gauss 5 10 3.0
    run gauss 5 20 3.0


    run gauss 13 10 3.0
    run gauss 13 20 3.0


    run gauss 25 10 3.0
    run gauss 25 20 3.0
}

echo "-- $IMAGE -- $BIN -- "
echo "NUM_CPU:"
nproc --all
echo ""
time all
echo "-- $IMAGE -- $BIN -- "



