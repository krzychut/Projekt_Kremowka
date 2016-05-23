/*
Base code for the application sampled from:
http://www.codeproject.com/Articles/110685/Part-1-OpenCL-Portable-Parallelism
*/

#include <iostream>
#include <cstdio>
#include <string.h>
#include <algorithm>
using namespace std;

#define __NO_STD_VECTOR // Use cl::vector and cl::string and
#define __NO_STD_STRING // not STL versions, more on this later
#include <CL/cl.h>


#define DATA_SIZE (100000)
#define MAX_SOURCE_SIZE 0x100000
#define KERNELS_COUNT 7

int main(int argc, char* argv[])
{
	int devType = CL_DEVICE_TYPE_GPU;

	if (argc > 1) {
		devType = CL_DEVICE_TYPE_CPU;
		cout << "Using: CL_DEVICE_TYPE_CPU" << endl;
	}
	else {
		cout << "Using: CL_DEVICE_TYPE_GPU" << endl;
	}

	cl_int err;     // error code returned from api calls
/*
	size_t global;  // global domain size for our calculation
	size_t local;   // local domain size for our calculation
*/
	cl_platform_id cpPlatform; // OpenCL platform
	cl_device_id device_id;    // compute device id
	cl_context context;        // compute context
	cl_command_queue commands; // compute command queue
	cl_program program;        // compute program
	cl_kernel kernel[KERNELS_COUNT] = { NULL };          // compute kernel

							   // Connect to a compute device
	err = clGetPlatformIDs(1, &cpPlatform, NULL);
	if (err != CL_SUCCESS) {
		cerr << "Error: Failed to find a platform!" << endl;
		return EXIT_FAILURE;
	}

	// Get a device of the appropriate type
	err = clGetDeviceIDs(cpPlatform, devType, 1, &device_id, NULL);
	if (err != CL_SUCCESS) {
		cerr << "Error: Failed to create a device group!" << endl;
		return EXIT_FAILURE;
	}

	// Create a compute context
	context = clCreateContext(0, 1, &device_id, NULL, NULL, &err);
	if (!context) {
		cerr << "Error: Failed to create a compute context!" << endl;
		return EXIT_FAILURE;
	}

	// Create a command queue
	commands = clCreateCommandQueue(context, device_id, CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE, &err);
	if (!commands) {
		cerr << "Error: Failed to create a command queue!" << endl;
		return EXIT_FAILURE;
	}

	// Load kernel source file from taskParallel.cl
	cout << "Opening taskParallel.cl for reading..." << endl;
	FILE* fp;
	fp = fopen("taskParallel.cl", "r");
	if (!fp) {
		cerr << "Error: Failed to open taskParallel.cl for reading!" << endl;
	}
	cout << "Allocating memory for the kernel source..." << endl;
	char* KernelSource = (char*)malloc(MAX_SOURCE_SIZE * sizeof(char));
	if (!KernelSource) {
		cerr << "Error: Failed to allocate memory for the kernel source!" << endl;
	}
	cout << "Copying taskParallel.cl into the source array..." << endl;
	size_t SourceSize;
	SourceSize = fread(KernelSource, 1 * sizeof(char), MAX_SOURCE_SIZE, fp);


	// Create the compute program from the source buffer
	cout << "Creating compute program with the source code provided" << endl;
	program = clCreateProgramWithSource(context, 1,
		(const char **)&KernelSource,
		(const size_t*)&SourceSize, &err);
	if (!program) {
		cerr << "Error: Failed to create compute program!" << endl;
		return EXIT_FAILURE;
	}

	// Build the program executable
	err = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
	if (err != CL_SUCCESS) {
		size_t len;
		char buffer[2048];

		cerr << "Error: Failed to build program executable!" << endl;
		clGetProgramBuildInfo(program, device_id, CL_PROGRAM_BUILD_LOG,
			sizeof(buffer), buffer, &len);
		cerr << buffer << endl;
		cout << "Gibe char to exit, b0ss" << endl;
		getchar();
		exit(1);
	}

	// Create the compute kernel in the program
	for (int i = 0; i < KERNELS_COUNT; i++)
	{
		char tmp[10];
		sprintf(tmp, "%d", i);
		char kernel_ID[16];
		strcpy(kernel_ID, "kernel_");
		strcat(kernel_ID, tmp);
		cout << "Creating: " << kernel_ID << endl;
		kernel[i] = clCreateKernel(program, kernel_ID, &err);
		if (!kernel[i] || err != CL_SUCCESS) {
			cerr << "Error: Failed to create compute kernel!" << endl;
			getchar();
			exit(1);
		}
	}

	// Create data for the run
	float* dataA = new float[DATA_SIZE];    // original data set given to device
	float* dataB = new float[DATA_SIZE];    // original data set given to device
	float* results = new float[KERNELS_COUNT]; // results returned from device
	unsigned int correct;               // number of correct results returned
	cl_mem inputA;                       // device memory used for the input array
	cl_mem inputB;
	cl_mem output;                      // device memory used for the output array
										// Fill the vector with random float values
	unsigned int count = DATA_SIZE;
	unsigned int kernelsCount = KERNELS_COUNT;
	for (unsigned int i = 0; i < count; i++)
		dataA[i] = rand() / (float)RAND_MAX;
	for (unsigned int i = 0; i < count; i++)
		dataB[i] = rand() / (float)RAND_MAX;

	// Create the device memory vectors
	inputA = clCreateBuffer(context, CL_MEM_READ_ONLY,
		sizeof(float) * count, NULL, NULL);
	inputB = clCreateBuffer(context, CL_MEM_READ_ONLY,
		sizeof(float) * count, NULL, NULL);
	output = clCreateBuffer(context, CL_MEM_WRITE_ONLY,
		sizeof(float) * kernelsCount, NULL, NULL);
	if (!inputA || !inputB || !output) {
		cerr << "Error: Failed to allocate device memory!" << endl;
		getchar();
		exit(1);
	}

	// Transfer the input vector into device memory
	err = clEnqueueWriteBuffer(commands, inputA,
		CL_TRUE, 0, sizeof(float) * count,
		dataA, 0, NULL, NULL);
	if (err != CL_SUCCESS) {
		cerr << "Error: Failed to write to source array inputA!" << endl;
		getchar();
		exit(1);
	}
	err = clEnqueueWriteBuffer(commands, inputB,
		CL_TRUE, 0, sizeof(float) * count,
		dataB, 0, NULL, NULL);
	if (err != CL_SUCCESS) {
		cerr << "Error: Failed to write to source array inputB!" << endl;
		getchar();
		exit(1);
	}

	// Set the arguments to the compute kernels
	err = 0;
	for (int i = 0; i < KERNELS_COUNT; i++)
	{
		err = clSetKernelArg(kernel[i], 0, sizeof(cl_mem), &inputA);
		err |= clSetKernelArg(kernel[i], 1, sizeof(cl_mem), &inputB);
		err |= clSetKernelArg(kernel[i], 2, sizeof(cl_mem), &output);
		err |= clSetKernelArg(kernel[i], 3, sizeof(const unsigned int), &count);
		if (err == CL_INVALID_KERNEL)
			cout << "Invalid kernel: kernel_" << i << endl;
		if (err != CL_SUCCESS) {
			cerr << "Error: Failed to set kernel arguments! " << err << " kernel ID_" << i << endl;
			getchar();
			exit(1);
		}
	}


	/*
		// Get the maximum work group size for executing the kernel on the device
		err = clGetKernelWorkGroupInfo(kernel[0], device_id,
			CL_KERNEL_WORK_GROUP_SIZE,
			sizeof(local), &local, NULL);
		if (err != CL_SUCCESS) {
			cerr << "Error: Failed to retrieve kernel work group info! "
				<< err << endl;
			exit(1);
		}

		// Execute the kernel over the vector using the
		// maximum number of work group items for this device
		global = count;
		err = clEnqueueNDRangeKernel(commands, kernel[0],
			1, NULL, &global, &local,
			0, NULL, NULL);
		if (err != CL_SUCCESS) {
			cerr << "Error: Failed to execute kernel!" << endl;
			return EXIT_FAILURE;
		}
	*/

	//Enqueue all the kernels to be executed
	for (int i = 0; i < KERNELS_COUNT; i++)
	{
		err = clEnqueueTask(commands, kernel[i], 0, NULL, NULL);
		if (err != CL_SUCCESS) {
			cerr << "Failed to enqueue kernel: ID_" << i << endl;
			getchar();
			exit(1);
		}
	}

	// Wait for all commands to complete
	clFinish(commands);

	// Read back the results from the device to verify the output
	err = clEnqueueReadBuffer(commands, output,
		CL_TRUE, 0, sizeof(float) * kernelsCount,
		results, 0, NULL, NULL);
	if (err != CL_SUCCESS) {
		cerr << "Error: Failed to read output array! " << err << endl;
		getchar();
		exit(1);
	}

	// Validate our results
	correct = 0;
	if (dataA[0] + dataB[0] == results[0])
	{
		correct++;
	}
	if (dataA[1] * dataB[1] == results[1])
	{
		correct++;
	}

	cout << "Calculations complete. Results:" << endl;
	for (int i = 0; i < KERNELS_COUNT; i++)
	{
		cout << "kernel_" << i << ": " << results[i] << endl;
	}

	// Shutdown and cleanup
	delete[] dataA; delete[] dataB; delete[] results;

	clReleaseMemObject(inputA);
	clReleaseMemObject(inputB);
	clReleaseMemObject(output);
	clReleaseProgram(program);
	for (int i = 0; i < KERNELS_COUNT; i++)
	{
		clReleaseKernel(kernel[i]);
	}
	clReleaseCommandQueue(commands);
	clReleaseContext(context);

	getchar();
	return 0;
}