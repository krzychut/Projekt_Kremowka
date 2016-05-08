__kernel void kernel_0(__global float* input, __global float* output, const unsigned int count)
{
	for(unsigned int i = 0; i < count; i++)
	{
		output[i] = input[i] * input[i];
	}
	/*if(i < count)
	{
		output[i] = input[i]*input[i];
	}*/
}