#!/bin/bash

#SBATCH -N 1
#SBATCH --mem=140000
#SBATCH --exclusive
#SBATCH -t 03:30:00

cd /lustre/cmsc714-1nzb/final/repoMaster
#cd ..

ENV_VAR="OMP_NUM_THREADS"

bin="cBin"
img1="space"
ext1="png"

# Kernel, Size, Num_Threads, Sigma
function run() {
    binary=$1
    img=$2
    ext=$3
    kernel=$4
    size=$5
    threads=$6
    sigma=$7

    export $ENV_VAR=$threads

    echo "Size: $size - Threads: $threads"

    for i in {1..3}
    do
        ./bin/$binary input/$img.$ext output/img.$ext $kernel $size $sigma 1> /dev/null
    done
    echo ""
    echo ""
}

SECONDS=0
# BINARY IMAGENAME TYPE SIZE
echo "-- $bin -- $img1.$ext1 -- Cores: `cat /proc/cpuinfo | awk '/^processor/{print $3}' | wc -l`"
run $bin $img1 $ext1 gauss 5 40 6.0
run $bin $img1 $ext1 gauss 13 40 6.0
run $bin $img1 $ext1 gauss 25 40 6.0
run $bin $img1 $ext1 gauss 5 20 6.0
run $bin $img1 $ext1 gauss 13 20 6.0
run $bin $img1 $ext1 gauss 25 20 6.0
run $bin $img1 $ext1 gauss 5 10 6.0
run $bin $img1 $ext1 gauss 13 10 6.0
run $bin $img1 $ext1 gauss 25 10 6.0
run $bin $img1 $ext1 gauss 5 1 6.0
run $bin $img1 $ext1 gauss 13 1 6.0
run $bin $img1 $ext1 gauss 25 1 6.0

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
echo "-- $bin -- $img1.$ext1 "
