.. BuildTestDocs documentation master file, created by
   sphinx-quickstart on Tue Apr  4 07:54:15 2017.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Documentation for BuildTest
=========================================

**Author: Shahzeb Siddiqui**

Description
--------------------
**BuildTest** is an Automatic Test Generating Framework for writing test cases more efficiently and quickly for scientific applications. The BuildTest framework relies upon your application
to use EasyBuild_ framework to build your apps. You will need modules either EnvironmentModules_ or Lmod_

.. _EasyBuild: https://easybuild.readthedocs.io/en/latest/
.. _EnvironmentModules: http://modules.sourceforge.net/
.. _Lmod: https://github.com/TACC/Lmod


What is BuildTest?
-----------------------------


BuildTest is a python script used to generate self-contained testscripts in shell scripts (.sh). The test scripts can be run independently but they are designed to work in CMake_. CTest Framework.

 - Creates test for binary testing 
 - Builds test from source using a YAML configuration syntax
 - Can create job scripts to be used with  job schedulers (lsf, pbs, slurm)
 

.. _CMake: https://cmake.org/documentation/

Setup
-----------------

1. Edit setup.py and specify path for your module tree root at **BUILDTEST_MODULEROOT**. This variable is used by **buildtest** to find modules in your system and used to verify which test can be created by buildtest.

For instance, **BUILDTEST_MODULEROOT** on my system is set to /nfs/grid/software/RHEL7/easybuild/modules/ 

.. code:: 
        
      [hpcswadm@amrndhl1157 BuildTest]$ ls -l /nfs/grid/software/RHEL7/easybuild/modules 
      total 2
      drwxr-xr-x 5 hpcswadm hpcswadm 69 Mar 27 14:25 all

2.  Specify the path for the easyconfig directory in **setup.py** for variable **BUILDTEST_EASYCONFIGDIR**. This will be used for finding the toolchains which is necessary to build the test.

.. Note:: easyconfig files not installed on the system can cause issues

3. Check if software and toolchain are processed via buildtest 

   BuildTest finds the modulefiles from *BUILDTEST_MODULEROOT* and extracts the name and version since module files are stored in format <software>/<version>. BuildTest adds software into a set to report unique software. BuildTest uses easyconfig files to extract the toolchain names by processing the toolchain field from each easyconfig and adds the toolchain to set.

.. code::    

        [hpcswadm@amrndhl1157 BuildTest]$ ./buildtest.py -ls | head -n 15
        
                       List of Unique Software: 
                      ---------------------------- 
        Advisor
        Anaconda2
        Anaconda3
        Autoconf
        Automake
        Autotools
        BEDTools
        BWA
        BamTools
        Bison
        Boost
        Bowtie  


        [hpcswadm@amrndhl1157 BuildTest]$ ./buildtest.py -lt
 
                List of Toolchains:
                --------------------
              
        GCCcore 6.2.0
        dummy dummy
        iimpic 2017.01-GCC-5.4.0-2.27
        GCC 5.4.0-2.27
        iccifortcuda 2017.1.132-GCC-5.4.0-2.27
        GCC 6.2.0-2.27
        gompic 2016.03
        iompi 2017.01
        gompi 2016.09
        iccifort 2017.1.132-GCC-5.4.0-2.27
        GCCcore 5.4.0
        gcccuda 2016.03
        foss 2016.03
        intel 2017.01
        goolfc 2016.03
        foss 2016.09
        gompi 2016.03
        iimpi 2017.01-GCC-5.4.0-2.27


Testing Directory Structure
-------------------------------
BuildTest will write the test in the directory specified by **BUILDTEST_TESTDIR**. By default the testing directory is set to **BUILDTEST_ROOT/testing**. Recall that CTest is the Testing Framework that automatically
generates Makefiles necessary to build and run the test. CTest will utilize *CMakeLists.txt* that will invoke CTest api to run the the test. CMakeLists.txt will for each software/version 

Testing Structure Layout


+--------------------------------------------------------------------------------------------+-------------------------------------------------------------------------+
|File                                                                                        |       Description                                                       |
+--------------------------------------------------------------------------------------------+-------------------------------------------------------------------------+
|$BUILDTEST_TESTDIR/CMakeLists.txt                                                           |       List of entries for each software                                 |
+--------------------------------------------------------------------------------------------+-------------------------------------------------------------------------+
|$BUILDTEST_TESTDIR/$software/CMakeLists.txt                                                 |       List of version entries for each software                         | 
+--------------------------------------------------------------------------------------------+-------------------------------------------------------------------------+
|$BUILDTEST_TESTDIR/$software/$version/CMakeLists.txt                                        |       List of toolchain name entries for each version of the software   |
+--------------------------------------------------------------------------------------------+-------------------------------------------------------------------------+
|$BUILDTEST_TESTDIR/$software/$version/$toolchain-name/CMakeLists.txt                        |       Entry for each toolchain version for each toolchain name          |
+--------------------------------------------------------------------------------------------+-------------------------------------------------------------------------+
|$BUILDTEST_TESTDIR/$software/$version/$toolchain-name/$toolchain-version/CMakeLists.txt     |       Entry for each test to run                                        |
+--------------------------------------------------------------------------------------------+-------------------------------------------------------------------------+

.. Note:: Whenever you build the test, you must specify the software and version and this must match the name of the module you are trying to test, otherwise there is no way of knowing what is being tested.  Each test will attempt to load the application module along with the toolchain if specified prior to anything.

--------------------
Source Code Layout
--------------------

The source directory **BUILDTEST_SOURCEDIR** contains all the source code that will be used for generating the test. Here, you will find config scripts used for generating scripts. BuildTest process these config scripts inorder to 
generate the test.


+--------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------+
|File                                                                                        |       Description                                                             |
+--------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------+
|$BUILDTEST_SOURCEDIR/<software>/command.txt                                                 |       A list of binary executables and parameters to test                     |
+--------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------+
|$BUILDTEST_TESTDIR/$software/config/                                                        |       Contains the config files used for building test from source            | 
+--------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------+
|$BUILDTEST_TESTDIR/$software/code/                                                          |       Directory Containing the source code, which is referenced by the test   |
+--------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------+


.. toctree::
   :maxdepth: 2
   :caption: Contents:



Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
