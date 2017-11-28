#!/bin/csh
module purge
module load GCC/5.4.0-2.27
setenv OMP_NUM_THREADS 2
gcc -o omp_getEnvInfo.c.exe /hpc/grid/hpcws/hpcengineers/siddis14/buildtest-framework/buildtest-configs/ebapps/GCC/code/omp_getEnvInfo.c -O2 -fopenmp

