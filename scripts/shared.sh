
#!/bin/bash

cd /lustre/cmsc714-1nzb/final/repoMaster
#cd ..


ENV_VAR=$4

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
echo "-- $1 -- $2.$3 "
run $1 $2 $3 gauss 5 1 6.0
run $1 $2 $3 gauss 5 10 6.0
run $1 $2 $3 gauss 5 20 6.0

run $1 $2 $3 gauss 13 1 6.0
run $1 $2 $3 gauss 13 10 6.0
run $1 $2 $3 gauss 13 20 6.0

run $1 $2 $3 gauss 25 1 6.0
run $1 $2 $3 gauss 25 10 6.0
run $1 $2 $3 gauss 25 20 6.0

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
echo "-- $1 -- $2.$3 "
