#!/bin/sh

./compare opencv_mean_5_out.png goBin_mean_5_out.png
./compare opencv_mean_5_out.png cBin_mean_5_out.png
./compare cBin_mean_5_out.png goBin_mean_5_out.png

./compare python_mean_5_out.png opencv_mean_5_out.png
./compare python_mean_5_out.png cBin_mean_5_out.png
./compare python_mean_5_out.png goBin_mean_5_out.png

./compare opencv_gauss_5_3_out.png goBin_gauss_5_3_out.png
./compare opencv_gauss_5_3_out.png cBin_gauss_5_3_out.png
./compare cBin_gauss_5_3_out.png goBin_gauss_5_3_out.png

./compare python_gauss_5_3_out.png opencv_gauss_5_3_out.png
./compare python_gauss_5_3_out.png goBin_gauss_5_3_out.png
./compare python_gauss_5_3_out.png cBin_gauss_5_3_out.png


