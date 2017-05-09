.. BuildTestDocs documentation master file, created by
   sphinx-quickstart on Tue Apr  4 07:54:15 2017.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

buildtest Documentation
=========================================

**Author: Shahzeb Siddiqui**

Contents:

.. toctree::
   :glob:
   :maxdepth: 1
 
    
   Setup 
   Writing_Test_In_YAML    
   How_to_use_BuildTest
   Future_Work

Description
--------------------
**buildtest** is an Automatic Test Generating Framework for writing test cases 
efficiently and quickly for scientific applications. buildtest can generate 
test scripts (.sh) automatically and tests can be recreated as many times. buildtest
makes use of EasyBuild_ easyconfig files to determine which module + toolchain to use. 
You will need module environment EnvironmentModules_ or Lmod_ on your system to use this
framework 

.. _EasyBuild: https://easybuild.readthedocs.io/en/latest/
.. _EnvironmentModules: http://modules.sourceforge.net/
.. _Lmod: https://github.com/TACC/Lmod


Motivation
-----------

An HPC environment has hundreds of application that running constantly, the 
HPC engineers would build these apps and put them on production system. Some
of the application have vendor provided scripts such as **make test** or 
**ctest** that can test the software after **make** step. Unfortunately, 
these methods perform tests in the build directory and does not perform a 
"Post Install Test". Changing the vendor test script to the install
paths can be tedious and this would have to be done manually. 

Writing test scripts manually can be tedious, also there is no sharing of code 
and most likely they are not compatible to work on different systems. Easybuild
takes a step at improving application build process by automating the entire 
software workflow.

buildtest takes a step to ease testing of software with similar objectives as 
EasyBuild but focusing on Testing.

What is buildtest?
------------------


buildtest is a python script that can generate self-contained testscripts in 
shell scripts (.sh). The test scripts can be run independently but they are 
designed to work in CMake_ CTest Framework. 

BuildTest can:

 - Creates test for binary testing 
 - Generates test that requires compilation 
 - Verify modulefile can be loaded. 
 - generate tests for system packages
 - List software packages provided by MODULEPATH
 - List available toolchain based on the easyconfig files provided to BuildTest
 - List a tabular software-version relationship
 - Verbosity level to control output

.. _CMake: https://cmake.org/documentation/

Requirements
-------------

BuildTest has few dependendencies
 - Python 2.7.X

Python Packages:
 - PyYAML

Setup
-----

There is a few environment variables that need to be set prior to using this
framework. 

Environment Description:
        
    - BUILDTEST_ROOT: root directory of buildtest 
    - BUILDTEST_SOURCEDIR: source directory where YAML test scripts are picked up
    - BUILDTEST_EASYCONFIGDIR: easyconfig directory used for toolchain verification 
    - BUILDTEST_TESTDIR: directory where test scripts will be generated and used by CTEST
    - BUILDTEST_MODULEPATH: root of module tree

Clone your easyconfig repo inside buildtest repo, this will be used for toolchain verification
as a part of the Two Step Verification. See section below.

Two Step Verification
-----------------------------

BuildTest utilizes a two-step verification before creating any test case. This 
is designed to prevent buildtest from creating incorrect test cases that would 
fail during execution.

1. ModuleFile Verication
2. Easyconfig Toolchain Verification

**Module File Verification:** buildtest makes use of **$BUILDTEST_MODULEROOT** 
to find all the modules and stores the values in an array. Whenever an argument 
is passed for **--software** it is checked with the module array to make sure 
it exist. If there is no module found with the following name, the program will 
terminate immediately 

**Easyconfig Toolchain verification:** Every application is built with a 
particular toolchain in EasyBuild. In order to make sure we are building for 
the correct test in the event of multiple packages being installed with 
different toolchain we need a way to classify which package to use. For instance 
if **flex/2.6.0** is installed with **GCCcore/5.4.0**, **GCCcore/6.2.0**, and 
**dummy** toolchain then we have three instances of this package. In HMNS these 
3 instances could be in different module trees. We can perform this test by 
searching all the easyconfig files with the directory name **flex** and search 
for the tag **toolchain = { name='toolchain-name', version='toolchain-version' }**


