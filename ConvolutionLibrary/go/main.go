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
	var i, j int
	routines := runtime.GOMAXPROCS(0)
	print(routines)

	var wg sync.WaitGroup
	kernelRowLen := kSize / 2
	kernelColLen := kSize / 2

	length := height * width * channels
	step := width * channels

	input := (*[1 << 31]C.uchar)(unsafe.Pointer(inputPtr))[:length:length]
	output := (*[1 << 31]C.uchar)(unsafe.Pointer(outputPtr))[:length:length]
	kernel := (*[1 << 31]C.float)(unsafe.Pointer(kernelPtr))[: kSize*kSize : kSize*kSize]

	worker := func(stopChan chan int, coordChan chan coord) {
		var coordinates coord
		var startKRow, startKCol, maxKRowLen, maxKColLen, ai, aj, ac, x, y int
		var val C.float

		for true {

			select {
			case coordinates = <-coordChan:
				x = coordinates.x
				y = coordinates.y

				startKRow = -kernelRowLen + x
				startKCol = -kernelColLen + y

				maxKRowLen = kernelRowLen + x
				maxKColLen = kernelColLen + y

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
					val = C.float(C.int(sum[ac]))
					if (sum[ac] - val) >= 0.5 {
						val++
					}

					output[x*step+y*channels+ac] = C.uchar(val)
				}

			case <-stopChan:
				wg.Done()
				return
			}
		}
	}

	stopChans := make([]chan int, routines)
	coordChan := make(chan coord, routines)

	//coordChans := make([]chan coord, routines)

	for i = 0; i < routines; i++ {
		wg.Add(1)
		stopChans[i] = make(chan int)
		//coordChans[i] = make(chan coord)

		go worker(stopChans[i], coordChan)
		//go worker(stopChans[i], coordChans[i])
	}

	counter := 0
	for i = 0; i < height; i++ {
		for j = 0; j < width; j++ {
			if counter >= routines {
				counter = 0
			}

			//coordChans[counter] <- coord{i, j}
			coordChan <- coord{i, j}

			counter++
		}
	}

	for i = 0; i < routines; i++ {
		stopChans[i] <- 1
	}

	wg.Wait()
}

func main() {}
