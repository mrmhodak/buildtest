#!/bin/csh
module purge 
module load GCCcore/6.4.0
setenv OMP_NUM_THREADS 2
gcc -o omp_getEnvInfo.c.exe /home/siddis14/buildtest-configs/buildtest/ebapps/gcccore/code/omp_getEnvInfo.c -O2 -fopenmp
./omp_getEnvInfo.c.exe