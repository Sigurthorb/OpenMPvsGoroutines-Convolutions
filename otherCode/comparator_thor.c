#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../ConvolutionLibrary/libWrapper.h"

int main(int argc, char **argv) {

    if (argc < 3) {
        printf("This tool must be used with exactly 2 arguments\n");
        printf("<Binary> <InputImage1> <InputImage2>\n");
        exit(1);
    }

    struct Image* image1 = (struct Image*)malloc(sizeof(struct Image));
    struct Image* image2 = (struct Image*)malloc(sizeof(struct Image));

    readImage(argv[1], image1);
    readImage(argv[2], image2);

    int total = 0;
    int correct = 0;
    int i = 0;

    for(; i < image1->width*image1->height*image1->channels; i++) {
        if(image1->data[i] == image2->data[i]) {
            correct++;
        }
        total++;
    }

    printf("%.4f%% correct\n", (((float)correct)/total)*100);

    return 0;
}