.. _Architecture:

buildtest Architecture
=======================

This section will explain how the buildtest framework is designed in regards
to

* Module, Toolchain, easyconfig check
* Testing Directory Structure
* CTest configuration
* Source Directory Structure

Three Step Verification
------------------------

BuildTest performs a three-step verification before creating any test case. This 
is designed to prevent buildtest from creating testscripts that would fail 
during execution.

1. ModuleFile Verication
2. Toolchain verfication
3. Easyconfig Verification

ModuleFile Verification
~~~~~~~~~~~~~~~~~~~~~~~

**Module File Verification:** buildtest makes use of **$BUILDTEST_MODULE_EBROOT** 
to find all the modules and stores the values in an array. Whenever an argument 
is passed for **--software** and **--toolchain** it is checked with the module 
array to make sure it exist. If there is no module found with the following 
name, the program will terminate immediately. Module check is done for both software
and toolchain since both are installed as modules in the system 

.. code:: 

       [siddis14@amrndhl1157 buildtest-framework]$ buildtest -s GCC/5.4.0-2.27 -t xzy/1.0
        Checking Software: GCC/5.4.0-2.27  ... SUCCESS
        Checking Software: xzy/1.0 ... FAILED
        Can't find software: xzy 1.0

        Writing Logfile:  /hpc/grid/hpcws/hpcengineers/siddis14/buildtest-framework/log/buildtest_09_57_28_08_2017.log


Toolchain Verification
~~~~~~~~~~~~~~~~~~~~~~

Argument to **--toolchain** is checked with the toolchain list that stores
all valid toolchains defined by **eb --list-toolchains**. If argument is not
found in list then buildtest will terminate immediately.

Argument to **--toolchain** needs to be explicit if module is hidden file or not.
For instance, if GCCcore 5.4.0 is hidden module, buildtest will not find the module
until it is specified as **-t GCCcore/.5.4.0**

.. code::

        [siddis14@amrndhl1157 buildtest-framework]$ buildtest -s GCC/5.4.0-2.27 -t GCCcore/5.4.0
        Checking Software: GCC/5.4.0-2.27  ... SUCCESS
        Checking Software: GCCcore/5.4.0 ... FAILED
        Can't find software: GCCcore 5.4.0

        Writing Logfile:  /hpc/grid/hpcws/hpcengineers/siddis14/buildtest-framework/log/buildtest_10_02_28_08_2017.log


Specify GCCcore as hidden file will pass the toolchain check since GCCcore module is hidden.


Easyconfig Verification
~~~~~~~~~~~~~~~~~~~~~~~

.. code:: 

        [siddis14@amrndhl1157 buildtest-framework]$ buildtest -s GCC/5.4.0-2.27 -t GCCcore/.5.4.0
        Checking Software: GCC/5.4.0-2.27  ... SUCCESS
        Checking Software: GCCcore/.5.4.0  ... SUCCESS
        Checking Toolchain: GCCcore/.5.4.0 ... SUCCESS
        Checking easyconfig file ... FAILED
        ERROR: Attempting to  find easyconfig file  GCC-5.4.0-2.27-GCCcore-5.4.0.eb
        Writing Logfile:  /hpc/grid/hpcws/hpcengineers/siddis14/buildtest-framework/log/buildtest_10_03_28_08_2017.log


.. Note:: 

        Toolchain verification will happen after the module check, this assumes the system has a 
        module file, but we need to determine if its a hidden module and whether it is a valid eb toolchain

Every application is built with a particular toolchain in EasyBuild. 
In order to make sure we are building for the correct test in the event
of multiple packages are installed with different toolchain we need a 
way to classify which package to use. For instance if **flex/2.6.0** is 
installed with **GCCcore/5.4.0**, **GCCcore/6.2.0**, and **dummy** toolchain 
then we have three instances of this package. In 
**Hierarchical Module Naming Scheme (HMNS)**  these 3 instances could be in 
different module trees. We can perform this test by searching all the easyconfig 
files with the directory name **flex** and search for the tag 
**toolchain = { name='toolchain-name', version='toolchain-version' }**


The easyconfig verification will pass if all of the conditions are met:

   1. software,version argument specified to buildtest matches 
      **name**, **version** tag in easyconfig

   2. toolchain argument from buildtest matches 
      **toolchain-name**, **toolchain-version** tag in easyconfig

   3. **versionsuffix** from eb file name matches the module file. 

   4. For **Hierarchical Module Naming Scheme (HMNS)** 
      modulefile: <version>-<version-suffix>.lua 

   5. For **Flat Naming Scheme (FNS)** 
      modulefile: <version>-<toolchain>-<version-suffix>.lua

