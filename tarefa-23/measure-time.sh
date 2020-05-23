#!/bin/bash

sh compile.sh

time ./mm
time ./mm_openmp
time ./mm_cuda

exit 0