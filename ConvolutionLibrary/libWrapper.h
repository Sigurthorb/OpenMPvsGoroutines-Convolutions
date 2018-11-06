#include <math.h>

#define M_PI         3.14159265358979323846

#ifndef WRAPPER_H_   
#define WRAPPER_H_

struct Image {
    unsigned char* data;
    int width;
    int height;
    int channels;
};

struct Kernel {
    float* data;
    int size;
};

int readImage(char* imagePath, struct Image* image);
int applyConvolution(struct Image* image, struct Kernel* kernel);

int getMeanKernel(int kSize, struct Kernel* kernel);
int getGaussianKernel(int kSize, float sigma, struct Kernel* kernel);

int saveImage(char* imagePath, struct Image* image);

#endif // WRAPPER_H_
