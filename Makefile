setup:
	mkdir -p bin/obj
	mkdir bin/static

cLib:
	cp ConvolutionLibrary/c/libConv.* ConvolutionLibrary/
	g++ -c ConvolutionLibrary/libConv.c -o bin/obj/libConv.o

cWrapper: cLib
	g++ -c ConvolutionLibrary/libWrapper.c -lm -lpthread -o bin/obj/libWrapper.o 
	ar rcs bin/static/libWrapper.a bin/obj/libWrapper.o bin/obj/libConv.o

cBin: cWrapper
	g++ -c main.c -lm -o bin/obj/main.o
	g++ bin/obj/main.o -Lbin/static -lWrapper  -lm -lpthread -fopenmp -o bin/cBin

goLib:
	go build -o ConvolutionLibrary/libConv.a -buildmode=c-archive ConvolutionLibrary/go/main.go
	cp ConvolutionLibrary/libConv.a bin/obj/libConv.a
	cd bin/obj/ && ar -x libConv.a && rm -rf libConv.a

goWrapper: goLib
	g++ -c ConvolutionLibrary/libWrapper.c -lrt -lpthread -o bin/obj/libWrapper.o
	ar rcs bin/static/libWrapper.a bin/obj/*.o
	rm -rf bin/obj/*.o

goBin: goWrapper
	g++ -c main.c -Lbin/static -lWrapper -lm -o bin/obj/main.o
	g++ bin/obj/main.o -Lbin/static -lWrapper -lm -lpthread -o bin/goBin

clean:
	rm -rf bin/
	rm -rf ConvolutionLibrary/libWrapper.o
	rm -rf ConvolutionLibrary/libConv.a ConvolutionLibrary/libConv.h ConvolutionLibrary/libConv.c ConvolutionLibrary/libConv.o

all: clean setup goBin cBin