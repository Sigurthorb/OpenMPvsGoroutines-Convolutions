package main

import "C"
import (
	"runtime"
	"sync"
	"unsafe"
)

type coord struct {
	x int
	y int
}

//export Convolution
func Convolution(inputPtr *C.uchar, outputPtr *C.uchar, height, width, channels int, kernelPtr *C.float, kSize int) {
	// OMP_NUM_THREADS
	// GOMAXPROCS
	var i int
	routines := runtime.GOMAXPROCS(0)
	//print(routines)

	var wg sync.WaitGroup
	kernelRowLen := kSize / 2
	kernelColLen := kSize / 2

	length := height * width * channels
	step := width * channels

	input := (*[1 << 31]C.uchar)(unsafe.Pointer(inputPtr))[:length:length]
	output := (*[1 << 31]C.uchar)(unsafe.Pointer(outputPtr))[:length:length]
	kernel := (*[1 << 31]C.float)(unsafe.Pointer(kernelPtr))[: kSize*kSize : kSize*kSize]

	worker := func(id int) {
		runtime.LockOSThread()
		var startKRow, startKCol, maxKRowLen, maxKColLen, ai, aj, ac, r, c int
		var val C.float
		var sum []C.float

		for r = id; r < height; r += routines {
			for c = 0; c < width; c++ {

				startKRow = -kernelRowLen + r
				startKCol = -kernelColLen + c

				maxKRowLen = kernelRowLen + r
				maxKColLen = kernelColLen + c

				sum = []C.float{0.0, 0.0, 0.0}

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
					val = C.float(C.int(sum[ac]))
					if (sum[ac] - val) >= 0.5 {
						val++
					}

					output[r*step+c*channels+ac] = C.uchar(val)
				}
			}
		}
		runtime.UnlockOSThread()
		wg.Done()
	}

	for i = 0; i < routines-1; i++ {
		wg.Add(1)
		go worker(i)
	}

	wg.Add(1)
	worker(routines - 1)

	wg.Wait()
}

func main() {}
