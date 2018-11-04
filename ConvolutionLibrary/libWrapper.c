
#include "libWrapper.h"
#include "libConv.h"

IplImage* img;

int readImage(char* imagePath, struct Image* image) {

    if(imagePath == NULL || image == NULL) {
        return -1;
    }

    img = 0; 
    img = cvLoadImage(imagePath);

    if(!img){
        return 0;
    }

    image->data = (uchar *)img->imageData;
    image->height = img->height;
    image->width = img->width;
    image->channels = img->nChannels;

    return 1;

}

int saveImage(char* imagePath, struct Image* image) {
  if (imagePath == NULL || image == NULL) {
      return 0;
  }

  img->imageData = (char*)image->data;

  return cvSaveImage(imagePath, img);
}

int applyConvolution(struct Image* image, struct Kernel* kernel) {
    if (image == NULL || kernel == NULL) {
        return 0;
    }
    uint length = image->width*image->height*image->channels+1;
    uchar* newData = (uchar*)malloc(sizeof(uchar)*image->width*image->height*image->channels+1);

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

    int i, length = kSize*kSize;

    kernel->size = kSize;
    kernel->data = (float*)malloc(sizeof(float)*length);
    
    return 0;
}
