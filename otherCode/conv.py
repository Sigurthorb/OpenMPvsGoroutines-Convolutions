from PIL import Image
from PIL import ImageFilter
import math

im = Image.open("input/000001.jpg")

kernel_mean = ImageFilter.Kernel((5,5), (1,1,1,1,1,
                                    1,1,1,1,1,
                                    1,1,1,1,1,
                                    1,1,1,1,1,
                                    1,1,1,1,1), 25, 0)


im_mean = im.filter(kernel_mean)
im_mean.save("python_mean_5_out.png")

k = [[0 for x in range(5)] for y in range(5)]
dAlpha = 0
for row in range(0,5):
    for col in range(0,5):
        k[row][col] = math.exp((-math.pow(row - 2, 2)-math.pow(col - 2, 2))/(2 * math.pi * math.pow(3, 2)))
        dAlpha = dAlpha + k[row][col]

kernel_gauss = ImageFilter.Kernel((5,5), (k[0][0], k[0][1], k[0][2], k[0][3], k[0][4],
                                          k[1][0], k[1][1], k[1][2], k[1][3], k[1][4],
                                          k[2][0], k[2][1], k[2][2], k[2][3], k[2][4],
                                          k[3][0], k[3][1], k[3][2], k[3][3], k[3][4],
                                          k[4][0], k[4][1], k[4][2], k[4][3], k[4][4]), dAlpha, 0)


im_gauss = im.filter(kernel_gauss)
im_gauss.save("python_gauss_5_3_out.png")
