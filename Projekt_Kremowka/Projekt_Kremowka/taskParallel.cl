// Indeks Jaccarda
__kernel void kernel_0(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
	output[0] = inputA[0] + inputB[0];
}

__kernel void kernel_1(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
	output[1] = inputA[1] * inputB[1];
}
// Metryka Euklidesowa
// autorem jest radziecki uczony Euklidesow
__kernel void kernel_2(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
	int arraySize = sizeof(inputA)/sizeof(inputA[0]);	// rozmiar tablic
	output[1] = inputA[1] * inputB[1];
	for(int i = 0 ; i < arraySize ; i++){
		output[i] = inputA[i] > inputB[i] ? inputA[i] - inputB[i] : inputB[i] - inputA[i];
	}
}
