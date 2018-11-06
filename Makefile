CONV_FOLDER = ConvolutionLibrary
C_FOLDER = $(CONV_FOLDER)/c
GO_FOLDER = $(CONV_FOLDER)/go

BIN_FOLDER = bin
OBJ_FOLDER = $(BIN_FOLDER)/obj
INCLUDE_FOLDER = $(BIN_FOLDER)/include

OPTIMIZATION_FLAGS = -flto -O3
INCLUDE_FLAG = -L$(INCLUDE_FOLDER) -lWrapper -lm -lpthread

setup:
	mkdir -p $(OBJ_FOLDER)
	mkdir $(INCLUDE_FOLDER)

cLib:
	cp $(C_FOLDER)/libConv.* $(CONV_FOLDER)/
	g++ -c $(OPTIMIZATION_FLAGS) $(CONV_FOLDER)/libConv.c -o $(OBJ_FOLDER)/libConv.o

cWrapper: cLib
	g++ -c $(OPTIMIZATION_FLAGS) $(CONV_FOLDER)/libWrapper.c -lm -lpthread -o $(OBJ_FOLDER)/libWrapper.o 
	ar rcs $(INCLUDE_FOLDER)/libWrapper.a $(OBJ_FOLDER)/libWrapper.o $(OBJ_FOLDER)/libConv.o

cBin: cWrapper
	g++ -c $(OPTIMIZATION_FLAGS) main.c -lm -o $(OBJ_FOLDER)/main.o
	g++ $(OPTIMIZATION_FLAGS) $(OBJ_FOLDER)/main.o $(INCLUDE_FLAG) -fopenmp -o bin/cBin

goLib:
	go build -o $(CONV_FOLDER)/libConv.a -buildmode=c-archive ConvolutionLibrary/go/main.go
	cp $(CONV_FOLDER)/libConv.a $(OBJ_FOLDER)/libConv.a
	cd $(OBJ_FOLDER)/ && ar -x libConv.a && rm -rf libConv.a

goWrapper: goLib
	g++ -c $(OPTIMIZATION_FLAGS) $(CONV_FOLDER)/libWrapper.c -lrt -lpthread -o $(OBJ_FOLDER)/libWrapper.o
	ar rcs $(INCLUDE_FOLDER)/libWrapper.a $(OBJ_FOLDER)/*.o
	rm -rf $(OBJ_FOLDER)/*.o

goBin: goWrapper
	g++ -c $(OPTIMIZATION_FLAGS) main.c $(INCLUDE_FLAG) -lm -o $(OBJ_FOLDER)/main.o
	g++ $(OPTIMIZATION_FLAGS) $(OBJ_FOLDER)/main.o $(INCLUDE_FLAG) -o bin/goBin

comparator: cWrapper
	g++ -c otherCode/comparator.c $(INCLUDE_FLAG) -o $(OBJ_FOLDER)/comparator.o
	g++ $(OBJ_FOLDER)/comparator.o $(INCLUDE_FLAG) -o bin/comp


all: clean setup goBin cBin