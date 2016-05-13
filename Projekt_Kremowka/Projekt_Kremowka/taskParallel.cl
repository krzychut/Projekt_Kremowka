// Indeks Jaccarda
__kernel void kernel_0(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
	output[0] = inputA[0] + inputB[0];
}

__kernel void kernel_1(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{

	output[1] = inputA[1] * inputB[1];

}