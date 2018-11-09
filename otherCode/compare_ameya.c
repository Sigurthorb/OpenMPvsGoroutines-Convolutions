#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define STB_IMAGE_IMPLEMENTATION
#include "ConvolutionLibrary/stb_image.h"

struct Image {
    unsigned char* data;
    int width;
    int height;
    int channels;
};

int readImage(char* imagePath, struct Image* image);
int ConvCompare(struct Image * image1, struct Image * image2, int skipBorders);

int main(int argc, char ** argv)
{
    // check arguments
    if (argc != 3)
    {
        printf("Insufficient arguments - 2 arguments needed:\n1. First image path\n2. Second image path\n");
        return -1;
    }

    printf("\nComparing %s and %s\n", argv[1], argv[2]);

    struct Image * image1 = (struct Image *)malloc(sizeof(struct Image));
    struct Image * image2 = (struct Image *)malloc(sizeof(struct Image));

    int readImageSuccess = 0;
    readImageSuccess = readImage(argv[1], image1);
    if(!readImageSuccess) 
    {
        printf("Failed to read image\n");
        exit(1);
    }
    readImageSuccess = readImage(argv[2], image2);
    if(!readImageSuccess)
    {
        printf("Failed to read image\n");
        exit(1);
    }

    int skipBorders = 0;
    if (argv[1][0] == 'p' || argv[2][0] == 'p')
        skipBorders = 1;

    int res = ConvCompare(image1, image2, skipBorders);
    if (res == 0)    
        printf("Correct\n");
    else
        printf("Wrong\n");

    return 0;
}

int readImage(char* imagePath, struct Image* image)
{

    if(imagePath == NULL || image == NULL) {
        return -1;
    }

    image->data = stbi_load(imagePath, &image->width, &image->height, &image->channels, 0);

    if(image->data == NULL) {
        return 0;
    }

    return 1;

}

int ConvCompare(struct Image * image1, struct Image * image2, int skipBorders)
{
    int height = image1->height;
    int width = image1->width;
    int channels = image1->channels;
    unsigned char ucValue1 = 0;
    unsigned char ucValue2 = 0;
    float res1 = 0;
    float res2 = 0;
    float res3 = 0;

    for (int ch = 0; ch < channels; ch++)
    {
        if (skipBorders == 0)
        {
        for (int row = 0; row < height; row++)
        {
            for (int col = 0; col < width; col++)
            {
                ucValue1 = image1->data[(row * width * channels) + (col * channels) + ch];
                ucValue2 = image2->data[(row * width * channels) + (col * channels) + ch];
                if (abs(ucValue1 - ucValue2) == 1)
                {
                    //printf("Mismatch @ (%d, %d) - %d, %d, %d\n", col, row, ucValue1, ucValue2, ucValue1-ucValue2);
                    res1++;
                }
                else if (abs(ucValue1 - ucValue2) == 2)
                {
                    res2++;
                }
                else if (abs(ucValue1 - ucValue2) != 0)
                {
                    res3++;
                }
            }
        }
        }
        else
        {
            for (int row = 2; row < height - 2; row++)
            {
                for (int col = 2; col < width - 2; col++)
                {
                    ucValue1 = image1->data[(row * width * channels) + (col * channels) + ch];
                    ucValue2 = image2->data[(row * width * channels) + (col * channels) + ch];
                    if (abs(ucValue1 - ucValue2) == 1)
                    {
                        //printf("Mismatch @ (%d, %d) - %d, %d, %d\n", col, row, ucValue1, ucValue2, ucValue1-ucValue2);
                        res1++;
                    }
                    else if (abs(ucValue1 - ucValue2) == 2)
                    {
                        res2++;
                    }
                    else if (abs(ucValue1 - ucValue2) != 0)
                    {
                        res3++;
                    }
                }
            }
        }
    }
    printf("%% pixels having 1 unit difference: %f\n", 100 * res1/(height * width));
    printf("%% pixels having 2 unit difference: %f\n", 100 * res2/(height * width));
    printf("%% pixels having 3 or more unit difference: %f\n", 100 * res3/(height * width));
    return res1 + res2 + res3;
}

