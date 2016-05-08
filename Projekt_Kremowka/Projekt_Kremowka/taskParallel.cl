// Indeks Jaccarda
__kernel void kernel_0(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{

	for(unsigned int i = 0; i < count; i++)
	{
		output[i] = inputA[i] + inputB[i];
	}
}