#include "libConv.h"

void Convolution(unsigned char* input, unsigned char* output, int height, int width, int channels, float* kernel, int kSize) {
    int row, col, ch, krow, kcol;
    unsigned char ucValue = 0;
    double dValueKernel = 0;
    double dAgg = 0;
    unsigned char ucAgg = 0;

    // copy the input image to a zero padded memory block
    int paddedInputHeight = height + (kSize/2) * 2;
    int paddedInputWidth = width + (kSize/2) * 2;
    unsigned char * paddedInput = (unsigned char *)calloc(paddedInputHeight * paddedInputWidth * channels, sizeof(unsigned char));
    unsigned char * ptrInput = input;
    unsigned char * ptrPaddedInput = paddedInput + (kSize/2) * paddedInputWidth * channels + (kSize/2) * channels;
    for (int row = 0; row < height; row++)
    {
        memcpy((void *)ptrPaddedInput, (void *)ptrInput, width * channels);
        ptrPaddedInput += paddedInputWidth * channels;
        ptrInput += width * channels;
    }

    // perform convolutions
    for(row = kSize/2; row < paddedInputHeight - kSize/2; row++)
    {
        for(col = kSize/2; col < paddedInputWidth - kSize/2; col++)
        {
            for (ch = 0; ch < channels; ch++)
            {
                for (krow = 0; krow < kSize; krow++)
                {
                    for(kcol = 0; kcol < kSize; kcol++)
                    {
                        ucValue = paddedInput[((row - kSize / 2 + krow) * paddedInputWidth * channels) + ((col - kSize / 2 + kcol) * channels) + ch];
                        dValueKernel = kernel[krow * kSize + kcol];
                        dAgg += ucValue * dValueKernel;
                    }
                }

                ucAgg = dAgg;
                if (dAgg - ucAgg >= 0.5)
                {
                    ucAgg += 1;
                }
                output[((row - kSize/2) * width * channels) + ((col - kSize/2) * channels) + ch] = ucAgg;
                dAgg = 0;
            }
        }
    }

    // free zero padded memorby block
    ptrInput = NULL;
    ptrPaddedInput = NULL;
    free(paddedInput);
}
