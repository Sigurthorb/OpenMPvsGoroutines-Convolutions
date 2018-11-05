#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

struct Image {
   unsigned char* data;
   int width;
   int height;
   int channels;
};

void writeImage(char* imageName, struct Image* image) {
   char *dot = strrchr(imageName, '.');

   if (dot) {
       int result = 0;
       if (strcmp(dot, ".png") == 0) {
           printf("BEFORE\n");
           stbi_write_png(imageName, image->width, image->height, image->channels, image->data, image->width*image->channels);
           printf("AFTER\n");
       } else if (strcmp(dot, ".jpg") == 0) {
           printf("name: '%s' - height: '%d' - width: '%d' - channels - '%d' \n", imageName, image->height, image->width, image->channels);
           stbi_write_jpg(imageName, image->width, image->height, image->channels, image->data, 90);
          
       } /*else if (!strcmp(dot, ".bmp")) {
           stbi_write_png(imageName, image->width, image->height, image->channels, image->data, sizeof(unsigned char)*image->width*image->height*image->channels)
          
       } else if (!strcmp(dot, ".tga")) {
           stbi_write_png(imageName, image->width, image->height, image->channels, image->data, sizeof(unsigned char)*image->width*image->height*image->channels)
          
       } else if (!strcmp(dot, ".hdr")) {
           stbi_write_png(imageName, image->width, image->height, image->channels, image->data, sizeof(unsigned char)*image->width*image->height*image->channels)
          
       }*/ else {
           printf("'%s' file ending is not supported\n", dot);
           exit(1);
       }
   } else {
       printf("output file must include file ending\n");
       exit(1);
   }

}

void readImage(char* imageName, struct Image* image) {
   //stbi_set_flip_vertically_on_load(1);
   image->data = stbi_load(imageName, &image->width, &image->height, &image->channels, STBI_rgb);
}

int main(int argc, char** argv) {
   int height, width, channels;
   int i, j, k;
  
   struct Image* image = (struct Image*)malloc(sizeof(struct Image));
  
   readImage("lioness.jpg", image);

   height = image -> height;
   width = image -> width;
   channels = image -> channels;

   unsigned char *output = (unsigned char*)malloc(sizeof(unsigned char)*height*width*channels+1);
   // unsigned char *output = (unsigned char*)malloc(sizeof(unsigned char) * (image->height) * (image -> width) * (image -> channels) + 1);

   for(i = 0; i < height; i++)
       for(j = 0; j < width; j++)
           for(k = 0; k < channels; k++)
               output[i*width*channels+j*channels+k] = 255 - image->data[i*width*channels+j*channels+k];
  
   free(image->data);
   image->data = output;

   // if (image -> data == NULL) {
   // 	printf("error\n");
   // }

   writeImage("lioness_out.jpg", image);

   printf("done\n");
   return 0;
}