The Toolchain verification will pass if the following condition is met:

   - software,version argument specified to buildtest matches **name**, **version** tag in easyconfig
   - toolchain argument from buildtest matches **toolchain-name**, **toolchain-version** tag in easyconfig
   - **versionsuffix** from eb file name matches the module file. 
   - For **Hierarchical Module Naming Scheme (HMNS)** modulefile: <version>-<version-suffix>.lua 
   - For **Flat Naming Scheme (FNS)** modulefile: <version>-<toolchain>-<version-suffix>.lua

Module File Check is not sufficient for checking modules in the event when there
is a match for a software package but there is a toolchain mismatch. For instance 
if Python 2.7.12 is built with foss toolchain only and the user request to build 
Python 2.7.12 with intel, the module file verification will pass but it wouldn't 
pass the Toolchain verification stage.


Testing Directory Structure
-------------------------------

BuildTest will write the test in the directory specified by **BUILDTEST_TESTDIR**. 
By default the testing directory is set to **BUILDTEST_ROOT/testing**. Recall that 
CTest is the Testing Framework that automatically generates Makefiles necessary 
to build and run the test. CTest will utilize *CMakeLists.txt* that will invoke 
CTest api to run the the test.  

**Testing CMakeList Structure Layout:** 


+----------------------------------------------------------------------+-------------------------------------------------------------------------+
|File                                                                  |       Description                                                       |
+----------------------------------------------------------------------+-------------------------------------------------------------------------+
|$BUILDTEST_TESTDIR/CMakeLists.txt                                     |       List of entries for each software                                 |
+----------------------------------------------------------------------+-------------------------------------------------------------------------+
|$BUILDTEST_TESTDIR/system/CMakeLists.txt                              |       Entry for each system package                                     |
+----------------------------------------------------------------------+-------------------------------------------------------------------------+
|$BUILDTEST_TESTDIR/system/$systempkg/CMakeLists.txt                   |       List of tests for system package                                  |
+----------------------------------------------------------------------+-------------------------------------------------------------------------+
|$BUILDTEST_TESTDIR/$software/CMakeLists.txt                           |       List of version entries for each software                         | 
+----------------------------------------------------------------------+-------------------------------------------------------------------------+
|$BUILDTEST_TESTDIR/$software/$version/CMakeLists.txt                  |       List of toolchain name entries for each version of the software   |
+----------------------------------------------------------------------+-------------------------------------------------------------------------+
|$BUILDTEST_TESTDIR/$software/$version/$toolchain-name/CMakeLists.txt  |       Entry for each toolchain version for each toolchain name          |
+----------------------------------------------------------------------+-------------------------------------------------------------------------+
|$BUILDTEST_TESTDIR/$software/$version/$toolchain/CMakeLists.txt       |       Entry for each test to run                                        |
+----------------------------------------------------------------------+-------------------------------------------------------------------------+

.. Note:: Whenever you build the test, you must specify the software and version 
   and this must match the name of the module you are trying to test, otherwise 
   there is no way of knowing what is being tested.  Each test will attempt to 
   load the application module along with the toolchain if specified prior to 
   anything.


Source Code Layout
--------------------

The source directory **BUILDTEST_SOURCEDIR** contains all the source code that 
will be used for generating the test. Here, you will find config scripts used 
for generating scripts. buildtest processes these config scripts inorder to 
generate the test.


+----------------------------------------------------+--------------------------------------------------------------------------+
|                     File                           |                                Description                               |  
+----------------------------------------------------+--------------------------------------------------------------------------+
| $BUILDTEST_SOURCEDIR/<software>/command.yaml       |       A list of binary executables and parameters to test                |  
+----------------------------------------------------+--------------------------------------------------------------------------+
| $BUILDTEST_TESTDIR/$software/config/               |       Contains the yaml config files used for building test from source  |
+----------------------------------------------------+--------------------------------------------------------------------------+
| $BUILDTEST_TESTDIR/$software/code/                 |       Directory Containing the source code, which is referenced          |
|                                                    |       by the testscript and yaml files                                   |
+----------------------------------------------------+--------------------------------------------------------------------------+
| $BUILDTEST_SOURCEDIR/system/command.yaml           |       A list of binary executables and parameters to for system packages |
+----------------------------------------------------+--------------------------------------------------------------------------+


Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
