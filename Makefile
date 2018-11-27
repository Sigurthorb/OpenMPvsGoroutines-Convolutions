CONV_FOLDER = ConvolutionLibrary
C_FOLDER = $(CONV_FOLDER)/c
GO_FOLDER = $(CONV_FOLDER)/go

BIN_FOLDER = bin
OBJ_FOLDER = $(BIN_FOLDER)/obj
INCLUDE_FOLDER = $(BIN_FOLDER)/include

OPTIMIZATION_FLAGS = -O3
INCLUDE_FLAG = -L$(INCLUDE_FOLDER) -lWrapper -lm -lpthread

setup:
	mkdir -p $(OBJ_FOLDER)
	mkdir $(INCLUDE_FOLDER)
	
cWrapper:
	gcc -c $(OPTIMIZATION_FLAGS) $(C_FOLDER)/libConv.c -fopenmp -o $(OBJ_FOLDER)/libConv.o
	gcc -c $(OPTIMIZATION_FLAGS) $(CONV_FOLDER)/libWrapper.c -lm -lpthread -o $(OBJ_FOLDER)/libWrapper.o 
	ar rcs $(INCLUDE_FOLDER)/libWrapper.a $(OBJ_FOLDER)/*.o
	rm -rf $(OBJ_FOLDER)/*.o
	
goWrapper:
	go build -o $(CONV_FOLDER)/libConv.a -buildmode=c-archive $(GO_FOLDER)/main.go
	cp $(CONV_FOLDER)/libConv.a $(OBJ_FOLDER)/libConv.a
	cd $(OBJ_FOLDER)/ && ar -x libConv.a && rm -rf libConv.a
	gcc -c $(OPTIMIZATION_FLAGS) $(CONV_FOLDER)/libWrapper.c -lrt -lpthread -o $(OBJ_FOLDER)/libWrapper.o
	ar rcs $(INCLUDE_FOLDER)/libWrapper.a $(OBJ_FOLDER)/*.o
	rm -rf $(OBJ_FOLDER)/*.o

cBin: cWrapper
	gcc -c -flto $(OPTIMIZATION_FLAGS) main.c -o $(OBJ_FOLDER)/main.o
	gcc -flto $(OPTIMIZATION_FLAGS) $(OBJ_FOLDER)/main.o $(INCLUDE_FLAG) -fopenmp -o bin/cBin
	rm -rf $(OBJ_FOLDER)/*.o

goBin: goWrapper
	gcc -c -flto $(OPTIMIZATION_FLAGS) main.c $(INCLUDE_FLAG) -o $(OBJ_FOLDER)/main.o
	gcc -flto $(OPTIMIZATION_FLAGS) $(OBJ_FOLDER)/main.o $(INCLUDE_FLAG) -o bin/goBin
	rm -rf $(OBJ_FOLDER)/*.o

tComp:
	gcc -c -flto $(OPTIMIZATION_FLAGS) otherCode/comparator_thor.c $(INCLUDE_FLAG) -o $(OBJ_FOLDER)/comparator.o
	gcc -flto $(OPTIMIZATION_FLAGS) $(OBJ_FOLDER)/comparator.o $(INCLUDE_FLAG) -fopenmp -o bin/tComp
	rm -rf $(OBJ_FOLDER)/*.o

clean:
	rm -rf bin/
	rm -rf $(CONV_FOLDER)/libWrapper.o
	rm -rf $(CONV_FOLDER)/libConv.*

all: clean setup goBin cBin tComp
