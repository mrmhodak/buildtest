.. BuildTestDocs documentation master file, created by
   sphinx-quickstart on Tue Apr  4 07:54:15 2017.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

BuildTest Documentation
=========================================

**Author: Shahzeb Siddiqui**

.. toctree::
   :glob:
   :maxdepth: 2
   
   Writing_Test_In_YAML    
   BuildTest_Setup

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


Two Step Verification
-----------------------------

BuildTest utilizes a two-step verification before creating any test case. This is designed to prevent buildtest from creating incorrect test cases that would fail during execution.

1. ModuleFile Verication
2. Easyconfig Toolchain Verification

**Module File Verification:** buildtest makes use of **$BUILDTEST_MODULEROOT** to find all the modules and stores the values in an array. Whenever an argument is passed for **--software** it is checked with the module array to make sure it exist. If there is no module found with the following name, the program will terminate immediately 

**Easyconfig Toolchain verification:** Each software version is built with a particular toolchain in EasyBuild. In order to make sure we are building for the correct test in the event of multiple packages being installed with different toolchain we need a way to classify which package to use. For instance if **flex/2.6.0** is installed with **GCCcore/5.4.0**, **GCCcore/6.2.0**, and **dummy** toolchain then we have three instances of this package. In HMNS these 3 instances could be in different module trees. We can perform this test by searching all the easyconfig files with the directory name **flex** and search for the tag **toolchain = { name='toolchain-name', version='toolchain-version' }**


The Toolchain verification will pass if the following condition is met:

        - software,version argument specified to buildtest matches **name**, **version** tag in easyconfig
        - toolchain argument from buildtest matches **toolchain-name**, **toolchain-version** tag in easyconfig
        - **versionsuffix** from eb file name matches the module file. 
                - For **Hierarchical Module Naming Scheme (HMNS)** modulefile: <version>-<version-suffix>.lua 
                - For **Flat Naming Scheme (FNS)** modulefile: <version>-<toolchain>-<version-suffix>.lua

Module File Check is not sufficient for checking modules in the event when there is a match for a software package but there is a toolchain mismatch. For instance if Python 2.7.12 is built with foss toolchain only and the user request to build Python 2.7.12 with intel, the module file verification will pass but it wouldn't pass the Toolchain verification stage.


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
