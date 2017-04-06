.. _Writing_Test_In_YAML:

Writing Test in YAML
-----------------------

Writing test in YAML is easy. YAML test are processed by buildtest using the yaml library into a dictionary which is then processed to generate the test-script.

The binary test is stored in a file **command.yaml** which contains a list of commands along with any arguments. Each entry creates a separate test-script to test the binary. 

An example of the GCC binary test is shown below.
.. image:: _static/binarytest.png
:alt: binary test example


buildtest will generate a test as follows.

.. image:: _static/gcc_binarytest.png

YAML Key Description
--------------------

+---------------+--------------------------------------------------------------------+
| Key           |            Description                                             |
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
|               | value: [enabled]                                                   |
+---------------+--------------------------------------------------------------------+
| cuda          | enable cuda. Sets the compiler wrapper to nvcc                     | 
|               |                                                                    |
|               | value: [enabled]                                                   |
+---------------+--------------------------------------------------------------------+
| binaries      | list of binary command to execute in command.yaml                  |
+---------------+--------------------------------------------------------------------+
| scheduler     | Generate test for job scheduler. Feature not implemented           |
|               |                                                                    |
|               | value: [lsf,pbs,slurm]                                             | 
+---------------+--------------------------------------------------------------------+


