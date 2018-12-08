#include "libConv.h"
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <omp.h>

void Convolution(unsigned char* paddedInput, unsigned char* output, int height, int width, int channels, float* kernel, int kSize) {
    int row, col, ch, krow, kcol;
    unsigned char ucValue = 0;
    double dValueKernel = 0;
    double dAgg = 0;
    unsigned char ucAgg = 0;

    pid_t processID = getpid();

#ifdef _OPENMP
    int maxThreads = omp_get_max_threads();
    int processorCount = omp_get_num_procs();
    printf("%d: maxThreads %d, processorCount %d\n", processID, maxThreads, processorCount);
#endif

    int paddedInputHeight = height + (kSize/2) * 2;
    int paddedInputWidth = width + (kSize/2) * 2;
    int log = 0;

    // perform convolutions
#pragma omp parallel private(col, ch, krow, kcol, ucValue, dValueKernel, dAgg, ucAgg, log)
    for(row = kSize/2; row < paddedInputHeight - kSize/2; row++)
    {
#pragma omp parallel for private(col, ch, krow, kcol, ucValue, dValueKernel, dAgg, ucAgg, log)
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
}
