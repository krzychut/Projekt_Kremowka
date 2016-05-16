// Indeks Jaccarda
__kernel void kernel_0(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
/*
	// Calculate the cardinality of inputA && inputB
	unsigned int intersection = 0;

	// Calculate the cardinality of inputA || inputB
	unsigned int union = 0;
*/
	output[0] = inputA[0] + inputB[0];
}

// Metryka Miejska (Odl. Minkowskiego L_1)
__kernel void kernel_1(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
	float L = 0;
	for(int i = 0; i < count ; i++)
	{
		float x = fabs(inputA[i] - inputB[i]);
		L += x;
	}

	output[1] = L;
}

//Metryka Euklidesowa (Odl. Minkowskiego L_2)
__kernel void kernel_2(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
	float L = 0;
	for(int i = 0; i < count ; i++)
	{
		float x = fabs(inputA[i] - inputB[i]);
		L += powr(x, 2);
	}
	L = powr(L, 0.5f);

	output[2] = L;
}