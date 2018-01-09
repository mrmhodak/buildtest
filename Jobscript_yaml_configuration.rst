.. _Jobscript_yaml_configuration:


Configuring Job scripts from yaml configuration
===============================================

buildtest can generate job scripts for the test script from the same yaml 
configuration. This feature may be useful for users interested in testing 
their application in a parallel environment.

Configuring LSF job script
--------------------------

If you have LSF, you can use the **scheduler** key word and specify **jobslots**
which will convert your command into **#BSUB -n <JobSlots>**

.. code::

   name: mpi_mm.c
   source: mpi_mm.c
   mpi: enabled
   buildopts: -O2
   nproc: 4
   scheduler: "LSF"
   jobslots: 4


Configuring SLURM job script
----------------------------

In SLURM, the scheduler and jobslots value will convert to **#SBATCH -N <JobSlots>**

.. code::

   name: mpi_mm.f
   source: mpi_mm.f
   mpi: enabled
   buildopts: -O2
   nproc: 4
   scheduler: "SLURM"
   jobslots: 4


In the future, there will be more yaml key options to tweak job parameters. 

By default job scripts will be created in the test directory. The example above
are part of MPI testset so we will build the tests with OpenMPI and GCC as the
toolchain

.. code::

   [siddis14@amrndhl1157 buildtest-framework]$ buildtest -s OpenMPI/2.0.0 -t GCC/5.4.0-2.27 --testset MPI
   -bash: buildtest: command not found
   [siddis14@amrndhl1157 buildtest-framework]$ source setup.sh
   [siddis14@amrndhl1157 buildtest-framework]$ buildtest -s OpenMPI/2.0.0 -t GCC/5.4.0-2.27 --testset MPI
   Checking for easyconfig file: OpenMPI-2.0.0-GCC-5.4.0-2.27.eb ... FOUND
   Checking easyconfig conditional checks ... SUCCESS
   [BINARYTEST]: Processing YAML file for  OpenMPI/2.0.0 GCC/5.4.0-2.27  at  /lustre/workspace/home/siddis14/buildtest-framework/buildtest-configs/ebapps/OpenMPI/command.yaml

   Generating 22 binary tests for Application: OpenMPI/2.0.0
   Binary Tests are written in /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/OpenMPI/2.0.0/GCC/5.4.0-2.27
   [SOURCETEST]: Processing all YAML files in  /lustre/workspace/home/siddis14/buildtest-framework/buildtest-configs/mpi/config
   Generating 21 Source Tests and writing at  /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/OpenMPI/2.0.0/GCC/5.4.0-2.27
   Writing Log file:  /lustre/workspace/home/siddis14/buildtest-framework/log/OpenMPI/2.0.0/GCC/5.4.0-2.27/buildtest_10_36_09_01_2018.log

buildtest will create job scripts with the following extensions

* LSF job scripts will have extension **.lsf** 
* SLURM job scripts will have extension **.slurm**

Now lets check the test directory for the newly created job scripts.

.. code::

   [siddis14@amrndhl1157 buildtest-framework]$ ls -l /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/OpenMPI/2.0.0/GCC/5.4.0-2.27/*.lsf
   -rw-rw-r-- 1 siddis14 amer 228 Jan  9 10:36 /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/OpenMPI/2.0.0/GCC/5.4.0-2.27/mpi_mm.c.lsf

        
   [siddis14@amrndhl1157 buildtest-framework]$ ls -l /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/OpenMPI/2.0.0/GCC/5.4.0-2.27/*.slurm
   -rw-rw-r-- 1 siddis14 amer 232 Jan  9 10:36 /lustre/workspace/home/siddis14/buildtest-framework/testing/ebapp/OpenMPI/2.0.0/GCC/5.4.0-2.27/mpi_mm.f.slurm



Let's take a look into the job scripts.


Generated LSF Job
-----------------

.. code:: shell

   #!/bin/sh
   #BSUB -n 4
   module purge
   module load GCC/5.4.0-2.27
   module load OpenMPI/2.0.0
   mpicc -o mpi_mm.c.exe /lustre/workspace/home/siddis14/buildtest-framework/buildtest-configs/mpi/code/mpi_mm.c -O2
   mpirun -np 4 ./mpi_mm.c.exe

Generated SLURM Job 
-------------------

.. code:: shell

   #!/bin/sh
   #SBATCH -N 4
   module purge
   module load GCC/5.4.0-2.27
   module load OpenMPI/2.0.0
   mpifort -o mpi_mm.f.exe /lustre/workspace/home/siddis14/buildtest-framework/buildtest-configs/mpi/code/mpi_mm.f -O2
   mpirun -np 4 ./mpi_mm.f.exe
