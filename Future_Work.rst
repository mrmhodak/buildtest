.. _Future_Work:

Future Work
===========

Some future work items include the following

1. buildtest test generation with job scripts (LSF, PBS/Torque, SLURM)
-----------------------------------------------------------------------

**Description:** buildtest can generate tests (.sh) that can be run on a particular node, now we just need to let buildtest
generate job scripts so we can extend testing to all Nodes. Tests can be generated in same format as before,
maybe setup a directory $BUILDTEST_ROOT/jobs 

There would be no need for CMake configuration in creating jobfiles, we just need to specify few parameters 
like NODE, PPN, queue, and jobname

2. Testset Script customization
-------------------------------

**Description:** Right now there is no way to specify any configuration when using **--testset**. Buildtest figures out
the wrapper based on file extension and assumes the script will just run. 

Some features that need to be considered are:

1. Pass arguments into program

2. Input/Output redirection

3. Specify custom exit status code

--testset does not use YAML configurations, we might need to create custom YAML configs or setup logic
in framework for these features on the fly.


3. dry-run support to report output of test creation without writing test
-------------------------------------------------------------------------

This feature would be useful for users when writing YAML configs to just run something like --dry-run
to see the test output without actually being created. Problem is buildtest process all YAML files and 
generates all the tests, no way to build individual test at this point.


4. Integrate CDASH with buildtest
---------------------------------

**Description:**  Need to setup CDASH server to view tests through a frontest testing dashboard. Need to setup a 
MySQL or PostgresSQL database as part of setup.

buildtest could ship the CDash server as a container image, and provide instructions to create 
database and run CDash server. buildtest could provide custom script to create database tables needed
to get CDash to see tests 

5. YAML Configuration Keys
--------------------------

**Description:** Need to provide a rich set of YAML keys to help users write test configuration in buildtest framework


6. Benchmark Integration
------------------------

**Description:** Integrate application benchmarks into buildtest. buildtest should be able to install & configure benchmark
inside buildtest framework and allow means to run the test script. 

A few commands that can be useful

 - **buildtest benchmark list** - List benchmarks that are available with buildtest
 - **buildtest benchmark run benchmark-name** - Run benchmark
 - **buildtest benchmark build benchmark** - Install benchmark

7. Autodocs Sphinx Documentation
-------------------------------- 

**Description:** Provide documentation for each python module in the buildtest framework


8. Python, R, Tcl, Ruby, Perl package testing strategy
------------------------------------------------------

**Description:** Reuse tests provided by the package or create unit tests for each module provided by the package. 



