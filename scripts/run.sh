#!/bin/bash

function comp() {
    cd ..
    go build -o ConvolutionLibrary/libConv.a -buildmode=c-archive ConvolutionLibrary/go/main_$1.go
	cp ConvolutionLibrary/libConv.a bin/obj/libConv.a
	cd bin/obj/ && ar -x libConv.a && rm -rf libConv.a && cd -
	gcc -c -O3 ConvolutionLibrary/libWrapper.c -lrt -o bin/obj/libWrapper.o
	ar rcs bin/include/libWrapper.a bin/obj/*.o
	rm -rf bin/obj/*.o

    gcc -c -flto -O3 main.c -Lbin/include -lWrapper -lm -lpthread -lm -o bin/obj/main.o
	gcc -flto -O3 bin/obj/main.o -Lbin/include -lWrapper -lm -lpthread -o bin/$1
	rm -rf bin/obj/*.o
	rm -rf bin/include/*
	make cleanLib
    cd scripts
}

function runGoBin() {
    comp $1
    sbatch RunWaterfallGo.sh $1
    sbatch RunLionessGo.sh $1
    sbatch RunHouseGo.sh $1
}

runGoBin "StaticCyclicColBlocks"
runGoBin "RowBlock"

#./RunHouseC.sh
#./RunLionessC.sh
#./RunWaterfallC.sh

