.. _Writing_Test_In_YAML:


Writing Test in YAML
====================

Writing test in YAML is easy. YAML test are processed by buildtest using the 
yaml library into a dictionary which is then processed to generate the test-script.
The buildtest will parse the YAML config and generate the build and run command line
based on the key/values provided.  


YAML Key Description
--------------------

+---------------+--------------------------------------------------------------------+
| **Key**       |                        ** Description**                            |
+---------------+--------------------------------------------------------------------+        
| Name          | Name of the test script. It must match the name of the yaml file.  |
+---------------+--------------------------------------------------------------------+        
| Source        | Name of the source file to compile. Error if file not found        |
+---------------+--------------------------------------------------------------------+
| buildopts     | build options passed to build command.                             |
+---------------+--------------------------------------------------------------------+
| buildcmd      | A list of commands to be executed in order on building.Must include|
|               | **runcmd** tag as well for running the code.If test doesn't require|
|               | anything to run, then declare runcmd with no value                 |
+---------------+--------------------------------------------------------------------+
| runcmd        | A list of commands to be executed in order after the buildcmd. The |
|               | **buildcmd** must be specified, if nothing to build set buildcmd   |
|               | key no value                                                       | 
+---------------+--------------------------------------------------------------------+
| runextracmd   | Add extra commands after running code, only used when **buildcmd** | 
|               | and **runcmd** are not specified and additional instructions need  |
|               | to be specified.                                                   |
+---------------+--------------------------------------------------------------------+
| mpi           | enable mpi. Sets the compiler wrapper accordingly.                 | 
|               |                                                                    |
|               | **value: [enabled]**                                               |
+---------------+--------------------------------------------------------------------+
| nproc         | Argument to -np to indicate number of processes to use with mpirun |
+---------------+--------------------------------------------------------------------+
| cuda          | enable cuda. Sets the compiler wrapper to nvcc. (Not implemented)  | 
|               |                                                                    |
|               | **value: [enabled]**                                               |
+---------------+--------------------------------------------------------------------+
| binaries      | list of binary command to execute in command.yaml                  |
+---------------+--------------------------------------------------------------------+
| scheduler     | Generate test for job scheduler. (Not implemented)                 |
|               |                                                                    |
|               | **value: [lsf,pbs,slurm]**                                         | 
+---------------+--------------------------------------------------------------------+


The binary test configs are stored in a file **command.yaml** which contains a 
list of executables along with any arguments. Buildtest will create a separate 
test-script for each executable. The keyword **binaries** is only specified to
command.yaml file. The binary test are specific to the software packge to test. 
Figure out the binaries in the install path for the software, typically in 
**bin** directory and add this to the command.yaml file.

**GCC BinaryTest YAML Example** 

.. program-output:: cat scripts/command.yaml


**GCC-5.4.0-2.27 buildtest Test Script**

.. program-output:: cat scripts/gcc.sh

**BuildTest YAML Hello World Example**

.. program-output:: cat scripts/hello.c.yaml

**BuildTest Hello World Test Script** 

.. program-output:: cat scripts/hello.c.sh


BuildTest can build mpi programs. It automatically detects the compiler wrapper based on file extension and the MPI wrapper.

Below is an example of OpenMPI 2.0.0 with GCC-5.4.0 that runs a matrix multiplication C program with 4 processes

**BuildTest MPI example**
 
.. program-output:: cat scripts/mpi_mm_c.yaml

.. program-output:: cat scripts/mpi_mm_c.sh



