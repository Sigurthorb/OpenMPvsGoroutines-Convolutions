
setup:
	mkdir -p bin/static

cLib:
	cp ConvolutionLibrary/c/libConv.* ConvolutionLibrary/
	g++ -c ConvolutionLibrary/libConv.c -o bin/static/libConv.o

cWrapper: cLib
	g++ -c ConvolutionLibrary/libWrapper.c `pkg-config --libs --cflags opencv` -o bin/static/libWrapper.o -ldl -lm -lrt -lpthread
	ar rcs bin/static/libWrapper.a bin/static/libWrapper.o bin/static/libConv.o

cBin: cWrapper
	g++ -c main.c `pkg-config --libs --cflags opencv` -o bin/main.o -ldl -lm -lrt
	g++ bin/main.o -g -Lbin/static -lWrapper -o bin/cBin `pkg-config --libs --cflags opencv` -ldl -lm -lrt -lpthread

goLib:
	go build -o ConvolutionLibrary/libConv.a -buildmode=c-archive ConvolutionLibrary/go/main.go
	cp ConvolutionLibrary/libConv.a bin/static/libConv.a
	cp ConvolutionLibrary/libConv.h bin/static/libConv.h

goWrapper: goLib
	g++ -c ConvolutionLibrary/libWrapper.c bin/static/libConv.a `pkg-config --libs --cflags opencv` -o bin/static/libWrapper.o -ldl -lm -lrt -lpthread
	ar rcs bin/static/libWrapper.a bin/static/libConv.a bin/static/libWrapper.o 

goBin: goWrapper
	g++ -c main.c `pkg-config --libs --cflags opencv` -o bin/main.o -ldl -lm -lrt
	g++ bin/main.o -g -Lbin/static -lWrapper -lConv -o bin/goBin `pkg-config --libs --cflags opencv` -ldl -lm -lrt -lpthread

clean:
	rm -rf bin/
	rm -rf ConvolutionLibrary/libWrapper.o
	rm -rf ConvolutionLibrary/libConv.a ConvolutionLibrary/libConv.h ConvolutionLibrary/libConv.c ConvolutionLibrary/libConv.o

all: clean setup goBin cBin