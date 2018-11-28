#!/bin/bash

#SBATCH -N 1
#SBATCH --mem=140000
#SBATCH --exclusive
#SBATCH -t 01:30:00

#. ~/.profile

cd /lustre/cmsc714-1nzb/final/repo

IMAGE="space"
EXT="png"
BIN="cBin"
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

    echo "Size: $size - Threads: $threads - Bin: $BIN - Image: $IMAGE.$EXT - kernel: $kernel"

    for i in {1..2}
    do
        ./bin/$BIN input/$IMAGE.$EXT output_$IMAGE/${IMAGE}.$EXT $kernel $size $sigma 1> /dev/null
    done
    echo ""
}

function all() {
    run gauss 5 20 3.0
    run gauss 5 40 3.0


    run gauss 13 20 3.0
    run gauss 13 40 3.0


    run gauss 25 20 3.0
    run gauss 25 40 3.0
}

echo "-- $IMAGE -- $BIN -- "
time all
echo "-- $IMAGE -- $BIN -- "


