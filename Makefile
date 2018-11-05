
setup:
	mkdir -p bin/obj
	mkdir bin/static

cLib:
	cp ConvolutionLibrary/c/libConv.* ConvolutionLibrary/
	g++ -c ConvolutionLibrary/libConv.c -o bin/obj/libConv.o

cWrapper: cLib
	g++ -c ConvolutionLibrary/libWrapper.c `pkg-config --libs --cflags opencv` -ldl -lm -lrt -lpthread -o bin/obj/libWrapper.o 
	ar rcs bin/static/libWrapper.a bin/obj/libWrapper.o bin/obj/libConv.o

cBin: cWrapper
	g++ -c main.c `pkg-config --libs --cflags opencv` -ldl -lm -lrt -o bin/obj/main.o
	g++ bin/obj/main.o -g -Lbin/static -lWrapper  `pkg-config --libs --cflags opencv` -ldl -lm -lrt -lpthread -o bin/cBin
	rm -rf bin/obj/*

goLib:
	go build -o ConvolutionLibrary/libConv.a -buildmode=c-archive ConvolutionLibrary/go/main.go
	cp ConvolutionLibrary/libConv.a bin/obj/libConv.a
	cd bin/obj/ && ar -x libConv.a && rm -rf libConv.a

goWrapper: goLib
	# ConvolutionLibrary/libConv.a
	g++ -c ConvolutionLibrary/libWrapper.c `pkg-config --libs --cflags opencv` -o bin/obj/libWrapper.o -ldl -lm -lrt -lpthread
	ar rcs bin/static/libWrapper.a bin/obj/*.o

goBin: goWrapper
	g++ -c main.c `pkg-config --libs --cflags opencv`  -ldl -lm -lrt -o bin/obj/main.o
	g++ bin/obj/main.o -g -Lbin/static -lWrapper  `pkg-config --libs --cflags opencv` -ldl -lm -lrt -lpthread -o bin/goBin
	rm -rf bin/obj/*

clean:
	rm -rf bin/
	rm -rf ConvolutionLibrary/libWrapper.o
	rm -rf ConvolutionLibrary/libConv.a ConvolutionLibrary/libConv.h ConvolutionLibrary/libConv.c ConvolutionLibrary/libConv.o

all: clean setup goBin cBin