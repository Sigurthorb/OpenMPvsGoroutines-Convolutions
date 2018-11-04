
#include <cv.h>
#include <highgui.h>
#ifndef WRAPPER_H_   /* Include guard */
#define WRAPPER_H_

struct Image {
    uchar* data;
    uint width;
    uint height;
    uint channels;
};

struct Kernel {
    float* data;
    uint size;
};

int readImage(char* imagePath, struct Image* image);
int applyConvolution(struct Image* image, struct Kernel* kernel);

int getMeanKernel(int kSize, struct Kernel* kernel);
int getGaussianKernel(int kSize, float sigma, struct Kernel* kernel);

int saveImage(char* imagePath, struct Image* image);


#endif // WRAPPER_H_