// Metryka Lorentza
__kernel void kernel_0(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
	float result;
	for(int i = 0; i < count; i++)
	{
		result += log(1.0f + fabs(inputA[i] - inputB[i]));
	}
	output[0] = result;
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
// Odleglosc Czekanowskiego
__kernel void kernel_7(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
	float A = 0, B = 0;
	for ( int i = 0; i < count ; i++)
	{
		fabs ( A += ( inputA[i] - inputB[i]))
	}
	for( i = 0; i < count ; i++)
	{
        B += ( inputA[i] + inputB[i])
	}
	output[7] = A / B;
}

// Odleglosc  Wave Hedges
__kernel void kernel_8(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
	float A = 0;
	for ( int i = 0; i < count ; i++)
	{
        A += ( fabs ( inputA[i] - inputB[i]) / ( fmax( inputA[i], inputB[i])));
	}
	output[8] = A;
}

// Odleglosc Kumar - Hassebrook
__kernel void kernel_9(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
	float A = 0, B = 0, C = 0;
	for ( int i = 0; i < count ; i++)
	{
        A += inputA[i] * inputB[i];
	}
	for ( i = 0; i < count ; i++)
	{
        B += inputA[i] * inputA[i];
	}
	for ( i = 0; i < count ; i++)
	{
        C += inputB[i] * inputB[i];
	}
	output[9] = A / ( B + C - A);
}

// Odleglosc Ruzick
__kernel void kernel_10(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
	float A = 0, B = 0;
	for ( int i = 0; i < count ; i++)
	{
		A += fmin ( inputA[i], inputB[i]);
	}
	for( i = 0; i < count ; i++)
	{
        B += fmax ( inputA[i], inputB[i]);
	}
	output[10] = A / B;
}

// Odleglosc Tanimoto
__kernel void kernel_11(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
	float A = 0, B = 0, C = 0;
	for ( int i = 0; i < count ; i++)
	{
        A += fmax ( inputA[i], inputB[i]) - fmin ( inputA[i], inputB[i]);
	}
	for ( i = 0; i < count ; i++)
	{
        B += fmax ( inputA[i], inputB[i]);
	}
	output[11] = A / B;
}

// Odleglosc Matusita
__kernel void kernel_12(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
	float A = 0;
	for ( int i = 0; i < count ; i++)
	{
        A += sqrt ( inputA[i] * inputB[i]) ;
	}
	output[12] =  sqrt ( 2 - 2 * A);
}

// Odleglosc Jeffreysa
__kernel void kernel_13(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
    float A = 0;
    for(int i = 0 ; i < count ; i++)
    {
        A += (inputA[i] - inputB[i])*log(inputA[i]/inputB[i]);
    }
    output[13] = A;
}

// Odleglosc Kullback-Leibler
__kernel void kernel_14(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
    float A = 0;
    for(int i = 0 ; i < count ; i++)
    {
        A += inputA[i]*log(inputA[i]/inputB[i]);
    }
    output[14] = A;
}

//K Divergence
__kernel void kernel_15(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
    float A = 0;
    for(int i = 0 ; i < count ; i++)
    {
        A += inputA[i]*log(2*inputA[i]/(inputA[i]+inputB[i]));
    }
    output[15] = A;
}

// Neyman
__kernel void kernel_16(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
    float A = 0;
    for(int i = 0 ; i < count ; i++)
    {
        A += (inputA[i]-inputB[i])*(inputA[i]-inputB[i])/inputB[i];
    }
    output[16] = A;
}

// Taneja
__kernel void kernel_17(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
    float A = 0;
    for(int i = 0 ; i < count ; i++)
    {
        A += ((inputA[i]+inputB[i])/2)*log((inputA[i]+inputB[i])/(2*sqrt(inputA[i]*inputB[i])));
    }
    output[17] = A;
}

// Divergence
__kernel void kernel_18(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
    float A = 0;
    for(int i = 0 ; i < count ; i++)
    {
        A += (inputA[i]-inputB[i])*(inputA[i]-inputB[i])/(inputA[i]+inputB[i])/(inputA[i]+inputB[i]);
    }
    output[18] = 2*A;
}

// Probabilistic Symmetric
__kernel void kernel_19(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
    float A = 0;
    for(int i = 0 ; i < count ; i++)
    {
        A += (inputA[i]-inputB[i])*(inputA[i]-inputB[i])/(inputA[i]+inputB[i]);
    }
    output[19] = 2*A;
}

// Clark
__kernel void kernel_20(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
    float A = 0;
    float dif;
    for(int i = 0 ; i < count ; i++)
    {
        dif = inputA[i] - inputB[i];
        if(dif < 0)
            dif *= (-1);
        A += dif / (inputA[i] + inputB[i]);
    }
    output[20] = sqrt(A);
}

// Additive Symmetric
__kernel void kernel_21(__global float* inputA, __global float* inputB, __global float* output, const unsigned int count)
{
    float A = 0;
    for(int i = 0 ; i < count ; i++)
    {
        A += (inputA[i]-inputB[i])*(inputA[i]-inputB[i])*(inputA[i]+inputB[i])/(inputA[i]*inputB[i]);
    }
    output[21] = 2*A;
}
