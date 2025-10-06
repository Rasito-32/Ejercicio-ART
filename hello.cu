#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <curand_kernel.h>
#include <time.h>

#define N 1024000
#define num_threads 1024

int random_five(int thread, int seed);

int random_seven(int thread);

__global__ void sum_kernel(int *Ad);
__global__ void random_kernel(int *Ad);

int main(void)
{
    int *A;
    int *Ad;
    srand(time(NULL));

    size_t bytes = sizeof(int) * N;

    A = (int*) malloc(bytes);
    cudaMalloc(&Ad, bytes);

    random_kernel<<<1000,num_threads>>>(Ad);
    cudaMemcpy(A, Ad, bytes, cudaMemcpyDeviceToHost);
    
    cudaDeviceSynchronize();
    
    sum_kernel<<<1,7>>>(Ad);

    cudaFree(Ad);

    return 0;
}


__global__ void random_kernel(int *Ad)
{
    int i = threadIdx.x;
    int j = blockIdx.x * 1024;
    Ad[i + j] = random_seven(i);
}

__global__ void sum_kernel(int *Ad)
{
    int id = threadIdx.x + 1;
    float result = 0;
    for(int i = 0; i < N; i++)
    {
        if(Ad[i] == id)
            result ++;
    }
    result = (float) result/N * 100;
    printf("Aparaciones del %i es de: %f\n", id, result);
}

__device__ int random_seven(int thread)
{
    int flag = 0;
    int result = 0;
    int count = 0;
    while (flag == 0)
    {
        int num = 5 * random_five(thread, count * 1000) + random_five(thread, count * 1000 - 1);
        if(num < 21)
        {
            result = num % 7 + 1;
            flag = 1;
        }
        count ++;
    }
    return result;
}

__device__ int random_five(int thread, int seed)
{
    curandState state;
    curand_init(seed, thread, 0, &state); // 1234 is the seed, can be changed
    int random = (curand(&state)%5) + 1;

    return random;
}