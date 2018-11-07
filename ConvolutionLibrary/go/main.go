package main

// #cgo LDFLAGS: -lm
// #include <math.h>
import "C"
import "unsafe"

//export Convolution
func Convolution(inputPtr *C.uchar, outputPtr *C.uchar, height, width, channels int, kernelPtr *C.float, kSize int) {
	//OMP_NUM_THREADS
	//var wg sync.WaitGroup
	kernelRowLen := kSize / 2
	kernelColLen := kSize / 2
	length := height * width * channels

	input := (*[1 << 31]C.uchar)(unsafe.Pointer(inputPtr))[:length:length]
	output := (*[1 << 31]C.uchar)(unsafe.Pointer(outputPtr))[:length:length]
	kernel := (*[1 << 31]C.float)(unsafe.Pointer(kernelPtr))[: kSize*kSize : kSize*kSize]

	step := width * channels
	var i, j int
	for i = 0; i < height; i++ {
		for j = 0; j < width; j++ {
			//wg.Add(1)
			//func(theI, theJ int) {
			theI := i
			theJ := j

			var startKRow, startKCol, maxKRowLen, maxKColLen, ai, aj, ac int

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

				output[theI*step+theJ*channels+ac] = C.uchar(int(C.roundf(sum[ac])))
			}
			//wg.Done()
			//}(i, j)
		}
	}

	//wg.Wait()
}

func main() {}
