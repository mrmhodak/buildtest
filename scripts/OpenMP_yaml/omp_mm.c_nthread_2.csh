#!/bin/csh
module purge
module load GCC/5.4.0-2.27
setenv OMP_NUM_THREADS 2
gcc -o omp_mm.c.exe /hpc/grid/hpcws/hpcengineers/siddis14/buildtest-framework/buildtest-configs/ebapps/GCC/code/omp_mm.c -O2 -fopenmp

