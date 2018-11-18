
#include "libConv.h"
#include <omp.h>
#include <stdio.h>

int numthreads;



void Convolution(unsigned char* input, unsigned char* output, int height, int width, int channels, float* kernel, int kSize) {
    int row, col, ch, krow, kcol;
    unsigned char ucValue = 0;
    double dValueKernel = 0;
    double * dAgg = (double *)malloc(sizeof(double) * channels);
    unsigned char ucAgg = 0;

    #ifdef _OPENMP
       numthreads=omp_get_max_threads();
    #else
       numthreads=1;
    #endif

    printf("%d\n", numthreads);

    #pragma omp parallel for num_threads(omp_get_max_threads()), private(row, col, ch, krow, kcol, ucValue, dValueKernel, dAgg, ucAgg)
    for(row = 0; row < height; row++)
    {
        for(col = 0; col < width; col++)
        {
            for (krow = 0; krow < kSize; krow++)
            {
                for (kcol = 0; kcol < kSize; kcol++)
                {
                    // zero padding for source image
                    if ((row - kSize / 2 + krow) >= 0 && (row - kSize / 2 + krow) < height &&
                        (col - kSize / 2 + kcol) >= 0 && (col - kSize / 2 + kcol) < width)
                    {
                        for(ch = 0; ch < channels; ch++)
                        {
                            ucValue = input[((row - kSize / 2 + krow) * width * channels) + ((col - kSize / 2 + kcol) * channels) + ch];
                            dValueKernel = kernel[krow * kSize + kcol];
                            dAgg[ch] += ucValue * dValueKernel;
                        }
                    }
                }
            }

            for (ch = 0; ch < channels; ch++)
            {
                ucAgg = dAgg[ch];
                if (dAgg[ch] - ucAgg >= 0.5)
                {
                    ucAgg += 1;
                }
                output[(row * width * channels) + (col * channels) + ch] = ucAgg;
                dAgg[ch] = 0;
            }
        }
    }
}
