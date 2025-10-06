#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <curand_kernel.h>
#include <time.h>

#define N 1000
#define num_threads 1000

int random_five(int thread, curandState state);

int random_seven(int thread, unsigned long long seed);

__global__ void sum_kernel(int *Ad);
__global__ void random_kernel(int *Ad, unsigned long long seed);

int main(void)
{
    int *A;
    int *Ad;
    srand(time(NULL));

    size_t bytes = sizeof(int) * N;

    A = (int*) malloc(bytes);
    cudaMalloc(&Ad, bytes);

    random_kernel<<<1,num_threads>>>(Ad, time(NULL));
    cudaMemcpy(A, Ad, bytes, cudaMemcpyDeviceToHost);
    
    cudaDeviceSynchronize();
    
    sum_kernel<<<1,7>>>(Ad);

    cudaFree(Ad);

    return 0;
}


__global__ void random_kernel(int *Ad, unsigned long long seed)
{
    int i = threadIdx.x;
    int j = blockIdx.x * 1024;
    Ad[i + j] = random_seven(i, seed);
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

__device__ int random_seven(int thread, unsigned long long seed)
{
    curandState state;
    curand_init(seed, thread, 0, &state);

    int num;
    do {
        int a = random_five(thread, state);
        int b = random_five(thread, state); 
        num = a * 5 + b;     
    } while (num >= 21);     
    printf("%i\n", num % 7 + 1);    
    return num % 7 + 1; 
}

__device__ int random_five(int thread, curandState state)
{
    int r;
    int limit = RAND_MAX - (RAND_MAX % 5);
    do {
        r = (curand(&state));
    } while (r >= limit);

    return r % 5;
}