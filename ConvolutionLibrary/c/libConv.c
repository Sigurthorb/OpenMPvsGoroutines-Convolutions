
#include "libConv.h"

void Convolution(unsigned char* input, unsigned char* output, int height, int width, int channels, float* kernel, int kSize) {
    int i, j, l;

    // Placeholder to copy the input array to output array
    for(i = 0; i < height; i++)
        for(j = 0; j < width; j++)
            for(l = 0; l < channels; l++)
                output[i*width*channels+j*channels+l] = input[i*width*channels+j*channels+l];
}