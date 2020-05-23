/*
Sequencial
real    1m11.421s
user    1m10.983s
sys     0m0.232s

Paralelo
real    0m40.724s
user    2m33.424s
sys     0m3.183s

Paralelo - GPU - OpenMP
real    0m4.863s
user    0m3.624s
sys     0m1.211s

Paralelo - GPU - CUDA
real    0m0.442s
user    0m0.174s
sys     0m0.264s

=================================================================================

OpenMP:
    ==8143== Event result:
    Invocations                                Event Name         Min         Max         Avg       Total
    Device "GeForce GT 1030 (0)"
        Kernel: mm$_omp_fn$0
            1                            warps_launched          72          72          72          72

    ==8143== Metric result:
    Invocations                               Metric Name                        Metric Description         Min         Max         Avg
    Device "GeForce GT 1030 (0)"
        Kernel: mm$_omp_fn$0
            1                 warp_execution_efficiency                 Warp Execution Efficiency      86.81%      86.81%      86.81%

CUDA:
    ==8528== Profiling result:
    No events/metrics were profiled.
*/

#include <stdio.h>
#include <stdlib.h>

__global__
void mm(double *a, double *b, double *c, int width) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    int j = blockIdx.y * blockDim.y + threadIdx.y;

    double sum = 0;
    for (int k = 0; k < width; k++) {
        double x = a[i * width + k];
        double y = b[k * width + j];
        sum += x * y;
    }

    c[i * width + j] = sum;
}

int main(){

    int width = 2000;
    int size = width * width * sizeof(double);

    double *a = (double*) malloc(size);
    double *b = (double*) malloc(size);
    double *c = (double*) malloc(size);

    for (int i = 0; i < width; i++) {
        for (int j = 0; j < width; j++) {
            a[i * width + j] = i;
            b[i * width + j] = j;
            c[i * width + j] = 0;
        }
    }

    int block_size = 44;
    int grid_size = ((width - 1) / block_size) + 1;

    double *d_a, *d_b, *d_c;

    cudaMalloc((void **) &d_a, size);
    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);

    cudaMalloc((void **) &d_b, size);
    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

    cudaMalloc((void **) &d_c, size);
    
    dim3 dimGrid(grid_size, grid_size, 1);
    dim3 dimBlock(block_size, block_size, 1);

    mm<<<dimGrid,dimBlock>>>(d_a, d_b, d_c, width);

    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

    // for(int i = 0; i < width; i++) {
    //     for(int j = 0; j < width; j++) {
    //         int index = i * width + j;
    //         printf("\n c[%d][%d] = %f", i, j, c[index]);
    //     }
    // }

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
}