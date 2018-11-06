#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "libWrapper.h"
#include "libConv.h"

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"


int readImage(char* imagePath, struct Image* image) {

    if(imagePath == NULL || image == NULL) {
        return -1;
    }

    image->data = stbi_load(imagePath, &image->width, &image->height, &image->channels, 0);

    if(image->data == NULL) {
        return 0;
    }

    return 1;

}

int saveImage(char* imagePath, struct Image* image) {
   char *dot = strrchr(imagePath, '.');

   if (dot) {
       int result = 0;
       if (strcmp(dot, ".png") == 0) {
           stbi_write_png(imagePath, image->width, image->height, image->channels, image->data, image->width*image->channels);
       } else if (strcmp(dot, ".jpg") == 0) {
           stbi_write_jpg(imagePath, image->width, image->height, image->channels, image->data, 90);
       } /*else if (!strcmp(dot, ".bmp")) {
           stbi_write_png(imageName, image->width, image->height, image->channels, image->data, sizeof(unsigned char)*image->width*image->height*image->channels)
       } else if (!strcmp(dot, ".tga")) {
           stbi_write_png(imageName, image->width, image->height, image->channels, image->data, sizeof(unsigned char)*image->width*image->height*image->channels)
       } else if (!strcmp(dot, ".hdr")) {
           stbi_write_png(imageName, image->width, image->height, image->channels, image->data, sizeof(unsigned char)*image->width*image->height*image->channels)
       }*/ else {
           return 0;
       }
   } else {
       return -1;
   }

   return 1;
}

int applyConvolution(struct Image* image, struct Kernel* kernel) {
    if (image == NULL || kernel == NULL) {
        return 0;
    }

    int length = image->width*image->height*image->channels+1;
    unsigned char* newData = (unsigned char*)malloc(sizeof(unsigned char)*image->width*image->height*image->channels);

    Convolution(image->data, newData, image->height, image->width, image->channels, kernel->data, kernel->size);

    free(image->data);

    image->data = newData;

    return 1;
}

int getMeanKernel(int kSize, struct Kernel* kernel) {
    if(kernel == NULL || kSize <= 0 || kSize % 2 != 1) {
        return 0;
    }

    int i, length = kSize*kSize;
    float value = 1.0/length;

    kernel->size = kSize;
    kernel->data = (float*)malloc(sizeof(float)*length);

    for(i = 0; i < length; i++) {
        kernel->data[i] = value;
    }

    return 1;
}

int getGaussianKernel(int kSize, float sigma, struct Kernel* kernel) {
    if(kernel == NULL || kSize <= 0 || kSize % 2 != 1 || sigma == 0) {
        return 0;
    }

    int length = kSize*kSize;

    kernel->size = kSize;
    kernel->data = (float*)malloc(sizeof(float)*length);
    
    double dAlpha = 0;
    for (int row = 0; row < kSize; row++)
    {
        for (int col = 0; col < kSize; col++)
        {
            kernel->data[row * kSize + col] = exp((-pow(row - kSize/2, 2)-pow(col - kSize/2, 2))/(2 * M_PI * pow(sigma, 2)));
            dAlpha += kernel->data[row * kSize + col];
        }
    }

    // Normalize the values of the kernel so that they range from 0 to 1
    for (int row = 0; row < kSize; row++)
    {
        for (int col = 0; col < kSize; col++)
        {
            kernel->data[row * kSize + col] = kernel->data[row * kSize + col]/dAlpha;
        }
    }

    return 1;
}

void freeKernel(struct Kernel* kernel) {
    free(kernel->data);
    free(kernel);
}

void freeImage(struct Image* image) {
    free(image->data);
    free(image);
}

