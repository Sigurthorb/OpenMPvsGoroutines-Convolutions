package main

import (
	"C"
	"unsafe"
)
import "sync"

//export Convolution
func Convolution(inputPtr *C.uchar, outputPtr *C.uchar, height, width, channels uint, kernelPtr *C.float, kSize uint) {
	//OMP_NUM_THREADS
	var wg sync.WaitGroup

	kernelRowLen := kSize / 2
	kernelColLen := kSize / 2
	length := height * width * channels

	input := (*[1 << 49]C.uchar)(unsafe.Pointer(inputPtr))[:length:length]
	output := (*[1 << 49]C.uchar)(unsafe.Pointer(outputPtr))[:length:length]
	kernel := (*[1 << 30]C.float)(unsafe.Pointer(kernelPtr))[: kSize*kSize : kSize*kSize]

	step := width * channels
	var i, j uint
	for i = 0; i < height; i++ {
		for j = 0; j < width; j++ {
			wg.Add(1)
			go func(theI, theJ uint) {

				var startKRow, startKCol, maxKRowLen, maxKColLen, ai, aj, ac uint

				startKRow = -kernelRowLen + theI
				startKCol = -kernelColLen + theJ

				maxKRowLen = kernelRowLen + theI
				maxKColLen = kernelColLen + theJ

				var sum = []C.float{0.0, 0.0, 0.0}

				for ai = startKRow; ai <= maxKRowLen; ai++ {
					for aj = startKCol; aj <= maxKColLen; aj++ {
						for ac = 0; ac < channels; ac++ {
							if ai < 0 || aj < 0 || ai >= height || aj >= width {
								continue
							}
							sum[ac] += C.float(input[ai*step+aj*channels+ac]) * kernel[(ai-startKRow)*kSize+(aj-startKCol)]
						}
					}
				}

				for ac = 0; ac < channels; ac++ {
					output[theI*step+theJ*channels+ac] = C.uchar(int(sum[ac]))
				}
				wg.Done()
			}(i, j)
		}
	}

	wg.Wait()
}

func main() {}
