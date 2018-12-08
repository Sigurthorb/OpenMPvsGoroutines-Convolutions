#!/bin/bash

function buildBinary() {
     echo "Building $1"
     bin=$1
     cd ..
     cp ConvolutionLibrary/c/libConv.h ConvolutionLibrary/
	cp ConvolutionLibrary/c/libConv$bin.c ConvolutionLibrary/libConv.c
	gcc -c -O3 ConvolutionLibrary/libConv.c -fopenmp -o bin/obj/libConv.o
	gcc -c -O3 ConvolutionLibrary/libWrapper.c -lm -o bin/obj/libWrapper.o 
	ar rcs bin/include/libWrapper.a bin/obj/libWrapper.o bin/obj/libConv.o
	rm -rf bin/obj/*.o
	rm -rf ConvolutionLibrary/libConv.*

     gcc -c -flto -O3 main.c  -lm -o bin/obj/main.o
	gcc -flto -O3 bin/obj/main.o -Lbin/include -lWrapper -lm -lpthread -fopenmp -o bin/$bin

     rm -rf ConvolutionLibrary/libWrapper.o
	rm -rf ConvolutionLibrary/libConv.*
	rm -rf bin/include/*
	rm -rf bin/obj/*
	cd scripts/
     echo "Finished building $1"
     echo ""
}

function runImages() {
     buildBinary $1
     sbatch LadyCompScript.sh $1
     sbatch WaterfallCompScript.sh $1
     sbatch HouseCompScript.sh $1
}

#runImages "Block"
runImages "CycleDynamic"
runImages "CycleCollapseStatic"
runImages "CycleCollapseStaticKSize"
runImages "CycleDynCollapse_w-div-ksize"
runImages "CycleStaticCollapse_w-div-ksize"

