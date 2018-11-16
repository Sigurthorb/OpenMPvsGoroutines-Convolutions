#include <stdlib.h>
#include <string.h>

#ifndef CONV_H_   /* Include guard */
#define CONV_H_

void Convolution(unsigned char* input, unsigned char* output, int height, int width, int channels, float* kernel, int kSize);

#endif // CONV_H_
