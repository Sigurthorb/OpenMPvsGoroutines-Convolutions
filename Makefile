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
	
cWrapperBlock:
	cp $(C_FOLDER)/libConv.h $(CONV_FOLDER)/
	cp $(C_FOLDER)/libConvBlock.c $(CONV_FOLDER)/libConv.c
	gcc -c $(OPTIMIZATION_FLAGS) $(CONV_FOLDER)/libConv.c -fopenmp -o $(OBJ_FOLDER)/libConv.o
	gcc -c $(OPTIMIZATION_FLAGS) $(CONV_FOLDER)/libWrapper.c -lm -o $(OBJ_FOLDER)/libWrapper.o 
	ar rcs $(INCLUDE_FOLDER)/libWrapper.a $(OBJ_FOLDER)/libWrapper.o $(OBJ_FOLDER)/libConv.o
	rm -rf $(OBJ_FOLDER)/*.o
	rm -rf $(CONV_FOLDER)/libConv.*

cWrapperCycle:
	cp $(C_FOLDER)/libConv.h $(CONV_FOLDER)/
	cp $(C_FOLDER)/libConvCycle.c $(CONV_FOLDER)/libConv.c
	gcc -c $(OPTIMIZATION_FLAGS) $(CONV_FOLDER)/libConv.c -fopenmp -o $(OBJ_FOLDER)/libConv.o
	gcc -c $(OPTIMIZATION_FLAGS) $(CONV_FOLDER)/libWrapper.c -lm -o $(OBJ_FOLDER)/libWrapper.o 
	ar rcs $(INCLUDE_FOLDER)/libWrapper.a $(OBJ_FOLDER)/libWrapper.o $(OBJ_FOLDER)/libConv.o
	rm -rf $(OBJ_FOLDER)/*.o
	rm -rf $(CONV_FOLDER)/libConv.*

cWrapperCycleCollapse:
	cp $(C_FOLDER)/libConv.h $(CONV_FOLDER)/
	cp $(C_FOLDER)/libConvCycleCollapse.c $(CONV_FOLDER)/libConv.c
	gcc -c $(OPTIMIZATION_FLAGS) $(CONV_FOLDER)/libConv.c -fopenmp -o $(OBJ_FOLDER)/libConv.o
	gcc -c $(OPTIMIZATION_FLAGS) $(CONV_FOLDER)/libWrapper.c -lm -o $(OBJ_FOLDER)/libWrapper.o 
	ar rcs $(INCLUDE_FOLDER)/libWrapper.a $(OBJ_FOLDER)/libWrapper.o $(OBJ_FOLDER)/libConv.o
	rm -rf $(OBJ_FOLDER)/*.o
	rm -rf $(CONV_FOLDER)/libConv.*


cBlockBin: cWrapperBlock
	gcc -c -flto $(OPTIMIZATION_FLAGS) main.c  -lm -o $(OBJ_FOLDER)/main.o
	gcc -flto $(OPTIMIZATION_FLAGS) $(OBJ_FOLDER)/main.o $(INCLUDE_FLAG) -fopenmp -o bin/Block
	make cleanLib

cCycleBin: cWrapperCycle
	gcc -c -flto $(OPTIMIZATION_FLAGS) main.c  -lm -o $(OBJ_FOLDER)/main.o
	gcc -flto $(OPTIMIZATION_FLAGS) $(OBJ_FOLDER)/main.o $(INCLUDE_FLAG) -fopenmp -o bin/Cycle
	make cleanLib

cCycleCollapse: cWrapperCycleCollapse
	gcc -c -flto $(OPTIMIZATION_FLAGS) main.c  -lm -o $(OBJ_FOLDER)/main.o
	gcc -flto $(OPTIMIZATION_FLAGS) $(OBJ_FOLDER)/main.o $(INCLUDE_FLAG) -fopenmp -o bin/CycleCollapse
	make cleanLib


tComp:
	make cWrapperCycle
	gcc -c -flto $(OPTIMIZATION_FLAGS) otherCode/comparator_thor.c $(INCLUDE_FLAG) -o $(OBJ_FOLDER)/comparator.o
	gcc -flto $(OPTIMIZATION_FLAGS) $(OBJ_FOLDER)/comparator.o  -fopenmp $(INCLUDE_FLAG) -o bin/tComp
	rm -rf $(OBJ_FOLDER)/*.o




goBin: goWrapper
	gcc -c -flto $(OPTIMIZATION_FLAGS) main.c $(INCLUDE_FLAG) -lm -o $(OBJ_FOLDER)/main.o
	gcc -flto $(OPTIMIZATION_FLAGS) $(OBJ_FOLDER)/main.o $(INCLUDE_FLAG) -o bin/goBin
	rm -rf $(OBJ_FOLDER)/*.o
	rm -rf $(INCLUDE_FOLDER)/*
	make cleanLib

goWrapper:
	go build -o $(CONV_FOLDER)/libConv.a -buildmode=c-archive ConvolutionLibrary/go/main.go
	cp $(CONV_FOLDER)/libConv.a $(OBJ_FOLDER)/libConv.a
	cd $(OBJ_FOLDER)/ && ar -x libConv.a && rm -rf libConv.a
	gcc -c $(OPTIMIZATION_FLAGS) $(CONV_FOLDER)/libWrapper.c -lrt -o $(OBJ_FOLDER)/libWrapper.o
	ar rcs $(INCLUDE_FOLDER)/libWrapper.a $(OBJ_FOLDER)/*.o
	rm -rf $(OBJ_FOLDER)/*.o

clean:
	rm -rf bin/

cleanLib:
	rm -rf $(CONV_FOLDER)/libWrapper.o
	rm -rf $(CONV_FOLDER)/libConv.*
	rm -rf bin/include/*
	rm -rf bin/obj/*

all: clean setup goBin cBlockBin cCycleBin cCycleCollapse tComp