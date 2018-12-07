#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include "ConvolutionLibrary/libWrapper.h"


int main(int argc, char **argv) {

  if (argc < 5) {
    printf("This tool must be used with atleast 4 arguments\n");
    printf("<Binary> <InputImage> <OutputImage> <{gauss, mean}> <KernelSize> <Sigma>\n");
    exit(1);
  }

  char* input = argv[1];
  char* output = argv[2];
  char* kernelName = argv[3];
  int kernelSize = atoi(argv[4]);

  struct Image* image = (struct Image*)malloc(sizeof(struct Image));
  struct Kernel* kernel = (struct Kernel*)malloc(sizeof(struct Kernel));

  printf("Reading image '%s'\n", argv[1]);
  int readImageSuccess = readImage(input, image);
  if(!readImageSuccess) {
    printf("Failed to read image\n");
    exit(1);
  }

  printf("Generating Kernel '%s' of size '%d'\n", kernelName, kernelSize);
  int kernelSuccess = 0;
  if (strcmp("gauss", kernelName) == 0) {
    if (argc < 6) {
      printf("This tool must be used with 5 arguments with gaussian kernel\n");
      printf("<Binary> <InputImage> <OutputImage> gauss <KernelSize> <Sigma>\n");
      exit(1);
    }
    float sigma = atof(argv[5]);
    kernelSuccess = getGaussianKernel(kernelSize, sigma, kernel);
  } else if (strcmp("mean", kernelName) == 0) {
    kernelSuccess = getMeanKernel(kernelSize, kernel);

  } else if (strcmp("edge", kernelName) == 0) {
    if (argc < 6) {
      printf("This tool must be used with 5 arguments with edge kernel\n");
      printf("<Binary> <InputImage> <OutputImage> edge <KernelSize> <Sigma>\n");
      exit(1);
    }
    float sigma = atof(argv[5]);
    kernelSuccess = getEdgeKernel(kernelSize, sigma, kernel);

  } else {
    printf("'%s' is not a supported kernel, must be 'gauss' or 'mean'", kernelName);
    exit(1);
  }

  if(kernelSuccess == 0) {
    printf("Failed to create kernel\n");
    exit(1);
  }

  printf("Applying kernel by convolution\n");

  // Time convolution
  struct timeval start, stop;
  gettimeofday(&start, NULL);
  int convolutionSuccess = applyConvolution(image, kernel);
  gettimeofday(&stop, NULL);
  // Print time difference
  long int microseconds = (stop.tv_sec - start.tv_sec) * 1000000L + (stop.tv_usec - start.tv_usec);
  fprintf(stderr, "%ld.%ld seconds\n", microseconds/1000000L, microseconds - (microseconds/1000000L));

  if(convolutionSuccess == 0) {
    printf("Failed to apply convolution\n");
    exit(1);
  }

  printf("Saving image\n");
  int saveImageSuccess = writeImage(output, image);
  if(saveImageSuccess == 0) {
    printf("Failed to save image\n");
    exit(1);
  }

  return 0;
}