Module File Check is not sufficient for checking modules in the event when there
is a match for a software package but there is a toolchain mismatch. For instance 
if R/3.3.1 is built with intel/2017.01 toolchain and the user request to build 
R/3.3.1 with foss/2016.09, the module file & toolchain verification will pass 
but it wouldn't pass the easyconfig verification if there is no easyconfig found.


.. code-block:: bash

        [siddis14@amrndhl1295 buildtest-framework]$ buildtest -s R/3.3.1 -t foss/.2016.09
        Checking Software: R/3.3.1  ... SUCCESS
        Checking Software: foss/.2016.09  ... SUCCESS
        Checking Toolchain: foss/.2016.09 ... SUCCESS
        Checking easyconfig file ... FAILED
        ERROR: Attempting to  find easyconfig file  R-3.3.1-foss-2016.09.eb
        Writing Logfile:  /hpc/grid/hpcws/hpcengineers/siddis14/buildtest-framework/log/buildtest_10_32_28_08_2017.log


Testing Directory Structure
-------------------------------

BuildTest will write the test in the directory specified by **BUILDTEST_TESTDIR**. 
By default the testing directory is set to **BUILDTEST_ROOT/testing**. Recall that 
CTest is the Testing Framework that automatically generates Makefiles necessary 
to build and run the test. CTest will utilize *CMakeLists.txt* that will invoke 
CTest api to run the the test.  

.. include:: Architecture/cmakelist_layout.txt

Whenever you build the test, you must specify the software and version 
and this must match the name of the module you are trying to test, otherwise 
there is no way of knowing what is being tested.  Each test will attempt to 
load the application module along with the toolchain if specified prior to 
anything. Similarly, toolchain must be specified with the exception of dummy 
toolchain. If toolchain is hidden module in your system, you must specify 
your toolchain version accordingly

CMake Configuration
-------------------

CMakeLists.txt for $BUILDTEST_TESTDIR/ebapps/GCC/CMakeLists.txt would like
this for GCC-5.4.0-2.27 and GCC-6.2.0-2.27 test

.. program-output:: cat scripts/Architecture/GCC/CMakeLists.txt

The CMakeLists.txt in your test directory will look something like this

.. program-output:: cat scripts/Architecture/GCC/test/CMakeLists.txt


Testsets
---------

Test sets are meant to reuse YAML configs between different apps. For instance,
we can have all the MPI wrappers (OpenMPI, MPICH, MVAPICH, etc...) use
one set of YAML files. For applications like R, Python, Perl, etc... that comes 
with 100s of subpackages, we only have the scripts and buildtest will automatically
build the testscripts. buildtest will process subdirectories and properly name the 
tests for CTest to avoid name conflict



If you build R without testset it will build not build the tests for R packages 
that are stored in R-buildtest-config repo

.. program-output:: cat scripts/Architecture/R-3.3.1_without_testset.txt


If you run ``buildtest -s R/3.3.1 -t intel/2017.01`` without ``--testset R`` flag, buildtest
will only build tests from YAML files in $BUILDTEST_SOURCE. If ``--testset R`` was enabled 
buildtest will also build tests from $BUILDTEST_R_DIR. To illustrate this see what happens
when enabling ``--testset R``

.. program-output:: cat scripts/Architecture/R-3.3.1_with_testset.txt



Source Code Layout
--------------------

The source directory **BUILDTEST_SOURCEDIR** contains all the source code that 
will be used for generating the test. Here, you will find config scripts used 
for generating scripts. buildtest processes these config scripts inorder to 
generate the test.


+----------------------------------------------------+--------------------------------------------------------------------------+
|                     File                           |                                Description                               |  
+----------------------------------------------------+--------------------------------------------------------------------------+
| $BUILDTEST_SOURCEDIR/$software/command.yaml        |       A list of binary executables and parameters to test                |  
+----------------------------------------------------+--------------------------------------------------------------------------+
| $BUILDTEST_SOURCEDIR/$software/config/             |       Contains the yaml config files used for building test from source  |
+----------------------------------------------------+--------------------------------------------------------------------------+
| $BUILDTEST_SOURCEDIR/$software/code/               |       Directory Containing the source code, which is referenced          |
|                                                    |       by the testscript and yaml files                                   |
+----------------------------------------------------+--------------------------------------------------------------------------+
| $BUILDTEST_SOURCEDIR/system/command.yaml           |       A list of binary executables and parameters to for system packages |
+----------------------------------------------------+--------------------------------------------------------------------------+
