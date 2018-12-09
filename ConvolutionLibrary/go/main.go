package main

import "C"
import (
	"runtime"
	"sync"
	"unsafe"
)

//export Convolution
func Convolution(inputPtr *C.uchar, outputPtr *C.uchar, height, width, channels int, kernelPtr *C.float, kSize int) {
	var wg sync.WaitGroup

	routines := runtime.GOMAXPROCS(0)
	k := kSize / 2
	padding := kSize - 1

	inputStep := (width + padding) * channels
	outputStep := width * channels

	input := (*[1 << 31]C.uchar)(unsafe.Pointer(inputPtr))[: (height+padding)*inputStep : (height+padding)*inputStep]
	output := (*[1 << 31]C.uchar)(unsafe.Pointer(outputPtr))[: height*outputStep : height*outputStep]
	kernel := (*[1 << 31]C.float)(unsafe.Pointer(kernelPtr))[: kSize*kSize : kSize*kSize]

	numCol := float64(width) / float64(routines)

	worker := func(id float64) {
		runtime.LockOSThread()
		var startKRow, startKCol, endKRow, endKCol, ai, aj, ac, rInput, cInput, rOutput, cOutput, channelStartLoc int
		var val C.float
		var sum = []C.float{0.0, 0.0, 0.0, 0.0}

		rInput = k
		rOutput = 0

		for rInput < height+k {
			cInput = int(numCol*id) + k
			cOutput = int(numCol * id)
			for cInput < int(numCol*id+numCol)+k {

				startKRow = rInput - k
				startKCol = cInput - k

				endKRow = rInput + k
				endKCol = cInput + k

				for ai = startKRow; ai <= endKRow; ai++ {
					for aj = startKCol; aj <= endKCol; aj++ {
						channelStartLoc = ai*inputStep + aj*channels
						for ac = 0; ac < channels; ac++ {
							sum[ac] += C.float(input[channelStartLoc+ac]) * kernel[(ai-startKRow)*kSize+(aj-startKCol)]
						}
					}
				}

				channelStartLoc = rOutput*outputStep + cOutput*channels

				for ac = 0; ac < channels; ac++ {
					val = C.float(C.int(sum[ac]))
					if (sum[ac] - val) >= 0.5 {
						val++
					}

					output[channelStartLoc+ac] = C.uchar(val)
					sum[ac] = 0.0
				}

				cInput++
				cOutput++

			}

			rInput++
			rOutput++
		}
		runtime.UnlockOSThread()
		wg.Done()
	}
	for i := 0; i < routines-1; i++ {
		wg.Add(1)
		go worker(float64(i))
	}

	wg.Add(1)
	worker(float64(routines - 1))
	wg.Wait()
}

func main() {}
