
#ifndef CONV_H_   /* Include guard */
#define CONV_H_

void Convolution(unsigned char* input, unsigned char* output, unsigned int height, unsigned int width, unsigned int channels, float* kernel, unsigned int kSize);

#endif // CONV_H_