// Indeks Jaccarda
__kernel void kernel_0(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
/*
	// Calculate the cardinality of inputA && inputB
	unsigned int intersection = 0;

	// Calculate the cardinality of inputA || inputB
	unsigned int union = 0;
*/
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

// Metryka Euklidesowa (Odl. Minkowskiego L_2)
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

// Odleglosc Czebyszewa (Odl Minkowskiego L_inf)
__kernel void kernel_3(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
	float D = 0;
	for(unsigned int i = 0; i < count; i++)
	{
		float temp = fabs(inputA[i] - inputB[i]);
		if(temp > D)
		{
			D = temp;
		}
	}
	output[3] = D;
}

// R-Pearson
__kernel void kernel_4(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
	float mA = 0;
	float mB = 0;
	for(unsigned int i = 0; i < count; i ++)
	{
		mA += inputA[i];
		mB += inputB[i];
	}
	mA /= count;
	mB /= count;

	float numerator = 0;
	float denominator = 0;
	float denom1 = 0;
	float denom2 = 0;
	float temp = 0;
	for(unsigned int i=0; i < count; i++)
	{
		numerator += (inputA[i] - mA) * (inputB[i] - mB);
	}

	for(unsigned int i=0; i < count; i++)
	{
		temp = inputA[i] - mA;
		denom1 += pown(temp, 2);
	}
	temp = 0;

		for(unsigned int i=0; i < count; i++)
	{
		temp = inputB[i] - mB;
		denom2 += pown(temp, 2);
	}
	temp = 0;

	temp = denom1 * denom2;
	denominator = sqrt(temp);

	float result = numerator / denominator;

	output[4] = result;
}

// Metryka Canberra
__kernel void kernel_5(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
	float D = 0;
	for(int i = 0; i < count ; i++)
	{
		float x = fabs(inputA[i] - inputB[i]);
		D += (fabs(inputA[i] - inputB[i])) / (fabs(inputA[i]) + fabs(inputB[i]));
	}

	output[5] = D;
}

// Odleglosc Hamminga
__kernel void kernel_6(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
	float D = 0;
	for(int i = 0; i < count ; i++)
	{
		if(inputA[i] != inputB[i])
		{
			D += 1;
		}
	}
	output[6] = D;
}