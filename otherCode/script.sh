#!/bin/bash

#SBATCH -N 1
#SBATCH -n 1


export GOMAXPROCS=1
export OMP_NUM_THREADS=1

cd /lustre/cmsc714-1nzb/final/repo

function executeImage()
{
    image=$1
    imageEnd=$2

    echo "$image.$imageEnd - mean - 3 - C"
    ./bin/cBin input/$image.$imageEnd output/$image-mean-3-c.$imageEnd mean 3 1> /dev/null
    echo ""
    echo "$image.$imageEnd - mean - 3 - go"
    ./bin/goBin input/$image.$imageEnd output/$image-mean-3-go.$imageEnd mean 3 1> /dev/null
    echo ""
    echo ""

    echo "$image.$imageEnd - mean - 9 - C"
    ./bin/cBin input/$image.$imageEnd output/$image-mean-9-c.$imageEnd mean 9 1> /dev/null
    echo ""
    echo "$image.$imageEnd - mean - 9 - go"
    ./bin/goBin input/$image.$imageEnd output/$image-mean-9-go.$imageEnd mean 9 1> /dev/null
    echo ""
    echo ""

    echo "$image.$imageEnd - mean - 27 - C"
    ./bin/cBin input/$image.$imageEnd output/$image-mean-27-c.$imageEnd mean 27 1> /dev/null
    echo ""
    echo "$image.$imageEnd - mean - 27 - go"
    ./bin/goBin input/$image.$imageEnd output/$image-mean-27-go.$imageEnd mean 27 1> /dev/null
    echo ""
    echo ""
}

executeImage "lioness" "jpg"
executeImage "waterfall" "jpg"
executeImage "house" "jpg"
#executeImage "space" "png"








