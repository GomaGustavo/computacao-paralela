#!/bin/bash

sh compile.sh

./mm > mm.out
./mm_openmp > mm_openmp.out
# ./mm_cuda > mm_cuda.out

diff mm.out mm_openmp.out
# diff mm.out mm_cuda.out

exit 0